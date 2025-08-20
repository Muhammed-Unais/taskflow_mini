import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';

List<Task> applyTaskFilter(TaskState taskState) {
  final q = taskState.search?.trim().toLowerCase();

  bool matchesQuery(Task t) {
    if (q == null) return true;
    if (q.isEmpty) return true;
    final inTitle = t.title.toLowerCase().contains(q);
    final inDesc = t.description.toLowerCase().contains(q);
    final inLabels = t.labels.any((e) => e.toLowerCase().contains(q));
    return inTitle || inDesc || inLabels;
  }

  bool matchesStatuses(Task t) =>
      taskState.statusFilter == "all" ||
      taskState.statusFilter == null ||
      taskState.statusFilter!.isEmpty ||
      t.status.name == taskState.statusFilter;

  bool matchesPriorities(Task t) =>
      taskState.priorities.isEmpty || taskState.priorities.contains(t.priority);

  bool matchesAssignees(Task t) =>
      taskState.assignees.isEmpty ||
      taskState.assignees.any(t.assignees.contains);

  final filtered =
      taskState.tasks.where((t) {
        if (t.archived) return false;
        return matchesQuery(t) &&
            matchesStatuses(t) &&
            matchesPriorities(t) &&
            matchesAssignees(t);
      }).toList();

  return filtered;
}
