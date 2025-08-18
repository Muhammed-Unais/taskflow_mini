import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/router/app_router.dart';
import 'package:taskflow_mini/core/theme/theme.dart';
import 'package:taskflow_mini/data/datasources/project_local_data_source.dart';
import 'package:taskflow_mini/data/repositories/project_repository_imp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => ProjectRepositoryImpl(ProjectLocalDataSource()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'taskflow_mini',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: appRouter,
      ),
    );
  }
}
