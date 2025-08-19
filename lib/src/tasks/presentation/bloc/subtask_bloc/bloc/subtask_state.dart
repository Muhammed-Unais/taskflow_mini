part of 'subtask_bloc.dart';

enum SubtaskStatusState { initial, loading, ready, empty, error }

class SubtaskState extends Equatable {
  final SubtaskStatusState status;
  final List<Subtask> subtasks;
  final bool includeArchived;
  final String? error;

  const SubtaskState({
    required this.status,
    required this.subtasks,
    required this.includeArchived,
    required this.error,
  });

  const SubtaskState.initial()
    : status = SubtaskStatusState.initial,
      subtasks = const [],
      includeArchived = false,
      error = null;

  SubtaskState copyWith({
    SubtaskStatusState? status,
    List<Subtask>? subtasks,
    bool? includeArchived,
    String? error,
  }) {
    return SubtaskState(
      status: status ?? this.status,
      subtasks: subtasks ?? this.subtasks,
      includeArchived: includeArchived ?? this.includeArchived,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, subtasks, includeArchived, error];
}
