import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/core/security/permission_utilities.dart';
import 'package:taskflow_mini/core/utils/task_filtering.dart';
import 'package:taskflow_mini/core/widgets/empty_view.dart';
import 'package:taskflow_mini/core/widgets/error_view.dart';
import 'package:taskflow_mini/core/widgets/loading_list.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/task_card.dart';

class TaskListView extends StatelessWidget {
  final Project project;
  final User currentUser;
  const TaskListView({
    super.key,
    required this.project,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        switch (state.status) {
          case TaskStatusState.loading:
          case TaskStatusState.initial:
            return const Center(child: LoadingList());
          case TaskStatusState.empty:
            return EmptyView(
              message: 'No tasks found',
              buttonMessage:
                  canCreateTask(currentUser) ? 'Create your first task' : null,
              onCreate:
                  () => context.push(
                    '/projects/${project.id}/create-update-task',
                    extra: (null, context.read<TaskBloc>()),
                  ),
            );
          case TaskStatusState.error:
            return ErrorView(
              onRetry:
                  () => context.read<TaskBloc>().add(TaskRefreshRequested()),
            );
          case TaskStatusState.ready:
            final filtered = applyTaskFilter(state);
            return RefreshIndicator(
              onRefresh:
                  () async =>
                      context.read<TaskBloc>().add(TaskRefreshRequested()),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final t = filtered[i];
                  return TaskCard(
                    onTap:
                        () => context.push(
                          '/projects/${project.id}/project-task/${t.id}',
                          extra: t,
                        ),
                    task: t,
                    onStatusChanged:
                        (taskStatus) => context.read<TaskBloc>().add(
                          TaskUpdated(t.copyWith(status: taskStatus)),
                        ),
                    onEdit:
                        () => context.push(
                          '/projects/${project.id}/create-update-task',
                          extra: (t, context.read<TaskBloc>()),
                        ),
                    onDelete: () => _confirmDelete(ctx, t.id),
                    onArchive:
                        () => context.read<TaskBloc>().add(TaskArchived(t.id)),
                  );
                },
              ),
            );
        }
      },
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
