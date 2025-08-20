import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/core/theme/app_pallete.dart';
import 'package:taskflow_mini/core/widgets/delete_dialog.dart';
import 'package:taskflow_mini/core/widgets/empty_view.dart';
import 'package:taskflow_mini/core/widgets/error_view.dart';
import 'package:taskflow_mini/core/widgets/loading_list.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskflow_mini/src/tasks/data/repository/sub_task_repositoy_impl.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/sub_task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/subtask_bloc/bloc/subtask_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/sub_task/subtask_status_selector_sheet.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/sub_task/sub_task_dialog.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;
  const TaskDetailPage({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (ctx) => SubtaskBloc(
            repo: ctx.read<SubtaskRepositoryImpl>(),
            taskId: task.id,
          )..add(const SubtasksLoadRequested()),
      child: _TaskDetailView(task: task),
    );
  }
}

class _TaskDetailView extends StatelessWidget {
  final Task task;
  const _TaskDetailView({required this.task});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final users = (authState is AuthLoaded) ? authState.allUsers : <User>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title, style: context.textTheme.titleLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(task.title, style: context.textTheme.titleLarge),
                subtitle: Row(
                  children: [
                    Text(
                      'Priority: ${task.priority.name.toUpperCase()}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: task.priority.color,
                      ),
                    ),
                    Text(
                      ' • Status: ${task.status.name}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: task.status.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<SubtaskBloc, SubtaskState>(
                builder: (context, state) {
                  switch (state.status) {
                    case SubtaskStatusState.initial:
                    case SubtaskStatusState.loading:
                      return const Center(child: LoadingList());
                    case SubtaskStatusState.empty:
                      return Center(
                        child: EmptyView(
                          message: 'No subtasks found',
                          buttonMessage: 'Create your first subtask',
                          onCreate: () => _showCreateDialog(context),
                        ),
                      );
                    case SubtaskStatusState.error:
                      return Center(
                        child: ErrorView(
                          onRetry:
                              () => context.read<SubtaskBloc>().add(
                                const SubtasksLoadRequested(),
                              ),
                        ),
                      );
                    case SubtaskStatusState.ready:
                      return ListView.separated(
                        itemCount: state.subtasks.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final s = state.subtasks[i];
                          final assignee = users.firstWhere(
                            (u) => u.id == s.assigneeId,
                            orElse:
                                () => User(
                                  id: s.assigneeId ?? '',
                                  name: s.assigneeId ?? 'Unassigned',
                                  role: Role.staff,
                                ),
                          );
                          return ListTile(
                            leading:
                                s.status != SubtaskStatus.done &&
                                        s.status != SubtaskStatus.todo
                                    ? const Icon(
                                      Icons.block,
                                      color: AppPallete.errorColor,
                                    )
                                    : Checkbox(
                                      value: s.status == SubtaskStatus.done,
                                      onChanged: (_) {
                                        context.read<SubtaskBloc>().add(
                                          SubtaskUpdated(
                                            s.copyWith(
                                              status:
                                                  s.status == SubtaskStatus.done
                                                      ? SubtaskStatus.todo
                                                      : SubtaskStatus.done,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            title: Text(s.title),
                            subtitle:
                                s.assigneeId != null
                                    ? Text(
                                      'Assignee: ${assignee.name.isEmpty ? 'Unassigned' : assignee.name}',
                                    )
                                    : null,
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => _showEditDialog(context, s),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed:
                                      () => _confirmDelete(context, s.id),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.flag_circle),
                                  tooltip: "Change Status",
                                  onPressed: () async {
                                    final newStatus =
                                        await showModalBottomSheet<
                                          SubtaskStatus
                                        >(
                                          context: context,
                                          builder:
                                              (context) =>
                                                  SubTaskStatusSelectorSheet(
                                                    current: s.status,
                                                  ),
                                        );
                                    if (newStatus != null && context.mounted) {
                                      context.read<SubtaskBloc>().add(
                                        SubtaskUpdated(
                                          s.copyWith(status: newStatus),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => SubtaskDialog(
            taskId: task.id,
            subtaskBloc: context.read<SubtaskBloc>(),
          ),
    );
  }

  void _showEditDialog(BuildContext context, Subtask s) {
    showDialog(
      context: context,
      builder:
          (_) => SubtaskDialog(
            taskId: task.id,
            subtask: s,
            subtaskBloc: context.read<SubtaskBloc>(),
          ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (_) => DeleteDialog(
            onPressed: () {
              context.read<SubtaskBloc>().add(SubtaskDeleted(id));
              Navigator.of(context).pop();
            },
          ),
    );
  }
}
