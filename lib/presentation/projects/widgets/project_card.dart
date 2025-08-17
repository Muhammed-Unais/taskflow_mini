import 'package:flutter/material.dart';
import 'package:taskflow_mini/domain/entities/project.dart';

class ProjectCard extends StatelessWidget {
  final VoidCallback onArchive;
  final VoidCallback onEdit;
  final Project project;

  const ProjectCard({
    super.key,
    required this.onArchive,
    required this.onEdit,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        title: Text(
          project.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          project.description.isEmpty ? 'No description' : project.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Archive',
              onPressed: onArchive,
              icon: Icon(Icons.archive_outlined, color: scheme.primary),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
