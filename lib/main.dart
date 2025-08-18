import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_mini/core/router/app_router.dart';
import 'package:taskflow_mini/core/theme/theme.dart';
import 'package:taskflow_mini/src/projects/data/data_sources/project_local_data_source.dart';
import 'package:taskflow_mini/src/auth/data/data_sources/user_local_data_source.dart';
import 'package:taskflow_mini/src/auth/data/repositories/auth_repository_impl.dart';
import 'package:taskflow_mini/src/projects/data/repositories/project_repository_imp.dart';
import 'package:taskflow_mini/src/auth/presentation/bloc/auth_bloc.dart';

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
        RepositoryProvider(
          create: (_) => AuthRepositoryImpl(UserLocalDataSource()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (ctx) =>
                    AuthBloc(authRepository: ctx.read<AuthRepositoryImpl>())
                      ..add(AuthLoad()),
          ),
        ],

        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'taskflow_mini',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
