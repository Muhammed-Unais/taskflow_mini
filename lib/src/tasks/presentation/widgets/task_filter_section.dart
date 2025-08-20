import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/core/theme/app_pallete.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/proirity_chip_reusable.dart';

class TaskFilterSection extends StatelessWidget {
  final TextEditingController searchController;
  final List<User> allUsers;
  const TaskFilterSection({
    super.key,
    required this.searchController,
    required this.allUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
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
              _StatusPopup(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                return Wrap(
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    PriorityChipReusable(
                      value: TaskPriority.high,
                      selected: state.priorities.contains(TaskPriority.high),
                      onChanged:
                          (v) => _onPriorityChanged(
                            context,
                            state,
                            TaskPriority.high,
                            v,
                          ),
                    ),
                    PriorityChipReusable(
                      value: TaskPriority.medium,
                      selected: state.priorities.contains(TaskPriority.medium),
                      onChanged:
                          (v) => _onPriorityChanged(
                            context,
                            state,
                            TaskPriority.medium,
                            v,
                          ),
                    ),
                    PriorityChipReusable(
                      value: TaskPriority.low,
                      selected: state.priorities.contains(TaskPriority.low),
                      onChanged:
                          (v) => _onPriorityChanged(
                            context,
                            state,
                            TaskPriority.low,
                            v,
                          ),
                    ),
                    PriorityChipReusable(
                      value: TaskPriority.critical,
                      selected: state.priorities.contains(
                        TaskPriority.critical,
                      ),
                      onChanged:
                          (v) => _onPriorityChanged(
                            context,
                            state,
                            TaskPriority.critical,
                            v,
                          ),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.group, size: 18),
                      label: Text(
                        'Assignees',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppPallete.greenColor,
                        ),
                      ),
                      onPressed:
                          () => AssigneeSelectorSheet.show(
                            context: context,
                            users: allUsers,
                            currentState: context.read<TaskBloc>().state,
                          ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onPriorityChanged(
    BuildContext ctx,
    TaskState state,
    TaskPriority value,
    bool selected,
  ) {
    final priorities = {...state.priorities};
    if (selected) {
      priorities.add(value);
    } else {
      priorities.remove(value);
    }
    ctx.read<TaskBloc>().add(TaskFilterChanged(priorities: priorities));
  }
}

class _StatusPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return PopupMenuButton<String>(
          onSelected:
              (s) => context.read<TaskBloc>().add(
                TaskFilterChanged(statusFilter: s),
              ),
          itemBuilder:
              (_) => [
                PopupMenuItem(
                  value: 'all',
                  child: _statusText(
                    context,
                    'All status',
                    state.statusFilter == 'all',
                  ),
                ),
                PopupMenuItem(
                  value: TaskStatus.todo.name,
                  child: _statusText(
                    context,
                    TaskStatus.todo.displayName,
                    TaskStatus.todo.name == state.statusFilter,
                  ),
                ),
                PopupMenuItem(
                  value: TaskStatus.inProgress.name,
                  child: _statusText(
                    context,
                    TaskStatus.inProgress.displayName,
                    TaskStatus.inProgress.name == state.statusFilter,
                  ),
                ),
                PopupMenuItem(
                  value: TaskStatus.blocked.name,
                  child: _statusText(
                    context,
                    TaskStatus.blocked.displayName,
                    TaskStatus.blocked.name == state.statusFilter,
                  ),
                ),
                PopupMenuItem(
                  value: TaskStatus.inReview.name,
                  child: _statusText(
                    context,
                    TaskStatus.inReview.displayName,
                    TaskStatus.inReview.name == state.statusFilter,
                  ),
                ),
                PopupMenuItem(
                  value: TaskStatus.done.name,
                  child: _statusText(
                    context,
                    TaskStatus.done.displayName,
                    TaskStatus.done.name == state.statusFilter,
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
    );
  }

  Widget _statusText(BuildContext context, String text, bool selected) {
    return Text(
      text,
      style: context.textTheme.bodyMedium?.copyWith(
        color: selected ? Colors.green : null,
      ),
    );
  }
}

class AssigneeSelectorSheet {
  static Future<void> show({
    required BuildContext context,
    required List<User> users,
    required TaskState currentState,
  }) async {
    final selected = Set<String>.from(currentState.assignees);

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
}
