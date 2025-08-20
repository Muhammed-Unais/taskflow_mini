import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/core/security/permission_utilities.dart';
import 'package:taskflow_mini/core/theme/app_pallete.dart';
import 'package:taskflow_mini/core/utils/task_filtering.dart';
import 'package:taskflow_mini/core/widgets/empty_view.dart';
import 'package:taskflow_mini/core/widgets/error_view.dart';
import 'package:taskflow_mini/core/widgets/loading_list.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskflow_mini/src/projects/data/repository/project_repository_imp.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/tasks/data/repository/task_repository_impl.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/task_card.dart';

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
  State<ProjectTasksView> createState() => ProjectTasksViewState();
}

class ProjectTasksViewState extends State<ProjectTasksView> {
  final _searchCtrl = TextEditingController();
  late Future<Project?>? futureProject;

  @override
  void initState() {
    futureProject = context.read<ProjectRepositoryImpl>().fetchById(
      widget.projectId,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = (context.watch<AuthBloc>().state as AuthLoaded);
    final curentUser = auth.user;

    return FutureBuilder<Project?>(
      future: futureProject,
      builder: (c, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Scaffold(body: Center(child: LoadingList()), appBar: AppBar());
        }
        if (snap.hasError || snap.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Project')),
            body: Center(child: Text('Project not found or failed to load')),
          );
        }
        final project = snap.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(project.name),
            actions: [
              IconButton(
                tooltip: 'Report',
                onPressed: () {
                  context.push(
                    '/projects/${project.id}/report',
                    extra: project,
                  );
                },
                icon: const Icon(Icons.insert_chart_outlined),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    return Switch.adaptive(
                      value: state.includeArchived,
                      onChanged:
                          (v) => context.read<TaskBloc>().add(
                            TaskLoadRequested(includeArchived: v),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                searchAndStatusFilter(context),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            PriorityChip(
                              selected: state.priorities.contains(
                                TaskPriority.high,
                              ),
                              state: state,
                              value: TaskPriority.high,
                            ),
                            PriorityChip(
                              selected: state.priorities.contains(
                                TaskPriority.medium,
                              ),
                              state: state,

                              value: TaskPriority.medium,
                            ),
                            PriorityChip(
                              selected: state.priorities.contains(
                                TaskPriority.low,
                              ),
                              state: state,
                              value: TaskPriority.low,
                            ),
                            PriorityChip(
                              selected: state.priorities.contains(
                                TaskPriority.critical,
                              ),
                              state: state,
                              value: TaskPriority.critical,
                            ),

                            // assignees selector
                            ActionChip(
                              avatar: const Icon(Icons.group, size: 18),

                              label: Text(
                                "Assignees",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: AppPallete.greenColor,
                                ),
                              ),
                              onPressed: () {
                                _openAssigneeSheet(
                                  context,
                                  auth.allUsers,
                                  state,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _taskLIst(curentUser, project),
              ],
            ),
          ),
          floatingActionButton:
              canCreateTask(curentUser)
                  ? FloatingActionButton(
                    onPressed: () {
                      context.push(
                        '/projects/${project.id}/create-update-task',
                        extra: (null, context.read<TaskBloc>()),
                      );
                    },
                    child: const Icon(Icons.add),
                  )
                  : null,
        );
      },
    );
  }

  Future<void> _openAssigneeSheet(
    BuildContext context,
    List<User> users,
    TaskState? taskState,
  ) async {
    final selected = Set<String>.from(taskState?.assignees ?? []);

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(title: Text('Filter by assignees')),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children:
                            users.map((u) {
                              final checked = selected.contains(u.id);
                              return CheckboxListTile(
                                value: checked,
                                onChanged:
                                    (v) => setState(
                                      () =>
                                          v == true
                                              ? selected.add(u.id)
                                              : selected.remove(u.id),
                                    ),
                                title: Text(u.name),
                                subtitle: Text(u.role.name),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            context.read<TaskBloc>().add(
                              TaskFilterChanged(assignees: selected),
                            );

                            Navigator.pop(ctx);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Expanded _taskLIst(User curentUser, Project project) {
    return Expanded(
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          switch (state.status) {
            case TaskStatusState.loading:
            case TaskStatusState.initial:
              return const Center(child: LoadingList());
            case TaskStatusState.empty:
              return EmptyView(
                message: 'No tasks found',
                buttonMessage:
                    canCreateTask(curentUser) ? 'Create your first task' : null,
                onCreate: () {
                  context.push(
                    '/projects/${project.id}/create-update-task',
                    extra: (null, context.read<TaskBloc>()),
                  );
                },
              );
            case TaskStatusState.error:
              return ErrorView(
                onRetry:
                    () =>
                        context.read<TaskBloc>().add(const TaskLoadRequested()),
              );
            case TaskStatusState.ready:
              final filtered = applyTaskFilter(state);
              return RefreshIndicator(
                onRefresh:
                    () async =>
                        context.read<TaskBloc>().add(const TaskLoadRequested()),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final t = filtered[i];
                    return TaskCard(
                      onTap: () {
                        context.push(
                          '/projects/${project.id}/project-task/${t.id}',
                          extra: t,
                        );
                      },
                      task: t,
                      onStatusChanged: (taskStatus) {
                        context.read<TaskBloc>().add(
                          TaskUpdated(t.copyWith(status: taskStatus)),
                        );
                      },
                      onEdit:
                          () => context.push(
                            '/projects/${project.id}/create-update-task',
                            extra: (t, context.read<TaskBloc>()),
                          ),
                      onDelete: () => _confirmDelete(ctx, t.id),
                      onArchive:
                          () =>
                              context.read<TaskBloc>().add(TaskArchived(t.id)),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  Padding searchAndStatusFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search tasks',
              ),
              onChanged:
                  (v) => context.read<TaskBloc>().add(
                    TaskFilterChanged(search: v.isEmpty ? null : v),
                  ),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return PopupMenuButton<String>(
                onSelected: (s) {
                  context.read<TaskBloc>().add(
                    TaskFilterChanged(statusFilter: s),
                  );
                },

                itemBuilder:
                    (_) => [
                      PopupMenuItem(
                        value: 'all',
                        child: Text(
                          'All status',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color:
                                state.statusFilter == "all"
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.todo.name,
                        child: Text(
                          TaskStatus.todo.displayName,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color:
                                TaskStatus.todo.name == state.statusFilter
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.inProgress.name,
                        child: Text(
                          TaskStatus.inProgress.displayName,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color:
                                TaskStatus.inProgress.name == state.statusFilter
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.blocked.name,
                        child: Text(
                          TaskStatus.blocked.displayName,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color:
                                TaskStatus.blocked.name == state.statusFilter
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.inReview.name,
                        child: Text(
                          TaskStatus.inReview.displayName,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color:
                                TaskStatus.inReview.name == state.statusFilter
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.done.name,
                        child: Text(
                          TaskStatus.done.displayName,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color:
                                TaskStatus.done.name == state.statusFilter
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                      ),
                    ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: const [
                      Icon(Icons.filter_list),
                      SizedBox(width: 6),
                      Text('Filter'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Delete task?', style: context.textTheme.titleLarge),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  context.read<TaskBloc>().add(TaskDeleted(id));
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class PriorityChip extends StatelessWidget {
  final TaskPriority value;
  final TaskState state;
  final bool selected;
  const PriorityChip({
    super.key,
    required this.value,
    required this.selected,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        value.displayName,
        style: context.textTheme.bodyMedium?.copyWith(
          color: selected ? AppPallete.greenColor : null,
        ),
      ),
      selected: selected,
      onSelected: (v) {
        Set<TaskPriority> priorities = {...state.priorities};

        if (v) {
          priorities.add(value);
        } else {
          priorities.remove(value);
        }

        context.read<TaskBloc>().add(TaskFilterChanged(priorities: priorities));
      },
    );
  }
}
