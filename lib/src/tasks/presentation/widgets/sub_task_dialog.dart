import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart'
    show AuthBloc, AuthLoaded;

class SubtaskDialog extends StatefulWidget {
  final String taskId;
  const SubtaskDialog({super.key, required this.taskId});

  @override
  State<SubtaskDialog> createState() => SubtaskDialogState();
}

class SubtaskDialogState extends State<SubtaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  String? _assigneeId;

  @override
  void initState() {
    super.initState();
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
      title: Text('New subtask', style: context.textTheme.titleLarge),
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: Text('Create')),
      ],
    );
  }

  void _submit() {
    Navigator.of(context).pop();
  }
}
