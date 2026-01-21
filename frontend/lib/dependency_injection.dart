import 'package:flutter_bloc/flutter_bloc.dart';

// Services
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/product_service.dart';
import 'data/services/order_service.dart';

// Blocs
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/products/products_bloc.dart';
import 'logic/blocs/product_detail/product_detail_bloc.dart';
import 'logic/blocs/cart/cart_bloc.dart';
import 'logic/blocs/orders/orders_bloc.dart';
import 'logic/blocs/admin/admin_bloc.dart';

List<BlocProvider> globalProviders() {
  return [
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authService: AuthService()),
    ),
    BlocProvider<ProductsBloc>(
      create: (context) => ProductsBloc(productService: ProductService()),
    ),
    BlocProvider<ProductDetailBloc>(
      create: (context) => ProductDetailBloc(productService: ProductService()),
    ),
    BlocProvider<CartBloc>(create: (context) => CartBloc()),
    BlocProvider<OrdersBloc>(
      create: (context) => OrdersBloc(orderService: OrderService()),
    ),
    BlocProvider<AdminBloc>(
      create: (context) =>
          AdminBloc(apiService: ApiService(), productService: ProductService()),
    ),
  ];
}
