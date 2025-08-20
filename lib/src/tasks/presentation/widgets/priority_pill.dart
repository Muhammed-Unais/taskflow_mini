import 'package:flutter/material.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';

class PriorityPill extends StatelessWidget {
  final TaskPriority priority;
  const PriorityPill({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = priority.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
