enum TaskStatus { todo, inProgress, blocked, inReview, done }

extension TaskStatusX on TaskStatus {
  String get name {
    return switch (this) {
      TaskStatus.todo => 'todo',
      TaskStatus.inProgress => 'inProgress',
      TaskStatus.blocked => 'blocked',
      TaskStatus.inReview => 'inReview',
      TaskStatus.done => 'done',
    };
  }

  static TaskStatus fromName(String name) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TaskStatus.todo,
    );
  }
}
