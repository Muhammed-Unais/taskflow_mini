import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/core/extensions/double_extention.dart';
import 'package:taskflow_mini/core/theme/app_pallete.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart';

class TaskCreationScreen extends StatefulWidget {
  final String projectId;
  final Task? task;
  const TaskCreationScreen({super.key, required this.projectId, this.task});

  @override
  State<TaskCreationScreen> createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _estimateCtrl = TextEditingController();
  final _timeSpentCtrl = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.todo;
  DateTime? _start;
  DateTime? _due;
  final List<String> _labels = [];
  final List<String> _assignees = [];

  @override
  void initState() {
    super.initState();
    _initFromTask();
  }

  void _initFromTask() {
    if (widget.task == null) return;
    final t = widget.task!;
    _title.text = t.title;
    _desc.text = t.description;
    _priority = t.priority;
    _status = t.status;
    _start = t.startDate;
    _due = t.dueDate;
    _estimateCtrl.text = t.estimateHours > 0 ? t.estimateHours.toString() : '';
    _timeSpentCtrl.text =
        t.timeSpentHours > 0 ? t.timeSpentHours.toString() : '';
    _labels.addAll(t.labels);
    _assignees.addAll(t.assignees);
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _estimateCtrl.dispose();
    _timeSpentCtrl.dispose();
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

  Future<void> _chooseAssignees() async {
    final selected = Set<String>.from(_assignees);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Select assignees'),
                    trailing: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Done'),
                    ),
                  ),
                  const Divider(),
                  Flexible(
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final users = (state as AuthLoaded).allUsers;
                        return ListView(
                          shrinkWrap: true,
                          children:
                              users.map((u) {
                                final checked = selected.contains(u.id);
                                return CheckboxListTile(
                                  title: Text(u.name),
                                  subtitle: Text(u.role.name),
                                  value: checked,
                                  onChanged: (v) {
                                    setState(() {
                                      if (v == true) {
                                        selected.add(u.id);
                                      } else {
                                        selected.remove(u.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    setState(() {
      _assignees
        ..clear()
        ..addAll(selected);
    });
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

    final estimate = double.tryParse(_estimateCtrl.text) ?? 0.0;
    final timeSpent = double.tryParse(_timeSpentCtrl.text) ?? 0.0;

    final base = widget.task;
    final task = Task(
      id: base?.id ?? '',
      projectId: widget.projectId,
      title: _title.text.trim(),
      description: _desc.text.trim(),
      status: _status,
      priority: _priority,
      startDate: _start,
      dueDate: _due,
      estimateHours: estimate,
      timeSpentHours: timeSpent,
      labels: List.unmodifiable(_labels),
      assignees: List.unmodifiable(_assignees),
      archived: base?.archived ?? false,
    );

    log(task.toString());
    Navigator.of(context).pop(task);
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _title,
      decoration: const InputDecoration(labelText: 'Title'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Title required';
        if (v.trim().length < 2) return 'Min 2 chars';
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _desc,
      decoration: const InputDecoration(labelText: 'Description (optional)'),
      maxLines: 4,
    );
  }

  Widget _buildStatusPriorityRow() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<TaskStatus>(
            value: _status,
            decoration: const InputDecoration(labelText: 'Status'),
            items:
                TaskStatus.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                    .toList(),
            onChanged: (v) => setState(() => _status = v ?? TaskStatus.todo),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<TaskPriority>(
            value: _priority,
            decoration: const InputDecoration(labelText: 'Priority'),
            items:
                TaskPriority.values
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
            onChanged:
                (v) => setState(() => _priority = v ?? TaskPriority.medium),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed:
                () => _pickDate(
                  context,
                  _start,
                  (d) => setState(() => _start = d),
                ),
            child: Text(
              _start == null
                  ? 'Set start'
                  : 'Start: ${_start!.toLocal().toString().split(' ').first}',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed:
                () => _pickDate(context, _due, (d) => setState(() => _due = d)),
            child: Text(
              _due == null
                  ? 'Set due'
                  : 'Due: ${_due!.toLocal().toString().split(' ').first}',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstimateTimeRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _estimateCtrl,
            decoration: const InputDecoration(labelText: 'Estimate (hours)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _timeSpentCtrl,
            decoration: const InputDecoration(labelText: 'Time spent (hours)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelsAssigneesRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _labels.join(','),
            decoration: const InputDecoration(
              labelText: 'Labels (comma separated)',
            ),
            onChanged:
                (v) => setState(() {
                  _labels
                    ..clear()
                    ..addAll(
                      v
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty),
                    );
                }),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: _chooseAssignees,
          child: const Text('Assignees'),
        ),
      ],
    );
  }

  Widget _buildAvailableUsersSection(List<User> users) {
    if (users.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          'Available users: ${users.length}',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              _assignees.map((id) {
                final u = users.firstWhere(
                  (u) => u.id == id,
                  orElse: () => User(id: id, name: id, role: Role.staff),
                );
                return Chip(
                  label: Text(u.name),
                  avatar: CircleAvatar(
                    child: Center(
                      child: Text(
                        u.name.isNotEmpty ? u.name[0] : '?',
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    final authState = context.watch<AuthBloc>().state;
    List<User> users = const [];

    users = (authState as AuthLoaded).allUsers;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit task' : 'New task'),
        actions: [
          GestureDetector(
            onTap: _submit,
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Row(
                children: [
                  const Icon(Icons.save),
                  6.width,
                  Text('Save task', style: context.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 14,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitleField(),
                _buildDescriptionField(),
                _buildStatusPriorityRow(),
                _buildDateRow(),
                _buildEstimateTimeRow(),
                _buildLabelsAssigneesRow(),
                _buildAvailableUsersSection(users),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
