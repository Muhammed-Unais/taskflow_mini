import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/projects/domain/repository/project_repository.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final ProjectRepository repo;

  ProjectListBloc(this.repo) : super(const ProjectListState.initial()) {
    on<ProjectListLoaded>(_onLoaded);
    on<ProjectCreated>(_onCreate);
    on<ProjectUpdated>(_onUpdate);
    on<ProjectArchived>(_onArchive);
    on<ProjectRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoaded(
    ProjectListLoaded event,
    Emitter<ProjectListState> emit,
  ) async {
    emit(state.copyWith(status: ProjectListStatus.loading, error: null));
    try {
      final projects = await repo.fetchAll(
        includeArchived: event.includeArchived,
      );
      emit(
        state.copyWith(
          status:
              projects.isEmpty
                  ? ProjectListStatus.empty
                  : ProjectListStatus.ready,
          projects: projects,
          includeArchived: event.includeArchived,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProjectListStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onCreate(
    ProjectCreated event,
    Emitter<ProjectListState> emit,
  ) async {
    try {
      await repo.create(name: event.name, description: event.description);
      add(ProjectListLoaded(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onArchive(
    ProjectArchived event,
    Emitter<ProjectListState> emit,
  ) async {
    try {
      await repo.archive(event.projectId);
      add(ProjectListLoaded(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdate(
    ProjectUpdated event,
    Emitter<ProjectListState> emit,
  ) async {
    try {
      await repo.update(event.project);
      add(ProjectListLoaded(includeArchived: state.includeArchived));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRefresh(
    ProjectRefreshRequested event,
    Emitter<ProjectListState> emit,
  ) async {
    add(ProjectListLoaded(includeArchived: state.includeArchived));
  }
}
