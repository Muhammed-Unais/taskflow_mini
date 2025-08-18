import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/extensions/double_extention.dart';
import 'package:taskflow_mini/domain/entities/task.dart';
import 'package:taskflow_mini/domain/entities/task_priority.dart';
import 'package:taskflow_mini/domain/entities/task_status.dart';
import 'package:taskflow_mini/domain/entities/user.dart';
import 'package:taskflow_mini/presentation/auth/bloc/auth_bloc.dart';

typedef VoidStringCallback = void Function(String id);

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleStatus,
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
  Widget build(BuildContext context) {
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
                                ?.copyWith(color: Colors.grey[800]),
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
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: widget.onEdit,
                      icon: const Icon(Icons.edit_outlined),
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      tooltip: 'Archive',
                      onPressed: widget.onArchive,
                      icon: const Icon(Icons.archive_outlined),
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline),
                      visualDensity: VisualDensity.compact,
                    ),
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
                          widget.onToggleStatus!();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PriorityPill extends StatelessWidget {
  final TaskPriority priority;
  const PriorityPill({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = priority.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final TaskStatus status;

  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: status.color, width: 1),
      ),
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(
          status.displayName,
          style: TextStyle(color: status.color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class StatusSelectorSheet extends StatelessWidget {
  final TaskStatus current;

  const StatusSelectorSheet({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final statuses = TaskStatus.values;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Change Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...statuses.map(
            (s) => ListTile(
              leading: CircleAvatar(radius: 8, backgroundColor: s.color),
              title: Text(s.displayName),
              trailing:
                  s == current
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
              onTap: () => Navigator.pop(context, s),
            ),
          ),
        ],
      ),
    );
  }
}
