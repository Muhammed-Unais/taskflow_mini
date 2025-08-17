import 'package:flutter/material.dart';
import 'package:taskflow_mini/core/theme/theme.dart';
import 'package:taskflow_mini/presentation/projects/pages/project_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'taskflow_mini',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const ProjectListPage(),
    );
  }
}
