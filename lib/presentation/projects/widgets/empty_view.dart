import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final VoidCallback onCreate;
  const EmptyView({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.folder_open, size: 72),
          const SizedBox(height: 12),
          const Text('No projects yet', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Create your first project'),
          ),
        ],
      ),
    );
  }
}
