import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/domain/entities/task.dart';
import 'package:taskflow_mini/domain/entities/task_priority.dart';
import 'package:taskflow_mini/domain/entities/task_status.dart';

class TaskDialog extends StatefulWidget {
  final String projectId;
  final Task? task;

  const TaskDialog({super.key, required this.projectId, this.task});

  @override
  State<TaskDialog> createState() => TaskDialogState();
}

class TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _start;
  DateTime? _due;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
    BuildContext ctx,
    DateTime? initial,
    ValueChanged<DateTime?> onPicked,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: ctx,
      initialDate: initial ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    onPicked(picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_start != null && _due != null && _due!.isBefore(_start!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Due date must be same or after start date'),
        ),
      );
      return;
    }

    final base = widget.task;
    final task = Task(
      id: base?.id ?? '',
      projectId: widget.projectId,
      title: _title.text.trim(),
      description: _desc.text.trim(),
      status: base?.status ?? TaskStatus.todo,
      priority: _priority,
      startDate: _start,
      dueDate: _due,
      estimateHours: base?.estimateHours ?? 0.0,
      timeSpentHours: base?.timeSpentHours ?? 0.0,
      labels: base?.labels ?? [],
      assignees: base?.assignees ?? [],
      archived: base?.archived ?? false,
    );

    log(task.toJson().toString());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return AlertDialog(
      title: Text(
        isEdit ? 'Edit task' : 'New task',
        style: context.textTheme.titleLarge,
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Title required';
                  if (v.trim().length < 2) return 'Min 2 chars';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<TaskPriority>(
                alignment: Alignment.bottomCenter,

                value: _priority,
                items:
                    TaskPriority.values
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged:
                    (v) => setState(() => _priority = v ?? TaskPriority.medium),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  GestureDetector(
                    onTap:
                        () => _pickDate(
                          context,
                          _start,
                          (d) => setState(() => _start = d),
                        ),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignInside,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        _start == null
                            ? 'Set start'
                            : 'Start: ${_start!.toLocal().toString().split(' ').first}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap:
                        () => _pickDate(
                          context,
                          _due,
                          (d) => setState(() => _due = d),
                        ),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignInside,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        _due == null
                            ? 'Set due'
                            : 'Due: ${_due!.toLocal().toString().split(' ').first}',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
