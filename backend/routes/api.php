<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\BookController;
use Illuminate\Support\Facades\Route;

// Every route here is served under /api, e.g. GET /api/books.

// {id} in a URL must be a number; anything else answers 404.
Route::pattern('id', '[0-9]+');

// Anyone can call these.
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

// Only signed-in users can call these; anyone else gets 401.
Route::middleware('auth:sanctum')->group(function () {
    // Sign-in
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);
    Route::patch('/me', [AuthController::class, 'updateMe']);

    Route::get('/books', [BookController::class, 'index']);
});
