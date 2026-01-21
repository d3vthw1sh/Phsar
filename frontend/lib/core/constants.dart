import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  // Auth
  static const String login = '/api/users/login';
  static const String register = '/api/users/register';
  static const String profile = '/api/users/profile';
  static const String forgotPassword = '/api/users/forgot-password';
  static const String resetPassword =
      '/api/users/reset-password'; // Append /:token
  // Logged-in change password (protected route)
  static const String changePassword = '/api/users/password-reset';
  static const String verifyEmail = '/api/users/verify'; // Append /:token

  // Products
  static const String products = '/api/products';
  static const String productReviews = '/reviews'; // Used as suffix

  // Orders
  static const String orders = '/api/orders';
  static const String myOrders = '/api/orders/my-orders';

  // Stripe
  static const String createCheckoutSession =
      '/api/stripe/create-checkout-session';

  static String resolveImageUrl(String path) {
    // If it's already an asset path, return as-is
    if (path.startsWith('assets/')) {
      return path;
    }

    // If the path is already a full URL, adjust localhost for Android emulator if needed
    if (path.startsWith('http')) {
      if (Platform.isAndroid && path.contains('localhost')) {
        return path.replaceAll('localhost', '10.0.2.2');
      }
      return path;
    }

    // For backend images, construct the full URL
    String normalizedPath = path;

    // If path doesn't start with /, add it
    if (!path.startsWith('/')) {
      normalizedPath = '/$path';
    }

    // If path doesn't include /uploads/, add it
    if (!normalizedPath.contains('/uploads/')) {
      normalizedPath = '/uploads$normalizedPath';
    }

    return '$baseUrl$normalizedPath';
  }
}
