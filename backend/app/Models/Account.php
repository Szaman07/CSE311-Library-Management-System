<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

// A person who can sign in: one row of lib_members.account.
class Account extends Authenticatable
{
    // Lets an account create sign-in tokens (stored in lib_members.personal_access_tokens).
    use HasApiTokens;

    protected $connection = 'lib_members';
    protected $table = 'account';
    protected $primaryKey = 'account_id';

    // The table has created_at but no updated_at, so Laravel must not fill them.
    public $timestamps = false;

    // Never send the password hash back in JSON.
    protected $hidden = ['password_hash'];
}
