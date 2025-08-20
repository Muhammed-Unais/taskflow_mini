import 'package:flutter/material.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';

class StatusIndicator extends StatelessWidget {
  final TaskStatus status;

  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: status.color, width: 1),
      ),
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(
          status.displayName,
          style: TextStyle(color: status.color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
