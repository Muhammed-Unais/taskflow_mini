import 'dart:async';
import 'dart:math';
import 'package:taskflow_mini/src/report/domain/entities/project_report.dart';
import 'package:taskflow_mini/src/report/domain/repository/report_repository.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';
import 'package:taskflow_mini/src/tasks/domain/repository/task_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final TaskRepository taskRepo;
  final _random = Random();

  ReportRepositoryImpl(this.taskRepo);

  Duration _latency() => Duration(milliseconds: 500 + _random.nextInt(300));

  @override
  Future<ProjectReport> projectStatus(
    String projectId, {
    bool includeArchived = false,
  }) async {
    await Future.delayed(_latency());

    final List<Task> tasks = await taskRepo.fetchForProject(
      projectId,
      includeArchived: includeArchived,
    );

    return _computeReport(tasks);
  }

  ProjectReport _computeReport(List<Task> tasks) {
    final now = DateTime.now();
    final countsByStatus = <String, int>{};
    int total = tasks.length;
    int overdue = 0;
    final openByAssignee = <String, int>{};

    for (final t in tasks) {
      final statusName = t.status.name;
      countsByStatus[statusName] = (countsByStatus[statusName] ?? 0) + 1;

      final isDone = t.status == TaskStatus.done;
      final isArchived = t.archived;
      if (!isArchived &&
          !isDone &&
          t.dueDate != null &&
          t.dueDate!.isBefore(now)) {
        overdue++;
      }

      if (!isArchived && !isDone) {
        if (t.assignees.isEmpty) {
          openByAssignee['unassigned'] =
              (openByAssignee['unassigned'] ?? 0) + 1;
        } else {
          for (final a in t.assignees) {
            openByAssignee[a] = (openByAssignee[a] ?? 0) + 1;
          }
        }
      }
    }

    final doneCount = countsByStatus[TaskStatus.done.name] ?? 0;
    final completion = total == 0 ? 0.0 : (doneCount / total) * 100.0;

    return ProjectReport(
      total: total,
      countsByStatus: Map.unmodifiable(countsByStatus),
      overdue: overdue,
      completionPercent: double.parse(completion.toStringAsFixed(2)),
      openByAssignee: Map.unmodifiable(openByAssignee),
    );
  }
}
