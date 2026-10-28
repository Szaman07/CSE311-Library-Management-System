<?php

use Illuminate\Support\Facades\Route;

// The backend only serves the API (routes/api.php). The pages are the React app.
Route::get('/', function () {
    return response()->json([
        'message' => 'Library Management System API. The pages are at http://localhost:5173.',
    ]);
});
