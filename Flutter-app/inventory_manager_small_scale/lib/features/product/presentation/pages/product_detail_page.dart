import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/utils/app_utils.dart';
import 'add_edit_product_page.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductEntity? _product;

  @override
  void initState() {
    print(_product);
    super.initState();
    context.read<ProductBloc>().add(GetProductByIdEvent(widget.productId));
  }

  void _showDeleteConfirmation() {
    AppUtils.showConfirmDialog(
      context: context,
      title: 'Delete Product',
      content:
          'Are you sure you want to delete "${_product?.name}"? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDangerous: true,
    ).then((confirmed) {
      if (confirmed == true && _product != null && mounted) {
        context.read<ProductBloc>().add(DeleteProductEvent(_product!.id));
      }
    });
  }

  void _editProduct() {
    if (_product != null) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => AddEditProductPage(product: _product),
            ),
          )
          .then((result) {
            if (result == true && mounted) {
              // Refresh product data after edit
              context.read<ProductBloc>().add(
                GetProductByIdEvent(widget.productId),
              );
            }
          });
    }
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.spacingMD),
      padding: const EdgeInsets.all(AppStyles.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyles.radiusMD),
        boxShadow: [
          BoxShadow(
            color: const Color.from(
              alpha: 0.102,
              red: 0.62,
              green: 0.62,
              blue: 0.62,
            ),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppStyles.spacingSM),
            decoration: BoxDecoration(
              color: const Color.from(
                alpha: 0.1,
                red: 0.129,
                green: 0.588,
                blue: 0.953,
              ),
              borderRadius: BorderRadius.circular(AppStyles.radiusSM),
            ),
            child: Icon(icon, color: AppStyles.primaryColor, size: 24),
          ),
          const SizedBox(width: AppStyles.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.labelMedium.copyWith(
                    color: AppStyles.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppStyles.titleMedium.copyWith(
                    color: valueColor ?? AppStyles.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildStockStatusChip(int quantity) {
    final status = AppUtils.getStockStatus(quantity);
    final color = AppUtils.getStockStatusColor(quantity);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.spacingSM,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Color.from(
          alpha: 0.1,
          red: color.r,
          green: color.g,
          blue: color.b,
        ),
        borderRadius: BorderRadius.circular(AppStyles.radiusSM),
        border: Border.all(
          color: Color.from(
            alpha: 0.3,
            red: color.r,
            green: color.g,
            blue: color.b,
          ),
        ),
      ),
      child: Text(
        status,
        style: AppStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.from(
              alpha: 0.1,
              red: 0.62,
              green: 0.62,
              blue: 0.62,
            ),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _editProduct,
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppStyles.primaryColor,
                side: BorderSide(color: AppStyles.primaryColor),
                padding: const EdgeInsets.symmetric(
                  vertical: AppStyles.spacingMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyles.radiusMD),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppStyles.spacingMD),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showDeleteConfirmation,
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.errorColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppStyles.spacingMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyles.radiusMD),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    if (_product == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppStyles.spacingLG),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppStyles.primaryColor,
            const Color.from(alpha: 0.8, red: 0.129, green: 0.588, blue: 0.953),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _product!.name,
                      style: AppStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppStyles.spacingSM),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.spacingSM,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.2),
                        borderRadius: BorderRadius.circular(AppStyles.radiusSM),
                      ),
                      child: Text(
                        _product!.category,
                        style: AppStyles.labelMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStockStatusChip(_product!.quantity),
            ],
          ),
          const SizedBox(height: AppStyles.spacingMD),
          Text(
            AppUtils.formatCurrency(_product!.price, symbol: '₹'),
            style: AppStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_product != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _editProduct();
                    break;
                  case 'delete':
                    _showDeleteConfirmation();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductSuccess) {
            AppUtils.showSuccessSnackBar(
              context,
              'Product deleted successfully',
            );
            Navigator.of(context).pop(true);
          } else if (state is ProductError) {
            AppUtils.showErrorSnackBar(context, state.message);
          } else if (state is ProductDetailLoaded) {
            setState(() {
              _product = state.product;
            });
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const LoadingWidget(message: 'Loading product details...');
          } else if (state is ProductError) {
            return EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Error Loading Product',
              subtitle: state.message,
              action: ElevatedButton(
                onPressed: () {
                  context.read<ProductBloc>().add(
                    GetProductByIdEvent(widget.productId),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            );
          } else if (state is ProductDetailLoaded) {
            if (_product == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _product = state.product;
                });
              });
            }
          }

          if (_product == null) {
            return const LoadingWidget(message: 'Loading product details...');
          }

          return Column(
            children: [
              _buildProductHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppStyles.spacingMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Information',
                        style: AppStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppStyles.spacingMD),

                      _buildDetailCard(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Product Name',
                        value: _product!.name,
                      ),

                      _buildDetailCard(
                        icon: Icons.category_outlined,
                        title: 'Category',
                        value: _product!.category,
                      ),

                      _buildDetailCard(
                        icon: Icons.currency_rupee,
                        title: 'Price',
                        value: AppUtils.formatCurrency(
                          _product!.price,
                          symbol: '₹',
                        ),
                        valueColor: AppStyles.successColor,
                      ),

                      _buildDetailCard(
                        icon: Icons.inventory_outlined,
                        title: 'Quantity',
                        value: '${_product!.quantity} units',
                        valueColor: AppUtils.getStockStatusColor(
                          _product!.quantity,
                        ),
                        trailing: _buildStockStatusChip(_product!.quantity),
                      ),

                      _buildDetailCard(
                        icon: Icons.calculate_outlined,
                        title: 'Total Value',
                        value: AppUtils.formatCurrency(
                          _product!.price * _product!.quantity,
                          symbol: '₹',
                        ),
                        valueColor: AppStyles.primaryColor,
                      ),

                      const SizedBox(height: AppStyles.spacingLG),

                      // Quick Stats
                      Text(
                        'Quick Stats',
                        style: AppStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppStyles.spacingMD),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(
                                AppStyles.spacingMD,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppStyles.radiusMD,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(
                                      158,
                                      158,
                                      158,
                                      0.1,
                                    ),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: AppStyles.successColor,
                                    size: 32,
                                  ),
                                  const SizedBox(height: AppStyles.spacingSM),
                                  Text(
                                    'Status',
                                    style: AppStyles.labelMedium.copyWith(
                                      color: AppStyles.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppUtils.getStockStatus(_product!.quantity),
                                    style: AppStyles.labelLarge.copyWith(
                                      color: AppUtils.getStockStatusColor(
                                        _product!.quantity,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: AppStyles.spacingMD),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(
                                AppStyles.spacingMD,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppStyles.radiusMD,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(
                                      158,
                                      158,
                                      158,
                                      0.1,
                                    ),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    color: AppStyles.primaryColor,
                                    size: 32,
                                  ),
                                  const SizedBox(height: AppStyles.spacingSM),
                                  Text(
                                    'Unit Price',
                                    style: AppStyles.labelMedium.copyWith(
                                      color: AppStyles.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppUtils.formatCurrency(
                                      _product!.price,
                                      symbol: '₹',
                                    ),
                                    style: AppStyles.labelLarge.copyWith(
                                      color: AppStyles.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppStyles.spacingXL),
                    ],
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          );
        },
      ),
    );
  }
}
