import 'package:flutter/material.dart';

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

  String get displayName {
    return switch (this) {
      TaskStatus.todo => 'To Do',
      TaskStatus.inProgress => 'In Progress',
      TaskStatus.blocked => 'Blocked',
      TaskStatus.inReview => 'In Review',
      TaskStatus.done => 'Done',
    };
  }

  Color get color {
    return switch (this) {
      TaskStatus.todo => Colors.grey,
      TaskStatus.inProgress => Colors.blue,
      TaskStatus.blocked => Colors.red,
      TaskStatus.inReview => Colors.orange,
      TaskStatus.done => Colors.green,
    };
  }

  static TaskStatus fromName(String name) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TaskStatus.todo,
    );
  }
}
