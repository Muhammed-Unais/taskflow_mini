import 'package:flutter/material.dart';
import 'package:taskflow_mini/presentation/projects/widget/project_card.dart';
import 'package:taskflow_mini/presentation/projects/widget/project_dialog.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProjectListView();
  }
}

class _ProjectListView extends StatelessWidget {
  const _ProjectListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context),
        label: const Text('New Project'),
        icon: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: 2,
          itemBuilder: (context, index) {
            return ProjectCard(
              onArchive: () {},
              onEdit: () => _showEditDialog(context),
            );
          },
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => ProjectDialog());
  }

  void _showEditDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => ProjectDialog());
  }
}
