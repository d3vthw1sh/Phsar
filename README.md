<img width="384" height="857" alt="image" src="https://github.com/user-attachments/assets/9ab09088-5e3b-42c3-9658-eb3c6a81bfaa" />
<img width="386" height="857" alt="image" src="https://github.com/user-attachments/assets/1702f2e8-0894-4235-aadd-686d3efd417b" />
<img width="387" height="840" alt="image" src="https://github.com/user-attachments/assets/b7730c68-6e1d-46dd-b62e-ec65700d477a" />
<img width="387" height="857" alt="image" src="https://github.com/user-attachments/assets/e7dad021-1e92-40f9-bdb6-50bc3bf9bf98" />
<img width="385" height="857" alt="image" src="https://github.com/user-attachments/assets/de42163d-92a0-4ca3-8da8-ed359da7ee97" />
<img width="383" height="855" alt="image" src="https://github.com/user-attachments/assets/45681c07-d8ce-4155-b017-2c24ff97a9de" />
<img width="383" height="857" alt="image" src="https://github.com/user-attachments/assets/4ec09638-c187-4ed2-aa4f-df30db583998" />
<img width="383" height="860" alt="image" src="https://github.com/user-attachments/assets/3a776ef6-5dd8-4dd9-894e-b93ba646b0e0" />
<img width="386" height="857" alt="image" src="https://github.com/user-attachments/assets/338ef5b8-7a30-4fe7-afb0-7bacba642bff" />

# Flutter + Laravel E-Commerce App

A full-stack e-commerce application built with **Flutter** (frontend) and **Laravel** (backend).  
Includes authentication, product browsing, cart system, checkout, admin tools, and order management.

## Features

### User Features

- Product listing with pagination
- Product detail screen with image carousel
- Add to cart, remove, and update quantity
- Cart persistence using local storage
- Checkout with shipping address
- Order success and failure screens
- Email/password authentication
- Google login
- User profile
- Order history
- Product search with filters (category, price range, stock)
- Product reviews _(planned)_

### Admin Features

- Admin console screen
- View all users
- Delete users
- Order management (view, mark delivered, delete)
- Product CRUD _(planned)_
- Review moderation _(planned)_

## Project Structure

```
root/
│── backend/         # Laravel API
│── frontend/        # Flutter mobile app
│── howtostarttheproject.md
│── needtoworkon.md
│── thingstoworkinminor.md
```

## Tech Stack

**Frontend:** Flutter, Dart, BLoC, GoRouter  
**Backend:** Laravel 12, MySQL, JWT Auth, TailwindCSS, Vite  
**Database:** MySQL  
**Authentication:** JWT  
**Media:** Laravel public storage + Flutter assets

# Getting Started

## 1. Clone the Project

```bash
git clone <repository-url>
cd ecommercial
```

## 2. Backend Setup (Laravel)

```bash
cd backend
composer install

cp .env.example .env
php artisan key:generate

php artisan migrate --seed
php artisan storage:link

php artisan serve --host=127.0.0.1 --port=8000
```

Backend runs at:

```
http://127.0.0.1:8000
```

## 3. Frontend Setup (Flutter)

```bash
cd ../frontend
flutter pub get
flutter run
```

On Android emulator:

```
10.0.2.2:8000
```

## Quick Verification

1. Visit: `http://127.0.0.1:8000/api/products`
2. Flutter app loads product images
3. Default admin account:

```
Email: admin@example.com
Password: password123
```

# Development Roadmap

### Completed

- Product listing and detail
- Cart system
- Authentication flow
- Checkout flow
- Admin console
- Success/failure screens
- Search with filters

### In Progress

- Login flow improvements
- Order history improvements

### Planned

- Reviews
- Search & filters
- Admin product CRUD
- Stripe integration
- UI/UX polish
- Full testing

# API Overview

### Auth

```
POST /api/register
POST /api/login
GET  /api/profile
```

### Products

```
GET /api/products
GET /api/products/{id}
POST /api/products/{id}/review
```

### Orders

```
POST /api/checkout
GET  /api/my-orders
GET  /api/orders
```

# Developer Commands

### Laravel

```
php artisan serve
php artisan migrate --seed
php artisan test
```

### Flutter

```
flutter run
flutter build apk
flutter test
```

# Known Issues

- Some product images need conversion
- Order history incomplete
- Admin product CRUD missing

# License

This project is for educational and portfolio use.
