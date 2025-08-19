part of 'task_bloc.dart';

enum TaskStatusState { initial, loading, ready, empty, error }

class TaskState extends Equatable {
  final TaskStatusState status;
  final List<Task> tasks;
  final bool includeArchived;
  final String? error;
  final String? search;
  final String? statusFilter;
  final Set<TaskPriority> priorities;

  const TaskState({
    required this.status,
    required this.tasks,
    required this.includeArchived,
    required this.error,
    required this.search,
    required this.statusFilter,
    required this.priorities,
  });

  const TaskState.initial()
    : status = TaskStatusState.initial,
      tasks = const [],
      includeArchived = false,
      error = null,
      search = null,
      priorities = const {},
      statusFilter = "all";

  TaskState copyWith({
    TaskStatusState? status,
    List<Task>? tasks,
    bool? includeArchived,
    String? error,
    String? search,
    String? statusFilter,
    Set<TaskPriority>? priorities,
  }) {
    return TaskState(
      priorities: priorities ?? this.priorities,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      includeArchived: includeArchived ?? this.includeArchived,
      error: error,
      search: search ?? this.search,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasks,
    includeArchived,
    error,
    search,
    priorities,
    statusFilter,
  ];
}
