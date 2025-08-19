import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';

List<Task> applyTaskFilter(List<Task> tasks, TaskState f) {
  final q = f.search?.trim().toLowerCase();

  bool matchesQuery(Task t) {
    if (q == null) return true;
    if (q.isEmpty) return true;
    final inTitle = t.title.toLowerCase().contains(q);
    final inDesc = t.description.toLowerCase().contains(q);
    final inLabels = t.labels.any((e) => e.toLowerCase().contains(q));
    return inTitle || inDesc || inLabels;
  }

  bool matchesStatuses(Task t) =>
      f.statusFilter == "all" ||
      f.statusFilter == null ||
      f.statusFilter!.isEmpty ||
      t.status.name == f.statusFilter;

  bool matchesPriorities(Task t) =>
      f.priorities.isEmpty || f.priorities.contains(t.priority);

  final filtered =
      tasks.where((t) {
        if (t.archived) return false;
        return matchesQuery(t) && matchesStatuses(t) && matchesPriorities(t);
      }).toList();

  return filtered;
}
