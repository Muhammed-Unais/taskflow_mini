import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/sub_task.dart';
import 'package:taskflow_mini/src/tasks/domain/repository/sub_task_repository.dart';

part 'subtask_event.dart';
part 'subtask_state.dart';

class SubtaskBloc extends Bloc<SubtaskEvent, SubtaskState> {
  final SubtaskRepository repo;
  final String taskId;

  SubtaskBloc({required this.repo, required this.taskId})
    : super(const SubtaskState.initial()) {
    on<SubtasksLoadRequested>(_onLoad);
    on<SubtaskCreated>(_onCreate);
    on<SubtaskUpdated>(_onUpdate);
    on<SubtaskDeleted>(_onDelete);
    on<SubtaskArchived>(_onArchive);
  }

  Future<void> _onLoad(
    SubtasksLoadRequested event,
    Emitter<SubtaskState> emit,
  ) async {
    emit(state.copyWith(status: SubtaskStatusState.loading, error: null));
    try {
      log("SubtasksLoadRequested $taskId ${event.includeArchived}");
      final items = await repo.fetchForTask(
        taskId,
        includeArchived: event.includeArchived,
      );
      emit(
        state.copyWith(
          status:
              items.isEmpty
                  ? SubtaskStatusState.empty
                  : SubtaskStatusState.ready,
          subtasks: items,
          includeArchived: event.includeArchived,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SubtaskStatusState.error, error: e.toString()),
      );
    }
  }

  Future<void> _onCreate(
    SubtaskCreated event,
    Emitter<SubtaskState> emit,
  ) async {
    try {
      await repo.create(event.subtask);
      add(SubtasksLoadRequested(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdate(
    SubtaskUpdated event,
    Emitter<SubtaskState> emit,
  ) async {
    try {
      await repo.update(event.subtask);
      add(SubtasksLoadRequested(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(
    SubtaskDeleted event,
    Emitter<SubtaskState> emit,
  ) async {
    try {
      await repo.delete(event.subtaskId);
      add(SubtasksLoadRequested(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onArchive(
    SubtaskArchived event,
    Emitter<SubtaskState> emit,
  ) async {
    try {
      await repo.archive(event.subtaskId);
      add(SubtasksLoadRequested(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
