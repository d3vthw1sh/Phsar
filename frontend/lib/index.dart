// Models
export 'data/models/user.dart';
export 'data/models/product.dart';
export 'data/models/order.dart';
export 'data/models/cart_item_model.dart';

// Services
export 'data/services/api_service.dart';
export 'data/services/auth_service.dart';
export 'data/services/product_service.dart';
export 'data/services/search_service.dart';
export 'data/services/order_service.dart';
export 'data/services/stripe_service.dart';

// Blocs - Auth
export 'logic/blocs/auth/auth_bloc.dart';
export 'logic/blocs/auth/auth_event.dart';
export 'logic/blocs/auth/auth_state.dart';

// Blocs - Products
export 'logic/blocs/products/products_bloc.dart';
export 'logic/blocs/products/products_event.dart';
export 'logic/blocs/products/products_state.dart';

// Blocs - Product Detail
export 'logic/blocs/product_detail/product_detail_bloc.dart';
export 'logic/blocs/product_detail/product_detail_event.dart';
export 'logic/blocs/product_detail/product_detail_state.dart';

// Blocs - Cart
export 'logic/blocs/cart/cart_bloc.dart';
export 'logic/blocs/cart/cart_event.dart';
export 'logic/blocs/cart/cart_state.dart';

// Blocs - Orders
export 'logic/blocs/orders/orders_bloc.dart';
export 'logic/blocs/orders/orders_event.dart';
export 'logic/blocs/orders/orders_state.dart';

// Blocs - Admin
export 'logic/blocs/admin/admin_bloc.dart';
export 'logic/blocs/admin/admin_event.dart';
export 'logic/blocs/admin/admin_state.dart';

// Screens - Auth
export 'presentation/screens/auth/login_screen.dart';
export 'presentation/screens/auth/registration_screen.dart';
export 'presentation/screens/auth/forgot_password_screen.dart';

// Screens - Products
export 'presentation/screens/products/products_screen.dart';
export 'presentation/screens/products/product_detail_screen.dart';
export 'presentation/screens/products/search_screen.dart';

// Screens - Cart
export 'presentation/screens/cart/cart_screen.dart';
export 'presentation/screens/cart/checkout_screen.dart';
export 'presentation/screens/cart/success_screen.dart';
export 'presentation/screens/cart/cancel_screen.dart';

// Screens - Orders
export 'presentation/screens/orders/order_history_screen.dart';

// Screens - Admin
export 'presentation/screens/admin/admin_console_screen.dart';
export 'presentation/screens/admin/users_tab.dart';
export 'presentation/screens/admin/orders_tab.dart';
export 'presentation/screens/admin/products_tab.dart';

// Screens - General
export 'presentation/screens/general/splash_screen.dart';
export 'presentation/screens/general/landing_screen.dart';

// Widgets
export 'presentation/widgets/product_card.dart';
export 'presentation/widgets/cart_item.dart';
export 'presentation/widgets/custom_button.dart';
export 'presentation/widgets/custom_field.dart';
export 'presentation/widgets/app_appbar.dart';
export 'presentation/widgets/bottom_nav.dart';

// Core
export 'core/constants.dart';

export 'core/theme.dart';
export 'core/utils.dart';

// Router
export 'app_router.dart';

// Dependency Injection
export 'dependency_injection.dart';
