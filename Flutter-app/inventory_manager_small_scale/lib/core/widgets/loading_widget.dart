import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool showMessage;

  const LoadingWidget({
    super.key,
    this.message,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppStyles.loadingIndicator(),
          if (showMessage) ...[
            const SizedBox(height: AppStyles.spacingMD),
            Text(
              message ?? 'Loading...',
              style: AppStyles.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            child: LoadingWidget(message: loadingMessage),
          ),
      ],
    );
  }
}