import 'package:taskflow_mini/src/tasks/domain/entities/sub_task.dart';

abstract class SubtaskRepository {
  Future<List<Subtask>> fetchForTask(
    String taskId, {
    bool includeArchived = false,
  });
  Future<Subtask> create(Subtask subtask);
  Future<Subtask> update(Subtask subtask);
  Future<void> delete(String subtaskId);
  Future<void> archive(String subtaskId);
}
