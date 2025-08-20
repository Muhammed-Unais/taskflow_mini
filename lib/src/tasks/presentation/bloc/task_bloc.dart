import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';
import 'package:taskflow_mini/src/tasks/domain/repository/task_repository.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repo;
  final String projectId;

  TaskBloc({required this.repo, required this.projectId})
    : super(const TaskState.initial()) {
    on<TaskLoadRequested>(_onLoad);
    on<TaskCreated>(_onCreate);
    on<TaskUpdated>(_onUpdate);
    on<TaskDeleted>(_onDelete);
    on<TaskArchived>(_onArchive);
    on<TaskFilterChanged>(_onFilterChanged);
    on<TaskRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(TaskLoadRequested event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatusState.loading, error: null));
    try {
      final tasks = await repo.fetchForProject(
        projectId,
        includeArchived: event.includeArchived,
      );

      emit(
        state.copyWith(
          status: tasks.isEmpty ? TaskStatusState.empty : TaskStatusState.ready,
          tasks: tasks,
          includeArchived: event.includeArchived,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TaskStatusState.error, error: e.toString()));
    }
  }

  Future<void> _onCreate(TaskCreated event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatusState.loading, error: null));
    try {
      await repo.create(event.task);
      add(TaskLoadRequested(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdate(TaskUpdated event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatusState.loading, error: null));

    try {
      await repo.update(event.task);
      add(TaskLoadRequested(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(TaskDeleted event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatusState.loading, error: null));

    try {
      await repo.delete(event.taskId);
      add(TaskLoadRequested(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onArchive(TaskArchived event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatusState.loading, error: null));

    try {
      await repo.archive(event.taskId);
      add(TaskLoadRequested(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onFilterChanged(
    TaskFilterChanged event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        search: event.search,
        statusFilter: event.statusFilter,
        priorities: event.priorities,
        assignees: event.assignees,
      ),
    );
  }

  Future<void> _onRefresh(
    TaskRefreshRequested event,
    Emitter<TaskState> emit,
  ) async {
    add(TaskLoadRequested(includeArchived: state.includeArchived));
  }
}
