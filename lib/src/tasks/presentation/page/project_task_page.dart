import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/core/security/permission_utilities.dart';
import 'package:taskflow_mini/core/widgets/loading_list.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskflow_mini/src/projects/data/repository/project_repository_imp.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/tasks/data/repository/task_repository_impl.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/task_appbar.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/task_filter_section.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/task_list_view.dart';

class ProjectTasksPage extends StatelessWidget {
  final String projectId;
  const ProjectTasksPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (ctx) => TaskBloc(
            repo: ctx.read<TaskRepositoryImpl>(),
            projectId: projectId,
          )..add(const TaskLoadRequested()),
      child: ProjectTasksView(projectId: projectId),
    );
  }
}

class ProjectTasksView extends StatefulWidget {
  const ProjectTasksView({super.key, required this.projectId});
  final String projectId;

  @override
  State<ProjectTasksView> createState() => _ProjectTasksViewState();
}

class _ProjectTasksViewState extends State<ProjectTasksView> {
  final _searchCtrl = TextEditingController();
  late Future<Project?>? _futureProject;

  @override
  void initState() {
    super.initState();
    _futureProject = context.read<ProjectRepositoryImpl>().fetchById(
      widget.projectId,
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthLoaded) {
      return Scaffold(body: Center(child: LoadingList()), appBar: AppBar());
    }
    final currentUser = authState.user;

    return FutureBuilder<Project?>(
      future: _futureProject,
      builder: (c, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Scaffold(body: Center(child: LoadingList()), appBar: AppBar());
        }

        if (snap.hasError || snap.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Project')),
            body: const Center(
              child: Text('Project not found or failed to load'),
            ),
          );
        }

        final project = snap.data!;

        return Scaffold(
          appBar: TaskAppBar(project: project),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TaskFilterSection(
                  searchController: _searchCtrl,
                  allUsers: authState.allUsers,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TaskListView(
                    project: project,
                    currentUser: currentUser,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton:
              canCreateTask(currentUser)
                  ? FloatingActionButton(
                    onPressed:
                        () => context.push(
                          '/projects/${project.id}/create-update-task',
                          extra: (null, context.read<TaskBloc>()),
                        ),
                    child: const Icon(Icons.add),
                  )
                  : null,
        );
      },
    );
  }
}
