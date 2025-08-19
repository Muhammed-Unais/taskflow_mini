import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/src/auth/presentation/page/user_selection_screen.dart';
import 'package:taskflow_mini/src/projects/presentation/pages/project_list_page.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/page/project_task_page.dart';
import 'package:taskflow_mini/src/tasks/presentation/page/task_creation_screen.dart';

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
      path: "/projects/:id/create-task",
      name: 'createTask',
      builder: (context, state) {
        final extraRecord = state.extra as (Task?, TaskBloc);
        final task = extraRecord.$1;
        final taskBloc = extraRecord.$2;

        return TaskCreationScreen(
          projectId: state.pathParameters['id']!,
          task: task,
          taskBloc: taskBloc,
        );
      },
    ),
  ],

  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Route error: ${state.error}'))),
);
