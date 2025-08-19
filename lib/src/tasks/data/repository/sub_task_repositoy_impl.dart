import 'package:taskflow_mini/src/tasks/data/datasources/sub_task_local_data_sources.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/sub_task.dart';
import 'package:taskflow_mini/src/tasks/domain/repository/sub_task_repository.dart';

class SubtaskRepositoryImpl implements SubtaskRepository {
  final SubtaskLocalDataSource local;
  SubtaskRepositoryImpl(this.local);

  @override
  Future<Subtask> create(Subtask subtask) => local.create(subtask);

  @override
  Future<void> delete(String subtaskId) => local.delete(subtaskId);

  @override
  Future<List<Subtask>> fetchForTask(
    String taskId, {
    bool includeArchived = false,
  }) => local.fetchForTask(taskId, includeArchived: includeArchived);

  @override
  Future<void> archive(String subtaskId) => local.archive(subtaskId);

  @override
  Future<Subtask> update(Subtask subtask) => local.update(subtask);
}
