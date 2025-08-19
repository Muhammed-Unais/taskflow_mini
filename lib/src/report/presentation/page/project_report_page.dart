import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/report/data/repository/report_repository_impl.dart';
import 'package:taskflow_mini/src/report/domain/entities/project_report.dart';
import 'package:taskflow_mini/src/report/domain/repository/report_repository.dart';
import 'package:taskflow_mini/src/report/presentation/bloc/report_bloc.dart';
import 'package:taskflow_mini/src/tasks/data/repository/task_repository_impl.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_status.dart';

class ProjectReportPage extends StatelessWidget {
  final Project project;
  const ProjectReportPage({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ReportRepository>(
      create: (ctx) => ReportRepositoryImpl(context.read<TaskRepositoryImpl>()),
      child: BlocProvider(
        create:
            (ctx) => ReportBloc(
              repo: ctx.read<ReportRepository>(),
              projectId: project.id,
            )..add(const ReportLoadRequested()),
        child: _ProjectReportView(project: project),
      ),
    );
  }
}

class _ProjectReportView extends StatelessWidget {
  final Project project;
  const _ProjectReportView({required this.project});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final users = (authState is AuthLoaded) ? authState.allUsers : <User>[];

    return Scaffold(
      appBar: AppBar(
        title: Text('${project.name} — Report'),
        actions: [
          BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              return IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed:
                    () => context.read<ReportBloc>().add(
                      const ReportRefreshRequested(),
                    ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            switch (state.status) {
              case ReportStatus.initial:
              case ReportStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ReportStatus.empty:
                return Center(child: Text('No tasks found for this project.'));
              case ReportStatus.error:
                return Center(
                  child: Text('Failed to load report: ${state.error}'),
                );
              case ReportStatus.ready:
                final report = state.report!;
                return Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTilesVertical(context, report),

                    const Text(
                      'Open tasks by assignee',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    Expanded(child: _buildOpenByAssignee(report, users)),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTilesVertical(BuildContext context, ProjectReport report) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final done = (report.countsByStatus[TaskStatus.done.name] ?? 0).toString();
    final inProgress =
        (report.countsByStatus[TaskStatus.inProgress.name] ?? 0).toString();
    final blocked =
        (report.countsByStatus[TaskStatus.blocked.name] ?? 0).toString();
    final total = report.total.toString();
    final overdue = report.overdue.toString();
    final completionPct = report.completionPercent;

    final metrics = <Map<String, Object>>[
      {
        'key': 'total',
        'title': 'Total tasks',
        'value': total,
        'icon': Icons.dashboard,
      },
      {
        'key': 'done',
        'title': 'Done',
        'value': done,
        'icon': Icons.check_circle,
      },
      {
        'key': 'inProgress',
        'title': 'In Progress',
        'value': inProgress,
        'icon': Icons.autorenew,
      },
      {
        'key': 'blocked',
        'title': 'Blocked',
        'value': blocked,
        'icon': Icons.block,
      },
      {
        'key': 'overdue',
        'title': 'Overdue',
        'value': overdue,
        'icon': Icons.schedule,
      },
      {
        'key': 'completion',
        'title': 'Completion',
        'value': '${completionPct.toStringAsFixed(1)}%',
        'icon': Icons.show_chart,
      },
    ];

    return Column(
      children:
          metrics.map((m) {
            final title = m['title'] as String;
            final value = m['value'] as String;
            final icon = m['icon'] as IconData;
            final isCompletion = (m['key'] as String) == 'completion';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // icon block
                    Container(
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Icon(icon, color: primary, size: 22),
                    ),

                    const SizedBox(width: 12),

                    // title + subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _tileSubtitle(title),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // value + extra (progress for completion)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (isCompletion) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 140,
                            child: LinearProgressIndicator(
                              value: (completionPct / 100).clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: theme.colorScheme.onSurface
                                  .withOpacity(0.06),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${completionPct.toStringAsFixed(1)}% of tasks done',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  String _tileSubtitle(String title) {
    switch (title) {
      case 'Total tasks':
        return 'Tasks in project';
      case 'Done':
        return 'Completed tasks';
      case 'In Progress':
        return 'Currently active';
      case 'Blocked':
        return 'Needs attention';
      case 'Overdue':
        return 'Past due & open';
      default:
        return '';
    }
  }

  Widget _buildOpenByAssignee(ProjectReport report, List<User> users) {
    final entries =
        report.openByAssignee.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)); // descending count

    if (entries.isEmpty) {
      return const Center(child: Text('No open tasks.'));
    }

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (ctx, i) {
        final e = entries[i];
        final key = e.key;
        final count = e.value;
        final user = users.firstWhere(
          (u) => u.id == key,
          orElse:
              () => User(
                id: key,
                name: key == 'unassigned' ? 'Unassigned' : key,
                role: Role.staff,
              ),
        );
        return ListTile(
          leading: CircleAvatar(
            child: Text(user.name.isNotEmpty ? user.name[0] : '?'),
          ),
          title: Text(user.name),
          trailing: Text(
            count.toString(),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        );
      },
    );
  }
}
