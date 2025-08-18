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

  static TaskPriority fromName(String name) {
    return TaskPriority.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TaskPriority.medium,
    );
  }
}
