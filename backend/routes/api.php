<?php

use App\Http\Controllers\BookController;
use Illuminate\Support\Facades\Route;

// Every route here is served under /api, e.g. GET /api/books.

Route::get('/books', [BookController::class, 'index']);
