part of 'subtask_bloc.dart';

sealed class SubtaskEvent extends Equatable {
  const SubtaskEvent();
  @override
  List<Object?> get props => [];
}

class SubtasksLoadRequested extends SubtaskEvent {
  final bool includeArchived;
  const SubtasksLoadRequested({this.includeArchived = false});
  @override
  List<Object?> get props => [includeArchived];
}

class SubtaskCreated extends SubtaskEvent {
  final Subtask subtask;
  const SubtaskCreated(this.subtask);
  @override
  List<Object?> get props => [subtask];
}

class SubtaskUpdated extends SubtaskEvent {
  final Subtask subtask;
  const SubtaskUpdated(this.subtask);
  @override
  List<Object?> get props => [subtask];
}

class SubtaskDeleted extends SubtaskEvent {
  final String subtaskId;
  const SubtaskDeleted(this.subtaskId);
  @override
  List<Object?> get props => [subtaskId];
}

class SubtaskArchived extends SubtaskEvent {
  final String subtaskId;
  const SubtaskArchived(this.subtaskId);
  @override
  List<Object?> get props => [subtaskId];
}
