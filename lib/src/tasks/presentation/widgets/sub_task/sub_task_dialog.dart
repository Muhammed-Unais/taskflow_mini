import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/sub_task.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/subtask_bloc/bloc/subtask_bloc.dart';

class SubtaskDialog extends StatefulWidget {
  final String taskId;
  final Subtask? subtask;
  final SubtaskBloc subtaskBloc;
  const SubtaskDialog({
    super.key,
    required this.taskId,
    this.subtask,
    required this.subtaskBloc,
  });

  @override
  State<SubtaskDialog> createState() => SubtaskDialogState();
}

class SubtaskDialogState extends State<SubtaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  String? _assigneeId;
  SubtaskStatus _status = SubtaskStatus.todo;

  @override
  void initState() {
    super.initState();
    if (widget.subtask != null) {
      _title.text = widget.subtask!.title;
      _assigneeId = widget.subtask!.assigneeId;
      _status = widget.subtask!.status;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final users = (authState is AuthLoaded) ? authState.allUsers : <User>[];

    return AlertDialog(
      title: Text(
        widget.subtask == null ? 'New subtask' : 'Edit subtask',
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
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                value: _assigneeId,
                decoration: const InputDecoration(
                  labelText: 'Assignee (optional)',
                ),
                items:
                    [
                      const DropdownMenuItem(
                        value: "",
                        child: Text('Unassigned'),
                      ),
                    ] +
                    users
                        .map(
                          (u) => DropdownMenuItem(
                            value: u.id,
                            child: Text(u.name),
                          ),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _assigneeId = v),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<SubtaskStatus>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items:
                    SubtaskStatus.values
                        .map(
                          (s) =>
                              DropdownMenuItem(value: s, child: Text(s.name)),
                        )
                        .toList(),
                onChanged:
                    (v) => setState(() => _status = v ?? SubtaskStatus.todo),
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
          child: Text(widget.subtask == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final base = widget.subtask;
    final subtask = Subtask(
      id: base?.id ?? '',
      taskId: widget.taskId,
      title: _title.text.trim(),
      status: _status,
      assigneeId: _assigneeId,
      archived: base?.archived ?? false,
    );

    final bloc = widget.subtaskBloc;
    if (base == null) {
      bloc.add(SubtaskCreated(subtask));
    } else {
      bloc.add(SubtaskUpdated(subtask));
    }
    Navigator.of(context).pop();
  }
}
