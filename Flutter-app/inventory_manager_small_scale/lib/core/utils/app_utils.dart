import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import 'dart:async';

class AppUtils {
  // Currency Formatting
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  // Stock Status Logic
  static String getStockStatus(int quantity, {int lowStockThreshold = 10}) {
    if (quantity <= 0) {
      return 'Out of Stock';
    } else if (quantity <= lowStockThreshold) {
      return 'Low Stock';
    } else {
      return 'In Stock';
    }
  }

  static Color getStockStatusColor(int quantity, {int lowStockThreshold = 10}) {
    final status = getStockStatus(quantity, lowStockThreshold: lowStockThreshold);
    return AppStyles.getStatusColor(status);
  }

  // Validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPrice(String price) {
    final parsed = double.tryParse(price);
    return parsed != null && parsed >= 0;
  }

  static bool isValidQuantity(String quantity) {
    final parsed = int.tryParse(quantity);
    return parsed != null && parsed >= 0;
  }

  static String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    if (value.trim().length < 2) {
      return 'Product name must be at least 2 characters';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category is required';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    if (!isValidPrice(value)) {
      return 'Please enter a valid price';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    if (!isValidQuantity(value)) {
      return 'Please enter a valid quantity';
    }
    return null;
  }

  // Snackbar Helpers
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppStyles.successSnackBar(message),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppStyles.errorSnackBar(message),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppStyles.warningSnackBar(message),
    );
  }

  // Dialog Helpers
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: AppStyles.titleLarge),
          content: Text(content, style: AppStyles.bodyMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.radiusMD),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText, style: AppStyles.labelLarge),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: isDangerous ? AppStyles.dangerButtonStyle : AppStyles.primaryButtonStyle,
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppStyles.loadingIndicator(),
              const SizedBox(width: AppStyles.spacingMD),
              Expanded(
                child: Text(
                  message ?? 'Loading...',
                  style: AppStyles.bodyMedium,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.radiusMD),
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Date Formatting
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Navigation Helpers
  static void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateAndReplace(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateAndClearStack(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  // String Utilities
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // List Utilities
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  // Focus Utilities
  static void unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // Device Utilities
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 768;
  }

  static bool isMobile(BuildContext context) {
    return !isTablet(context);
  }

  // Animation Duration Constants
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Debouncing for Search
  static Timer? _searchDebounceTimer;
  
  static void debounceSearch(VoidCallback callback, {Duration delay = const Duration(milliseconds: 500)}) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(delay, callback);
  }

  // Number Formatting
  static String formatNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Platform Specific Helpers
  static bool get isAndroid => Theme.of(navigatorKey.currentContext!).platform == TargetPlatform.android;
  static bool get isIOS => Theme.of(navigatorKey.currentContext!).platform == TargetPlatform.iOS;

  // Global Navigator Key (add this to your main.dart MaterialApp)
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

// Timer import
