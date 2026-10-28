<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class BookController extends Controller
{
    /**
     * GET /api/books: every book with its authors, genre and copy counts.
     */
    public function index(): JsonResponse
    {
        $books = DB::connection('lib_catalog')->select("
            SELECT
              b.book_id,
              b.title,
              b.title_banglish,
              b.published_year,
              g.name AS genre,
              (SELECT GROUP_CONCAT(a.name ORDER BY a.name SEPARATOR ', ')
                 FROM book_author AS ba
                 JOIN author AS a ON a.author_id = ba.author_id
                WHERE ba.book_id = b.book_id)                      AS authors,
              (SELECT COUNT(*) FROM book_copy AS c
                WHERE c.book_id = b.book_id AND c.status <> 'withdrawn') AS total_copies,
              (SELECT COUNT(*) FROM book_copy AS c
                WHERE c.book_id = b.book_id AND c.status = 'available')  AS available_copies
            FROM book AS b
            LEFT JOIN genre AS g ON g.genre_id = b.genre_id
            ORDER BY b.title
        ");

        return response()->json($books);
    }
}
