<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;

// A person who can sign in: one row of lib_members.account.
class Account extends Authenticatable
{
    protected $connection = 'lib_members';
    protected $table = 'account';
    protected $primaryKey = 'account_id';

    // The table has created_at but no updated_at, so Laravel must not fill them.
    public $timestamps = false;

    // Our password column is called password_hash, not password.
    protected $authPasswordName = 'password_hash';

    // Never send the password hash back in JSON.
    protected $hidden = ['password_hash'];
}
