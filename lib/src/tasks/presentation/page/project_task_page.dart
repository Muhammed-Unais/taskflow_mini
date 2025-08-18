import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';
import 'package:taskflow_mini/src/tasks/presentation/widgets/task_card.dart';

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
                return TaskCard(
                  task: Task(
                    id: '',
                    projectId: '',
                    title: 'Task $i',
                    description:
                        'New tech world can say everything in the future',
                    status: TaskStatus.inProgress,
                    priority: TaskPriority.low,
                    startDate: DateTime.now(),
                    dueDate: DateTime.now(),
                    estimateHours: 0,
                    timeSpentHours: 0,
                    // labels: ["l1", "l2", "l3"],
                    // assignees: ["u_staff1", "u_staff2", "u_admin"],
                    archived: false,
                  ),
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
        onPressed: () {
          context.push('/projects/${widget.project.id}/create-task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
