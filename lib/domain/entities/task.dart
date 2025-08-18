import 'package:equatable/equatable.dart';
import 'task_status.dart';
import 'task_priority.dart';

class Task extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? startDate;
  final DateTime? dueDate;
  final double estimateHours;
  final double timeSpentHours;
  final List<String> labels;
  final List<String> assignees;
  final bool archived;

  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.startDate,
    this.dueDate,
    required this.estimateHours,
    required this.timeSpentHours,
    this.labels = const [],
    this.assignees = const [],
    this.archived = false,
  });

  Task copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? startDate,
    DateTime? dueDate,
    double? estimateHours,
    double? timeSpentHours,
    List<String>? labels,
    List<String>? assignees,
    bool? archived,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      estimateHours: estimateHours ?? this.estimateHours,
      timeSpentHours: timeSpentHours ?? this.timeSpentHours,
      labels: labels ?? this.labels,
      assignees: assignees ?? this.assignees,
      archived: archived ?? this.archived,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    projectId: json['projectId'] as String,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    status: TaskStatusX.fromName(json['status'] as String? ?? 'todo'),
    priority: TaskPriorityX.fromName(json['priority'] as String? ?? 'medium'),
    startDate:
        json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    estimateHours:
        (json['estimateHours'] is num)
            ? (json['estimateHours'] as num).toDouble()
            : 0.0,
    timeSpentHours:
        (json['timeSpentHours'] is num)
            ? (json['timeSpentHours'] as num).toDouble()
            : 0.0,
    labels: (json['labels'] as List<dynamic>?)?.cast<String>() ?? [],
    assignees: (json['assignees'] as List<dynamic>?)?.cast<String>() ?? [],
    archived: json['archived'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'title': title,
    'description': description,
    'status': status.name,
    'priority': priority.name,
    'startDate': startDate?.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'estimateHours': estimateHours,
    'timeSpentHours': timeSpentHours,
    'labels': labels,
    'assignees': assignees,
    'archived': archived,
  };

  @override
  List<Object?> get props => [
    id,
    projectId,
    title,
    description,
    status,
    priority,
    startDate,
    dueDate,
    estimateHours,
    timeSpentHours,
    labels,
    assignees,
    archived,
  ];
}
