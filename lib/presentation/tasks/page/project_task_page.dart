import 'package:flutter/material.dart';
import 'package:taskflow_mini/domain/entities/project.dart';
import 'package:taskflow_mini/presentation/tasks/widgets/task_dialog.dart';
import 'package:taskflow_mini/presentation/tasks/widgets/task_tile.dart';

class ProjectTasksView extends StatefulWidget {
  final Project project;
  const ProjectTasksView({super.key, required this.project});

  @override
  State<ProjectTasksView> createState() => ProjectTasksViewState();
}

class ProjectTasksViewState extends State<ProjectTasksView> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            tooltip: 'Add task',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search tasks',
                    ),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {},
                  itemBuilder:
                      (_) => [
                        const PopupMenuItem(
                          value: 'all',
                          child: Text('All status'),
                        ),
                        const PopupMenuItem(
                          value: 'todo',
                          child: Text('To do'),
                        ),
                        const PopupMenuItem(
                          value: 'inProgress',
                          child: Text('In progress'),
                        ),
                        const PopupMenuItem(
                          value: 'blocked',
                          child: Text('Blocked'),
                        ),
                        const PopupMenuItem(
                          value: 'inReview',
                          child: Text('In review'),
                        ),
                        const PopupMenuItem(value: 'done', child: Text('Done')),
                      ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: const [
                        Icon(Icons.filter_list),
                        SizedBox(width: 6),
                        Text('Filter'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: 2,
              itemBuilder: (ctx, i) {
                return TaskTile(
                  onToggleStatus: () {},
                  onEdit: () {},
                  onDelete: () {},
                  onArchive: () {},
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => TaskDialog(projectId: widget.project.id),
    );
  }
}
