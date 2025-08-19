import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/projects/data/data_sources/project_local_data_source.dart';
import 'package:taskflow_mini/src/projects/domain/repository/project_repository.dart';

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

  @override
  Future<Project?> fetchById(String id) {
    return local.fetchById(id);
  }
}
