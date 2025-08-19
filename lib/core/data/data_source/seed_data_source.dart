import 'package:taskflow_mini/src/tasks/domain/entities/sub_task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';

class SeedConfig {
  static bool enabled = true;
}

class SeedData {
  static const projectId = 'p1';

  static List<Task> tasks() {
    final now = DateTime.now();
    return [
      Task(
        id: 't_1001',
        projectId: projectId,
        title: 'Design onboarding',
        description: 'Design screens and flows for new user onboarding.',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        startDate: now.subtract(const Duration(days: 10)),
        dueDate: now.add(const Duration(days: 5)),
        estimateHours: 8,
        timeSpentHours: 3,
        labels: const ['UX', 'onboarding'],
        assignees: const ['u_staff1'],
        archived: false,
      ),
      Task(
        id: 't_1002',
        projectId: projectId,
        title: 'Implement auth',
        description: 'Email/password + OAuth social login.',
        status: TaskStatus.todo,
        priority: TaskPriority.critical,
        startDate: now.subtract(const Duration(days: 2)),
        dueDate: now.add(const Duration(days: 7)),
        estimateHours: 12,
        timeSpentHours: 0,
        labels: const ['backend', 'security'],
        assignees: const ['u_staff2'],
        archived: false,
      ),
      Task(
        id: 't_1003',
        projectId: projectId,
        title: 'Setup CI/CD',
        description: 'Pipeline for automated builds & tests.',
        status: TaskStatus.done,
        priority: TaskPriority.medium,
        startDate: now.subtract(const Duration(days: 20)),
        dueDate: now.subtract(const Duration(days: 1)),
        estimateHours: 4,
        timeSpentHours: 4,
        labels: const ['devops'],
        assignees: const ['u_staff1', 'u_staff2'],
        archived: false,
      ),
      Task(
        id: 't_1004',
        projectId: projectId,
        title: 'Write user docs',
        description: 'Documentation for first release features.',
        status: TaskStatus.blocked,
        priority: TaskPriority.low,
        startDate: null,
        dueDate: now.add(const Duration(days: 14)),
        estimateHours: 6,
        timeSpentHours: 1,
        labels: const ['docs'],
        assignees: const [], // unassigned
        archived: false,
      ),
    ];
  }

  static List<Subtask> subtasks() {
    return [
      Subtask(
        id: 'st_2001',
        taskId: 't_1001',
        title: 'Flow map',
        status: SubtaskStatus.done,
        assigneeId: 'u_staff1',
        archived: false,
      ),
      Subtask(
        id: 'st_2002',
        taskId: 't_1001',
        title: 'Wireframes',
        status: SubtaskStatus.todo,
        assigneeId: 'u_staff1',
        archived: false,
      ),
      Subtask(
        id: 'st_2003',
        taskId: 't_1002',
        title: 'Auth API',
        status: SubtaskStatus.todo,
        assigneeId: 'u_staff2',
        archived: false,
      ),
      Subtask(
        id: 'st_2004',
        taskId: 't_1003',
        title: 'CI pipeline script',
        status: SubtaskStatus.done,
        assigneeId: 'u_staff1',
        archived: false,
      ),
      Subtask(
        id: 'st_2005',
        taskId: 't_1004',
        title: 'Outline docs',
        status: SubtaskStatus.todo,
        assigneeId: null,
        archived: false,
      ),
    ];
  }
}
