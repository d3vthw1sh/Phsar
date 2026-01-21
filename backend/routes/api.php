<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\StripeController;
use Tymon\JWTAuth\Http\Middleware\Authenticate as JwtAuth;

/*
|--------------------------------------------------------------------------
| PUBLIC ROUTES
|--------------------------------------------------------------------------
| These routes DO NOT require login or JWT token.
*/

// Authentication
Route::post('/users/register', [AuthController::class, 'register']);
Route::post('/users/login', [AuthController::class, 'login']);
Route::post('/users/google-login', [AuthController::class, 'googleLogin']);

// Products (public browsing)
Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/search', [ProductController::class, 'search']);
Route::get('/products/{id}', [ProductController::class, 'show']);

// Stripe Payment (supports both guest and authenticated checkout)
Route::post('/stripe/create-checkout-session', [StripeController::class, 'createCheckoutSession']);


/*
|--------------------------------------------------------------------------
| PROTECTED ROUTES (JWT REQUIRED)
|--------------------------------------------------------------------------
| These routes REQUIRE Authorization: Bearer <token>.
| Laravel 12 Minimal uses direct middleware declaration.
*/

Route::middleware([JwtAuth::class])->group(function () {

    // -------------------------
    // USER ROUTES
    // -------------------------
    Route::get('/users', [AuthController::class, 'allUsers']);
    Route::get('/users/profile', [AuthController::class, 'profile']);
    Route::delete('/users/{id}', [AuthController::class, 'deleteUser']);
    Route::get('/users/verify-email', [AuthController::class, 'verifyEmail']);
    Route::post('/users/password-reset-request', [AuthController::class, 'passwordResetRequest']);
    Route::post('/users/password-reset', [AuthController::class, 'passwordReset']);

    // -------------------------
    // PRODUCT REVIEWS
    // -------------------------
    Route::post('/products/reviews/{id}', [ProductController::class, 'createReview']);
    Route::put('/products/{productId}/{reviewId}', [ProductController::class, 'deleteReview']);

    // -------------------------
    // ADMIN PRODUCT MANAGEMENT
    // -------------------------
    Route::post('/products', [ProductController::class, 'store']);
    Route::put('/products/{id}', [ProductController::class, 'update']);
    Route::delete('/products/{id}', [ProductController::class, 'destroy']);
    Route::get('/reviews', [ProductController::class, 'allReviews']);

    // -------------------------
    // ORDER SYSTEM (NO STRIPE)
    // -------------------------
    Route::post('/checkout', [OrderController::class, 'checkout']);
    Route::get('/orders/my-orders', [OrderController::class, 'myOrders']);
    Route::get('/orders', [OrderController::class, 'index']);
    Route::get('/orders/user/{id}', [OrderController::class, 'userOrders']);
    Route::put('/orders/{id}/delivered', [OrderController::class, 'markDelivered']);
    Route::delete('/orders/{id}', [OrderController::class, 'destroy']);
});
