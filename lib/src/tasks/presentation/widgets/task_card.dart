import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/core/extensions/double_extention.dart';
import 'package:taskflow_mini/core/security/permission_utilities.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/priority_pill.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/status_indicator.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/status_selector_sheet.dart';

typedef VoidStringCallback = void Function(String id);

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback? onTap;
  final void Function(TaskStatus)? onStatusChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onStatusChanged,
    this.onEdit,
    this.onArchive,
    this.onDelete,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _expanded = false;
  String meta = '';
  final _ctrl = TextEditingController();
  late User currentUser = (context.read<AuthBloc>().state as AuthLoaded).user;

  @override
  void initState() {
    meta = widget.task.priority.name.toUpperCase();
    if (widget.task.estimateHours > 0) {
      meta += ' • Est: ${widget.task.estimateHours}h';
    }
    meta += ' • Spent: ${widget.task.timeSpentHours}h';
    if (widget.task.dueDate != null) {
      meta +=
          ' • Due ${widget.task.dueDate!.toLocal().toString().split(' ').first}';
    }
    super.initState();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool fullEdit = canEditTaskFully(currentUser);
    final bool canStatus = canUpdateTaskStatus(currentUser, widget.task);
    final bool canTime = canUpdateTimeSpent(currentUser, widget.task);
    final bool canArchive = canArchiveOrDelete(currentUser);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                StatusIndicator(status: widget.task.status),
                4.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.task.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          PriorityPill(priority: widget.task.priority),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        meta,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (meta.isNotEmpty) const SizedBox(height: 10),

                      if (widget.task.description.isNotEmpty) ...[
                        AnimatedCrossFade(
                          firstChild: Text(
                            widget.task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          secondChild: Text(
                            widget.task.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                          crossFadeState:
                              _expanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                          firstCurve: Curves.easeInOut,
                          secondCurve: Curves.easeInOut,
                        ),
                        if (widget.task.description.isNotEmpty &&
                            widget.task.description.length > 80)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed:
                                  () => setState(() => _expanded = !_expanded),
                              icon: Icon(
                                _expanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                size: 18,
                              ),
                              label: Text(
                                _expanded ? 'Show less' : 'Read more',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                      ],

                      const SizedBox(height: 6),

                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          // Labels
                          ...widget.task.labels
                              .take(8)
                              .map(
                                (l) => Chip(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Text(
                                    l,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          ...widget.task.assignees.map((aId) {
                            final authState = context.read<AuthBloc>().state;
                            String name = aId;
                            if (authState is AuthLoaded) {
                              final u = authState.allUsers.firstWhere(
                                (u) => u.id == aId,
                                orElse:
                                    () => User(
                                      id: aId,
                                      name: aId,
                                      role: Role.staff,
                                    ),
                              );
                              name = u.name;
                            }
                            return Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              avatar: CircleAvatar(
                                radius: 10,
                                child: Text(
                                  name.isNotEmpty ? name[0] : '?',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              label: Text(
                                name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              visualDensity: VisualDensity.compact,
                            );
                          }),
                        ],
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (fullEdit)
                            IconButton(
                              tooltip: 'Edit',
                              onPressed: widget.onEdit,
                              icon: const Icon(Icons.edit_outlined),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (canArchive)
                            IconButton(
                              tooltip:
                                  widget.task.archived
                                      ? 'Unarchive'
                                      : 'Archive',
                              onPressed: widget.onArchive,
                              icon:
                                  widget.task.archived
                                      ? const Icon(Icons.unarchive)
                                      : const Icon(Icons.archive_outlined),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (canArchive)
                            IconButton(
                              tooltip: 'Delete',
                              onPressed: widget.onDelete,
                              icon: const Icon(Icons.delete_outline),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (canTime)
                            IconButton(
                              onPressed:
                                  () =>
                                      _showQuickTimeEdit(context, widget.task),
                              icon: const Icon(Icons.access_time),
                              tooltip: 'Log time',
                            ),
                          if (canStatus)
                            IconButton(
                              icon: const Icon(Icons.flag_circle),
                              tooltip: "Change Status",
                              onPressed: () async {
                                final newStatus =
                                    await showModalBottomSheet<TaskStatus>(
                                      context: context,
                                      builder:
                                          (context) => StatusSelectorSheet(
                                            current: widget.task.status,
                                          ),
                                    );
                                if (newStatus != null) {
                                  widget.onStatusChanged?.call(newStatus);
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickTimeEdit(BuildContext ctx, Task task) {
    showDialog(
      context: ctx,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Add time (hours)',
              style: context.textTheme.titleLarge,
            ),
            content: TextField(
              controller: _ctrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(hintText: 'e.g., 0.5'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final added = double.tryParse(_ctrl.text) ?? 0.0;
                  if (added <= 0) {
                    Navigator.of(ctx).pop();
                    return;
                  }
                  final updated = task.copyWith(
                    timeSpentHours: (task.timeSpentHours + added),
                  );
                  ctx.read<TaskBloc>().add(TaskUpdated(updated));
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
