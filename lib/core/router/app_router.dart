import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/src/projects/data/repositories/project_repository_imp.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/auth/presentation/page/user_selection_screen.dart';
import 'package:taskflow_mini/src/projects/presentation/pages/project_list_page.dart';
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
        final repo = context.read<ProjectRepositoryImpl>();
        return FutureBuilder<Project?>(
          future: repo.fetchById(id),
          builder: (c, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snap.hasError || snap.data == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Project')),
                body: Center(
                  child: Text('Project not found or failed to load'),
                ),
              );
            }
            return ProjectTasksView(project: snap.data!);
          },
        );
      },
    ),
    GoRoute(
      path: "/projects/:id/create-task",
      name: 'createTask',
      builder:
          (context, state) =>
              TaskCreationScreen(projectId: state.pathParameters['id']!),
    ),
  ],

  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Route error: ${state.error}'))),
);
