import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../logic/blocs/products/products_bloc.dart';
import '../../logic/blocs/products/products_state.dart';
import '../../data/models/product.dart';
import '../../core/utils.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final BuildContext context;

  ProductSearchDelegate(this.context);

  List<Product> _filter(List<Product> products, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return products;
    return products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext ctx) {
    final state = ctx.read<ProductsBloc>().state;
    if (state is ProductsLoaded) {
      final results = _filter(state.products, query);
      if (results.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text('No matching products found'),
              const SizedBox(height: 8),
              Text(
                'Try different keywords',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: results.length,
        itemBuilder: (_, index) {
          final product = results[index];
          return _buildProductTile(ctx, product);
        },
      );
    }
    if (state is ProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return const Center(child: Text('Load products to search'));
  }

  @override
  Widget buildSuggestions(BuildContext ctx) {
    final state = ctx.watch<ProductsBloc>().state;

    if (query.isEmpty) {
      return _buildEmptySearchHints(ctx);
    }

    if (state is ProductsLoaded) {
      final suggestions = _filter(state.products, query).take(8).toList();
      if (suggestions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text('No suggestions found'),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (_, index) {
          final product = suggestions[index];
          return _buildProductTile(ctx, product, isSuggestion: true);
        },
      );
    }
    if (state is ProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return const Center(child: Text('Load products to search'));
  }

  Widget _buildEmptySearchHints(BuildContext ctx) {
    final state = ctx.read<ProductsBloc>().state;
    if (state is ProductsLoaded) {
      final categories = _getUniqueCategories(state.products);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Popular Categories',
            style: Theme.of(ctx).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.take(6).map((category) {
              return ActionChip(
                label: Text(category),
                onPressed: () {
                  query = category;
                  showResults(ctx);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Recent Products', style: Theme.of(ctx).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...state.products.take(5).map((product) {
            return _buildProductTile(ctx, product);
          }),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildProductTile(
    BuildContext ctx,
    Product product, {
    bool isSuggestion = false,
  }) {
    final cs = Theme.of(ctx).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          close(ctx, product.id);
          ctx.go('/product/${product.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: isSuggestion ? 60 : 80,
                  height: isSuggestion ? 60 : 80,
                  color: Colors.grey[200],
                  child: product.images.isNotEmpty
                      ? Image.asset(
                          product.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                            );
                          },
                        )
                      : Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.brand.toUpperCase(),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          AppUtils.formatPrice(product.price),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        if (product.stock > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'In Stock',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Out of Stock',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getUniqueCategories(List<Product> products) {
    final categories = <String>{};
    for (final product in products) {
      if (product.category.isNotEmpty) {
        categories.add(product.category);
      }
    }
    return categories.toList();
  }
}
