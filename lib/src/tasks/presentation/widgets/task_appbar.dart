import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/tasks/presentation/bloc/task_bloc.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Project project;
  const TaskAppBar({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(project.name),
      actions: [
        IconButton(
          tooltip: 'Report',
          onPressed:
              () => context.push(
                '/projects/${project.id}/report',
                extra: project,
              ),
          icon: const Icon(Icons.insert_chart_outlined),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return Switch.adaptive(
                value: state.includeArchived,
                onChanged: (v) {
                  context.read<TaskBloc>().add(
                    TaskLoadRequested(includeArchived: v),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
