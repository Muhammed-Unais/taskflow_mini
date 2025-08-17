part of 'project_list_bloc.dart';

enum ProjectListStatus { initial, loading, ready, empty, error }

final class ProjectListState extends Equatable {
  final ProjectListStatus status;
  final List<Project> projects;
  final bool includeArchived;
  final String? error;

  const ProjectListState({
    required this.status,
    required this.projects,
    required this.includeArchived,
    required this.error,
  });

  const ProjectListState.initial()
    : status = ProjectListStatus.initial,
      projects = const [],
      includeArchived = false,
      error = null;

  ProjectListState copyWith({
    ProjectListStatus? status,
    List<Project>? projects,
    bool? includeArchived,
    String? error,
  }) {
    return ProjectListState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      includeArchived: includeArchived ?? this.includeArchived,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, projects, includeArchived, error];
}
