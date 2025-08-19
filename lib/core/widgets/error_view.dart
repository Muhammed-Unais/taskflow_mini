import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;
  final String? buttonMessage;
  const ErrorView({
    super.key,
    required this.onRetry,
    this.message,
    this.buttonMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 72),
          const SizedBox(height: 12),
          Text(
            message ?? 'Something went wrong',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(buttonMessage ?? 'Try again'),
          ),
        ],
      ),
    );
  }
}
