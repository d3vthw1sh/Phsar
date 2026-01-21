import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_state.dart';
import '../../logic/blocs/cart/cart_bloc.dart';
import '../../logic/blocs/cart/cart_state.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final bool showCart;
  final bool showProfile;
  final bool showBack;

  const AppAppBar({
    super.key,
    this.title = 'phsar',
    this.showSearch = true,
    this.showCart = true,
    this.showProfile = true,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: cs.onSurface),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/products');
                }
              },
            )
          : null,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface),
      ),
      centerTitle: true,
      actions: [
        if (showSearch)
          IconButton(
            icon: Icon(Icons.search, color: cs.onSurface),
            onPressed: () {
              context.push('/search');
            },
          ),
        if (showCart)
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int count = 0;
              if (state is CartLoaded) {
                count = state.items.length;
              }
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: cs.onSurface,
                    ),
                    onPressed: () => context.push('/cart'),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: cs.secondary, // Orange Accent
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        if (showProfile)
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(Icons.person_outline, color: cs.onSurface),
                onPressed: () {
                  if (state is AuthAuthenticated) {
                    context.push('/profile');
                  } else {
                    context.push('/login');
                  }
                },
              );
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
