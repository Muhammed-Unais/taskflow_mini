import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SubtaskStatus { todo, done, blocked }

extension SubtaskStatusX on SubtaskStatus {
  String get name {
    return switch (this) {
      SubtaskStatus.todo => 'todo',
      SubtaskStatus.done => 'done',
      SubtaskStatus.blocked => 'blocked',
    };
  }

  String get displayName {
    return switch (this) {
      SubtaskStatus.todo => 'To Do',
      SubtaskStatus.done => 'Done',
      SubtaskStatus.blocked => 'Blocked',
    };
  }

  Color get color {
    return switch (this) {
      SubtaskStatus.todo => Colors.grey,
      SubtaskStatus.done => Colors.green,
      SubtaskStatus.blocked => Colors.red,
    };
  }

  static SubtaskStatus fromName(String name) {
    return SubtaskStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => SubtaskStatus.todo,
    );
  }
}

class Subtask extends Equatable {
  final String id;
  final String taskId;
  final String title;
  final SubtaskStatus status;
  final String? assigneeId;
  final bool archived;

  const Subtask({
    required this.id,
    required this.taskId,
    required this.title,
    this.status = SubtaskStatus.todo,
    this.assigneeId,
    this.archived = false,
  });

  Subtask copyWith({
    String? id,
    String? taskId,
    String? title,
    SubtaskStatus? status,
    String? assigneeId,
    bool? archived,
  }) {
    return Subtask(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      status: status ?? this.status,
      assigneeId: assigneeId ?? this.assigneeId,
      archived: archived ?? this.archived,
    );
  }

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
    id: json['id'] as String,
    taskId: json['taskId'] as String,
    title: json['title'] as String? ?? '',
    status: SubtaskStatusX.fromName(json['status'] as String? ?? 'todo'),
    assigneeId: json['assigneeId'] as String?,
    archived: json['archived'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'taskId': taskId,
    'title': title,
    'status': status.name,
    'assigneeId': assigneeId,
    'archived': archived,
  };

  @override
  List<Object?> get props => [id, taskId, title, status, assigneeId, archived];
}
