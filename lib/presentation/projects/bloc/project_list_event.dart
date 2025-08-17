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
