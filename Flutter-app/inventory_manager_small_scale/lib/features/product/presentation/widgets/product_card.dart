import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_utils.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final stockStatus = AppUtils.getStockStatus(product.quantity);
    final stockColor = AppUtils.getStockStatusColor(product.quantity);

    return Card(
      margin: const EdgeInsets.only(bottom: AppStyles.spacingMD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radiusMD),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppStyles.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppStyles.spacingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppStyles.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppStyles.spacingXS),
                        Text(
                          product.category,
                          style: AppStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Actions Menu
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete, size: 18, color: AppStyles.errorColor),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: AppStyles.errorColor)),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(Icons.more_vert, color: AppStyles.textSecondary),
                  ),
                ],
              ),
              
              const SizedBox(height: AppStyles.spacingMD),
              
              // Price and Stock Row
              Row(
                children: [
                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppStyles.spacingSM,
                      vertical: AppStyles.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: Color.from(alpha: 0.1, red: AppStyles.primaryColor.r, green: AppStyles.primaryColor.g, blue: AppStyles.primaryColor.b),
                      borderRadius: BorderRadius.circular(AppStyles.radiusSM),
                    ),
                    child: Text(
                      AppUtils.formatCurrency(product.price),
                      style: AppStyles.labelLarge.copyWith(
                        color: AppStyles.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Stock Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppStyles.spacingSM,
                      vertical: AppStyles.spacingXS,
                    ),
                    decoration: AppStyles.getStatusBadgeDecoration(stockStatus),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStockIcon(stockStatus),
                          size: 14,
                          color: stockColor,
                        ),
                        const SizedBox(width: AppStyles.spacingXS),
                        Text(
                          stockStatus,
                          style: AppStyles.labelSmall.copyWith(
                            color: stockColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppStyles.spacingSM),
              
              // Quantity
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: AppStyles.textSecondary,
                  ),
                  const SizedBox(width: AppStyles.spacingXS),
                  Text(
                    'Qty: ${product.quantity}',
                    style: AppStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStockIcon(String status) {
    switch (status.toLowerCase()) {
      case 'in stock':
        return Icons.check_circle;
      case 'out of stock':
        return Icons.cancel;
      case 'low stock':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }
}