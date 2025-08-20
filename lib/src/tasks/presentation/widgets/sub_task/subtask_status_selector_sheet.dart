import 'package:flutter/material.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/sub_task.dart';

class SubTaskStatusSelectorSheet extends StatelessWidget {
  final SubtaskStatus current;

  const SubTaskStatusSelectorSheet({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final statuses = SubtaskStatus.values;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Change Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...statuses.map(
            (s) => ListTile(
              leading: CircleAvatar(radius: 8, backgroundColor: s.color),
              title: Text(s.displayName),
              trailing:
                  s == current
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
              onTap: () => Navigator.pop(context, s),
            ),
          ),
        ],
      ),
    );
  }
}
