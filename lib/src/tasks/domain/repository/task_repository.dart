import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchForProject(
    String projectId, {
    bool includeArchived = false,
  });
  Future<Task> create(Task task);
  Future<Task> update(Task task);
  Future<void> delete(String taskId);
  Future<void> archive(String taskId);
}
