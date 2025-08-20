import 'package:flutter/material.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';

class DeleteDialog extends StatelessWidget {
  final void Function()? onPressed;
  const DeleteDialog({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete task?', style: context.textTheme.titleLarge),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: onPressed,
          child: Text('Delete', style: context.textTheme.titleMedium),
        ),
      ],
    );
  }
}
