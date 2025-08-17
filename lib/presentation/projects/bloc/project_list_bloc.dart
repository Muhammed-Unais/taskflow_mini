import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskflow_mini/domain/entities/project.dart';
import 'package:taskflow_mini/domain/repositories/project_repository.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final ProjectRepository repo;

  ProjectListBloc(this.repo) : super(const ProjectListState.initial()) {
    on<ProjectListLoaded>(_onLoaded);
    on<ProjectCreated>(_onCreate);
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
}
