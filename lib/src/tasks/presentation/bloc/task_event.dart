part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class TaskLoadRequested extends TaskEvent {
  final bool includeArchived;
  const TaskLoadRequested({this.includeArchived = false});
  @override
  List<Object?> get props => [includeArchived];
}

class TaskCreated extends TaskEvent {
  final Task task;
  const TaskCreated(this.task);
  @override
  List<Object?> get props => [task];
}

class TaskUpdated extends TaskEvent {
  final Task task;
  const TaskUpdated(this.task);
  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TaskEvent {
  final String taskId;
  const TaskDeleted(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class TaskArchived extends TaskEvent {
  final String taskId;
  const TaskArchived(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class TaskFilterChanged extends TaskEvent {
  final String? search;
  final String? statusFilter;
  final Set<TaskPriority>? priorities;
  final Set<String>? assignees;
  const TaskFilterChanged({
    this.search,
    this.statusFilter,
    this.priorities,
    this.assignees,
  });
  @override
  List<Object?> get props => [search, statusFilter, priorities];
}

class TaskRefreshRequested extends TaskEvent {}
