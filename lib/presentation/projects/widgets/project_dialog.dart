import 'package:flutter/material.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/domain/entities/project.dart';
import 'package:taskflow_mini/presentation/projects/bloc/project_list_bloc.dart';

class ProjectDialog extends StatefulWidget {
  const ProjectDialog({super.key, this.project, required this.bloc});
  final Project? project;
  final ProjectListBloc bloc;

  @override
  State<ProjectDialog> createState() => ProjectDialogState();
}

class ProjectDialogState extends State<ProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _nameCtrl.text = widget.project!.name;
      _descCtrl.text = widget.project!.description;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.project != null;

    return AlertDialog(
      title: Text(
        isEdit ? 'Edit Project' : 'New Project',
        style: context.textTheme.titleLarge?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                maxLength: 60,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name is required';
                  if (v.trim().length < 3) return 'Min 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 3,
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
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final name = _nameCtrl.text;
            final desc = _descCtrl.text;

            widget.bloc.add(ProjectCreated(name: name, description: desc));

            Navigator.of(context).pop();
          },
          child: Text("Create"),
        ),
      ],
    );
  }
}
