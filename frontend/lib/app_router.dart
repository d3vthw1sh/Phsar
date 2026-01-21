import 'package:go_router/go_router.dart';

// Screens
import 'presentation/screens/general/splash_screen.dart';
import 'presentation/screens/general/landing_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/registration_screen.dart';
import 'presentation/screens/auth/forgot_password_screen.dart';
import 'presentation/screens/products/products_screen.dart';
import 'presentation/screens/products/product_detail_screen.dart';
import 'presentation/screens/products/search_screen.dart';
import 'presentation/screens/cart/cart_screen.dart';
import 'presentation/screens/cart/checkout_screen.dart';
import 'presentation/screens/orders/order_history_screen.dart';
import 'presentation/screens/admin/admin_console_screen.dart';
import 'presentation/screens/general/success_screen.dart';
import 'presentation/screens/general/cancel_screen.dart';
import 'presentation/screens/profile/user_profile_screen.dart';
import 'presentation/screens/orders/order_details_screen.dart';
import 'data/models/order.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/forgot',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          return SearchScreen(initialQuery: query);
        },
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/order-details',
        builder: (context, state) {
          final order = state.extra as Order;
          return OrderDetailsScreen(order: order);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const UserProfileScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminConsoleScreen(),
      ),
      GoRoute(
        path: '/success',
        builder: (context, state) => const SuccessScreen(),
      ),
      GoRoute(
        path: '/cancel',
        builder: (context, state) => const CancelScreen(),
      ),
    ],
  );
}
