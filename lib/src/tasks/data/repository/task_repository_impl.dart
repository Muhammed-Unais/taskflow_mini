import 'package:taskflow_mini/src/tasks/data/datasources/task_local_data_sources.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource local;

  TaskRepositoryImpl(this.local);

  @override
  Future<Task> create(Task task) => local.create(task);

  @override
  Future<void> delete(String taskId) => local.delete(taskId);

  @override
  Future<List<Task>> fetchForProject(
    String projectId, {
    bool includeArchived = false,
  }) => local.fetchForProject(projectId, includeArchived: includeArchived);

  @override
  Future<void> archive(String taskId) => local.archive(taskId);

  @override
  Future<Task> update(Task task) => local.update(task);
}
