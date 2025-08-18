import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/src/projects/data/repositories/project_repository_imp.dart';
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';
import 'package:taskflow_mini/src/projects/presentation/bloc/project_list_bloc.dart';
import 'package:taskflow_mini/src/projects/presentation/widgets/empty_view.dart';
import 'package:taskflow_mini/src/projects/presentation/widgets/error_view.dart';
import 'package:taskflow_mini/src/projects/presentation/widgets/loading_list.dart';
import 'package:taskflow_mini/src/projects/presentation/widgets/project_card.dart';
import 'package:taskflow_mini/src/projects/presentation/widgets/project_dialog.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (ctx) =>
              ProjectListBloc(ctx.read<ProjectRepositoryImpl>())
                ..add(const ProjectListLoaded()),
      child: const _ProjectListView(),
    );
  }
}

class _ProjectListView extends StatelessWidget {
  const _ProjectListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects', style: context.textTheme.displayLarge),
        actions: [
          BlocBuilder<ProjectListBloc, ProjectListState>(
            builder: (context, state) {
              return Switch.adaptive(
                value: state.includeArchived,
                onChanged:
                    (v) => context.read<ProjectListBloc>().add(
                      ProjectListLoaded(includeArchived: v),
                    ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context),
        label: Text('New Project', style: context.textTheme.bodyLarge),
        icon: const Icon(Icons.add),
      ),
      body: BlocConsumer<ProjectListBloc, ProjectListState>(
        listenWhen:
            (prev, curr) => prev.error != curr.error && curr.error != null,
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case ProjectListStatus.loading:
            case ProjectListStatus.initial:
              return const LoadingList();
            case ProjectListStatus.empty:
              return EmptyView(onCreate: () => _showCreateDialog(context));
            case ProjectListStatus.error:
              return ErrorView(
                onRetry: () {
                  context.read<ProjectListBloc>().add(
                    ProjectRefreshRequested(),
                  );
                },
              );
            case ProjectListStatus.ready:
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProjectListBloc>().add(
                    const ProjectRefreshRequested(),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: state.projects.length,
                  itemBuilder: (context, index) {
                    final project = state.projects[index];
                    return ProjectCard(
                      project: project,
                      onArchive: () {
                        context.read<ProjectListBloc>().add(
                          ProjectArchived(project.id),
                        );
                      },
                      onEdit: () => _showEditDialog(context, project),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ProjectDialog(bloc: context.read<ProjectListBloc>()),
    );
  }

  void _showEditDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder:
          (_) => ProjectDialog(
            bloc: context.read<ProjectListBloc>(),
            project: project,
          ),
    );
  }
}
