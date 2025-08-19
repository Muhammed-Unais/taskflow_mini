import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final VoidCallback onCreate;
  final String? message;
  final String? buttonMessage;
  const EmptyView({
    super.key,
    required this.onCreate,
    this.message,
    this.buttonMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.folder_open, size: 72),
          const SizedBox(height: 12),
          Text(message ?? 'Not found', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          if (buttonMessage != null)
            TextButton.icon(
              onPressed: onCreate,
              icon: buttonMessage == null ? null : const Icon(Icons.add),
              label: Text(buttonMessage!),
            ),
        ],
      ),
    );
  }
}
