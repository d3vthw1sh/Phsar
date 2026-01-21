import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/blocs/products/products_bloc.dart';
import '../../../logic/blocs/products/products_state.dart';
import '../../../data/models/product.dart';
import '../../../core/utils.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 5000);
  bool _inStockOnly = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _focusNode = FocusNode();
    if (_searchController.text.isEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<Product> _applyFilters(List<Product> products) {
    return products.where((product) {
      // Search query filter
      final query = _searchController.text.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      // Category filter
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      // Price filter
      final matchesPrice =
          product.price >= _priceRange.start &&
          product.price <= _priceRange.end;

      // Stock filter
      final matchesStock = !_inStockOnly || product.stock > 0;

      return matchesQuery && matchesCategory && matchesPrice && matchesStock;
    }).toList();
  }

  List<String> _getUniqueCategories(List<Product> products) {
    final categories = <String>{'All'};
    for (final product in products) {
      if (product.category.isNotEmpty) {
        categories.add(product.category);
      }
    }
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Search Products',
          style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                ],
              ),
            );
          }

          if (state is ProductsLoaded) {
            final categories = _getUniqueCategories(state.products);
            final filteredProducts = _applyFilters(state.products);

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Search Field
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  // Filters Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Filter
                        Text(
                          'Category',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categories.map((category) {
                              final isSelected = _selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = selected
                                          ? category
                                          : 'All';
                                    });
                                  },
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide(
                                    color: isSelected
                                        ? cs.primary
                                        : cs.outline.withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? cs.primary
                                        : cs.onSurface,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Price Range Filter
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price Range',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${AppUtils.formatPrice(_priceRange.start)} - ${AppUtils.formatPrice(_priceRange.end)}',
                              style: TextStyle(
                                color: cs.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RangeSlider(
                          values: _priceRange,
                          min: 0,
                          max: 5000,
                          divisions: 50,
                          labels: RangeLabels(
                            AppUtils.formatPrice(_priceRange.start),
                            AppUtils.formatPrice(_priceRange.end),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _priceRange = values;
                            });
                          },
                          activeColor: cs.primary,
                          inactiveColor: cs.outline.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 24),

                        // Stock Filter
                        Row(
                          children: [
                            Checkbox(
                              value: _inStockOnly,
                              onChanged: (value) {
                                setState(() {
                                  _inStockOnly = value ?? false;
                                });
                              },
                            ),
                            const Text('In Stock Only'),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Results
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Results (${filteredProducts.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (filteredProducts.isEmpty)
                    SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text('No products found'),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            context.go('/product/${product.id}');
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
