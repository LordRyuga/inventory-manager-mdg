import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/styles/app_styles.dart';
import 'add_edit_product_page.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _selectedCategory = 'All';
  String _selectedStockFilter = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetAllProductsEvent());
    context.read<ProductBloc>().add(GetCategoriesEvent());
  }

  void _showDeleteConfirmation(BuildContext context, int productId, String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "$productName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ProductBloc>().add(DeleteProductEvent(productId));
              },
              style: TextButton.styleFrom(
                foregroundColor: AppStyles.errorColor,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _applyFilters() {
    if (_searchQuery.isNotEmpty) {
      context.read<ProductBloc>().add(SearchProductEvent(_searchQuery));
    } else if (_selectedCategory != 'All') {
      context.read<ProductBloc>().add(GetProductsByCategoryEvent(_selectedCategory));
    } else if (_selectedStockFilter == 'In Stock') {
      context.read<ProductBloc>().add(GetProductsByStockStatusEvent(true));
    } else if (_selectedStockFilter == 'Out of Stock') {
      context.read<ProductBloc>().add(GetProductsByStockStatusEvent(false));
    } else {
      context.read<ProductBloc>().add(GetAllProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppStyles.spacingMD),
            child: SearchBarWidget(
              hintText: 'Search products...',
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _applyFilters();
              },
            ),
          ),
          
          // Filter Chips
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacingMD),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            // Category Filters
                            FilterChip(
                              label: const Text('All'),
                              selected: _selectedCategory == 'All',
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = 'All';
                                  _selectedStockFilter = 'All';
                                });
                                _applyFilters();
                              },
                            ),
                            const SizedBox(width: AppStyles.spacingSM),
                            ...state.categories.map((category) => Padding(
                              padding: const EdgeInsets.only(right: AppStyles.spacingSM),
                              child: FilterChip(
                                label: Text(category),
                                selected: _selectedCategory == category,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = selected ? category : 'All';
                                    _selectedStockFilter = 'All';
                                  });
                                  _applyFilters();
                                },
                              ),
                            )),
                            
                            // Stock Status Filters
                            const SizedBox(width: AppStyles.spacingMD),
                            FilterChip(
                              label: const Text('In Stock'),
                              selected: _selectedStockFilter == 'In Stock',
                              onSelected: (selected) {
                                setState(() {
                                  _selectedStockFilter = selected ? 'In Stock' : 'All';
                                  _selectedCategory = 'All';
                                });
                                _applyFilters();
                              },
                            ),
                            const SizedBox(width: AppStyles.spacingSM),
                            FilterChip(
                              label: const Text('Out of Stock'),
                              selected: _selectedStockFilter == 'Out of Stock',
                              onSelected: (selected) {
                                setState(() {
                                  _selectedStockFilter = selected ? 'Out of Stock' : 'All';
                                  _selectedCategory = 'All';
                                });
                                _applyFilters();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Product List
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Operation completed successfully'),
                      backgroundColor: AppStyles.successColor,
                    ),
                  );
                  context.read<ProductBloc>().add(GetAllProductsEvent());
                  context.read<ProductBloc>().add(GetCategoriesEvent());
                } else if (state is ProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppStyles.errorColor,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const LoadingWidget();
                } else if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.inventory_2_outlined,
                      title: 'No Products Found',
                      subtitle: _searchQuery.isNotEmpty 
                          ? 'Try adjusting your search or filters'
                          : 'Add your first product to get started',
                      action: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddEditProductPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductBloc>().add(GetAllProductsEvent());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppStyles.spacingMD),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(productId: product.id),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddEditProductPage(product: product),
                              ),
                            );
                          },
                          onDelete: () {
                            _showDeleteConfirmation(context, product.id, product.name);
                          },
                        );
                      },
                    ),
                  );
                } else if (state is ProductError) {
                  return EmptyStateWidget(
                    icon: Icons.error_outline,
                    title: 'Something went wrong',
                    subtitle: state.message,
                    action: ElevatedButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(GetAllProductsEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditProductPage(),
            ),
          );
        },
        backgroundColor: AppStyles.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}