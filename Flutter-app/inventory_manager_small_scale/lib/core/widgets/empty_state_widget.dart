import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: AppStyles.textSecondary,
            ),
            const SizedBox(height: AppStyles.spacingMD),
            Text(
              title,
              style: AppStyles.emptyStateTitle,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppStyles.spacingSM),
              Text(
                subtitle!,
                style: AppStyles.emptyStateSubtitle,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppStyles.spacingLG),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}