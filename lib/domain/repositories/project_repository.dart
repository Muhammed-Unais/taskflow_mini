import 'package:taskflow_mini/domain/entities/project.dart';

abstract interface class ProjectRepository {
  Future<List<Project>> fetchAll({bool includeArchived = false});
  Future<Project?> fetchById(String id);
  Future<Project> create({required String name, required String description});
  Future<Project> update(Project project);
  Future<void> archive(String projectId);
}
