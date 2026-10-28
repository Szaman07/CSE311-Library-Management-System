<?php

namespace App\Http\Controllers;

use App\Models\Account;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    /**
     * POST /api/auth/login
     * Sends: { "email": "...", "password": "..." }
     */
    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        // Checks the email and password against lib_members.account.
        if (! Auth::attempt($data)) {
            abort(401, 'Wrong email or password.');
        }

        $me = $request->user();

        // Only active accounts may sign in.
        if ($me->status !== 'active') {
            Auth::guard('web')->logout();
            abort(403, 'This account is '.$me->status.'.');
        }

        // A new session id after login stops session fixation attacks.
        $request->session()->regenerate();

        DB::connection('lib_members')->update(
            'UPDATE account SET last_login_at = NOW() WHERE account_id = ?',
            [$me->account_id]
        );

        // refresh() reads the row again, so the answer shows the new last_login_at.
        return response()->json($me->refresh());
    }

    /**
     * POST /api/auth/register: a student signs up.
     * The account stays pending until a librarian approves it.
     */
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:100'],
            'email' => ['required', 'email', 'max:150', 'unique:lib_members.account,email'],
            'password' => ['required', 'string', 'min:8'],
            'student_no' => [
                'required', 'string', 'max:20', 'unique:lib_members.account,student_no',
            ],
            'phone' => ['nullable', 'string', 'max:20'],
        ]);

        $db = DB::connection('lib_members');
        $db->insert(
            'INSERT INTO account (name, email, password_hash, student_no, phone)
             VALUES (?, ?, ?, ?, ?)',
            [
                $data['name'],
                $data['email'],
                Hash::make($data['password']),   // never store the password itself
                $data['student_no'],
                $data['phone'] ?? null,
            ]
        );

        $account = Account::find($db->getPdo()->lastInsertId());

        return response()->json($account, 201);
    }

    /**
     * POST /api/auth/logout
     */
    public function logout(Request $request): Response
    {
        Auth::guard('web')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->noContent();
    }

    /**
     * GET /api/me: my account, my active card, and whether I may borrow.
     */
    public function me(Request $request): JsonResponse
    {
        $me = $request->user();

        $card = DB::connection('lib_members')->selectOne(
            "SELECT card_no, expires_on FROM library_card
             WHERE account_id = ? AND status = 'active'",
            [$me->account_id]
        );

        $catalog = DB::connection('lib_catalog');
        $openLoans = $catalog->selectOne(
            'SELECT COUNT(*) AS n FROM loan WHERE account_id = ? AND returned_at IS NULL',
            [$me->account_id]
        )->n;
        $blocking = $catalog->selectOne(
            'SELECT COUNT(*) AS n FROM loan_fine_status
             WHERE account_id = ? AND blocks_borrowing = 1',
            [$me->account_id]
        )->n;

        return response()->json($me->toArray() + [
            'card' => $card,
            'open_loans' => $openLoans,
            'borrowing_blocked' => $blocking > 0 ? 1 : 0,
        ]);
    }

    /**
     * PATCH /api/me: change my phone number or my password.
     * Sends: { "phone": "..." } and/or { "password": "..." }
     */
    public function updateMe(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['sometimes', 'nullable', 'string', 'max:20'],
            'password' => ['sometimes', 'string', 'min:8'],
        ]);

        $me = $request->user();
        $db = DB::connection('lib_members');

        if (array_key_exists('phone', $data)) {
            $db->update(
                'UPDATE account SET phone = ? WHERE account_id = ?',
                [$data['phone'], $me->account_id]
            );
        }
        if (isset($data['password'])) {
            $db->update(
                'UPDATE account SET password_hash = ? WHERE account_id = ?',
                [Hash::make($data['password']), $me->account_id]
            );
        }

        return response()->json($me->refresh());
    }
}
