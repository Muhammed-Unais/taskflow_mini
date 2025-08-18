import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high, critical }

extension TaskPriorityX on TaskPriority {
  String get name {
    return switch (this) {
      TaskPriority.low => 'low',
      TaskPriority.medium => 'medium',
      TaskPriority.high => 'high',
      TaskPriority.critical => 'critical',
    };
  }

  String get displayName {
    return switch (this) {
      TaskPriority.low => 'Low',
      TaskPriority.medium => 'Medium',
      TaskPriority.high => 'High',
      TaskPriority.critical => 'Critical',
    };
  }

  Color get color {
    return switch (this) {
      TaskPriority.low => Colors.green.shade600,
      TaskPriority.medium => Colors.amber.shade700,
      TaskPriority.high => Colors.deepOrange,
      TaskPriority.critical => Colors.red.shade600,
    };
  }

  static TaskPriority fromName(String name) {
    return TaskPriority.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TaskPriority.medium,
    );
  }
}
