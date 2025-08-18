import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onArchive;

  const TaskTile({
    super.key,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          onPressed: onToggleStatus,
          icon: Icon(Icons.check_box),
          tooltip: 'Toggle status',
        ),
        title: Text(
          "task title",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'priority',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: onArchive,
              icon: const Icon(Icons.archive_outlined),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }
}
