import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/src/auth/presentation/page/user_selection_screen.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/projects/presentation/pages/project_list_page.dart';
import 'package:taskflow_mini/src/report/presentation/page/project_report_page.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/repository/task_repository.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/page/project_task_page.dart';
import 'package:taskflow_mini/src/tasks/presentation/page/task_creation_screen.dart';
import 'package:taskflow_mini/src/tasks/presentation/page/task_details_page.dart';

final appRouter = GoRouter(
  initialLocation: '/select-user',
  routes: [
    GoRoute(
      path: '/select-user',
      builder: (context, state) => const UserSelectionScreen(),
    ),
    GoRoute(
      path: '/projects',
      name: 'projects',
      builder: (context, state) => const ProjectListPage(),
    ),
    GoRoute(
      path: '/projects/:id',
      name: 'projectTasks',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return ProjectTasksPage(projectId: id);
      },
    ),
    GoRoute(
      path: "/projects/:id/create-update-task",
      name: 'createUpdateTask',
      builder: (context, state) {
        final extraRecord = state.extra as (Task?, TaskBloc);
        final task = extraRecord.$1;
        final taskBloc = extraRecord.$2;

        return TaskCreateUpdateScreen(
          projectId: state.pathParameters['id']!,
          task: task,
          taskBloc: taskBloc,
        );
      },
    ),
    GoRoute(
      path: "/projects/:id/project-task/:taskId",
      name: 'taskDetails',
      builder: (context, state) {
        final task = state.extra as Task;
        return TaskDetailPage(task: task);
      },
    ),

    GoRoute(
      path: '/projects/:id/report',
      builder: (context, state) {
        final extra = state.extra as Project;
        return ProjectReportPage(project: extra);
      },
    ),
  ],

  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Route error: ${state.error}'))),
);
