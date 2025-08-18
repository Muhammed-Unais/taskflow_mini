import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/data/repositories/project_repository_imp.dart';
import 'package:taskflow_mini/domain/entities/project.dart';
import 'package:taskflow_mini/presentation/projects/pages/project_list_page.dart';
import 'package:taskflow_mini/presentation/tasks/page/project_task_page.dart';

final appRouter = GoRouter(
  initialLocation: '/projects',
  routes: [
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
  ],

  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Route error: ${state.error}'))),
);
