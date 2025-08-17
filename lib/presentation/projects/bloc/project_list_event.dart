part of 'project_list_bloc.dart';

sealed class ProjectListEvent extends Equatable {
  const ProjectListEvent();

  @override
  List<Object?> get props => [];
}

class ProjectListLoaded extends ProjectListEvent {
  final bool includeArchived;
  const ProjectListLoaded({this.includeArchived = false});

  @override
  List<Object?> get props => [includeArchived];
}

class ProjectCreated extends ProjectListEvent {
  final String name;
  final String description;
  const ProjectCreated({required this.name, required this.description});
  @override
  List<Object?> get props => [name, description];
}

class ProjectArchived extends ProjectListEvent {
  final String projectId;
  const ProjectArchived(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class ProjectUpdated extends ProjectListEvent {
  final Project project;
  const ProjectUpdated(this.project);
  @override
  List<Object?> get props => [project];
}

class ProjectRefreshRequested extends ProjectListEvent {
  const ProjectRefreshRequested();
}
