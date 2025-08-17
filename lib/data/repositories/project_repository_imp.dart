import 'package:taskflow_mini/domain/entities/project.dart';
import 'package:taskflow_mini/data/datasources/project_local_data_source.dart';
import 'package:taskflow_mini/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource local;

  ProjectRepositoryImpl(this.local);

  @override
  Future<List<Project>> fetchAll({bool includeArchived = false}) {
    return local.fetchAll(includeArchived: includeArchived);
  }

  @override
  Future<Project> create({required String name, required String description}) {
    return local.create(name: name, description: description);
  }

  @override
  Future<Project> update(Project project) {
    return local.update(project);
  }

  @override
  Future<void> archive(String projectId) {
    return local.archive(projectId);
  }
}
