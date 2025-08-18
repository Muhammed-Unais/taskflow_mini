import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:taskflow_mini/src/projects/domain/entities/project.dart';

class ProjectLocalDataSource {
  final _latency = Duration(milliseconds: 550 + Random().nextInt(250));

  final List<Project> _projects = [];
  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/projects.json');
      final list = (json.decode(jsonStr) as List).cast<Map<String, dynamic>>();
      _projects
        ..clear()
        ..addAll(list.map(Project.fromJson));
      _initialized = true;
    } catch (_) {
      _initialized = true;
    }
  }

  Future<List<Project>> fetchAll({bool includeArchived = false}) async {
    await _ensureInit();
    await Future.delayed(_latency);
    final data =
        includeArchived
            ? List<Project>.unmodifiable(_projects)
            : List<Project>.unmodifiable(_projects.where((p) => !p.archived));
    return data;
  }

  Future<Project> create({
    required String name,
    required String description,
  }) async {
    await _ensureInit();
    await Future.delayed(_latency);
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Project name cannot be empty.');
    }
    if (_projects.any((p) => p.name.toLowerCase() == trimmed.toLowerCase())) {
      throw StateError('A project with the same name already exists.');
    }
    final project = Project(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      name: trimmed,
      description: description.trim(),
      archived: false,
    );
    _projects.add(project);
    return project;
  }

  Future<Project> update(Project project) async {
    await _ensureInit();
    await Future.delayed(_latency);
    final idx = _projects.indexWhere((p) => p.id == project.id);
    if (idx == -1) throw StateError('Project not found.');
    if (_projects.any(
      (p) =>
          p.id != project.id &&
          p.name.toLowerCase() == project.name.trim().toLowerCase(),
    )) {
      throw StateError('Another project already has this name.');
    }
    _projects[idx] = project.copyWith(
      name: project.name.trim(),
      description: project.description.trim(),
    );
    return _projects[idx];
  }

  Future<void> archive(String projectId) async {
    await _ensureInit();
    await Future.delayed(_latency);
    final idx = _projects.indexWhere((p) => p.id == projectId);
    if (idx == -1) throw StateError('Project not found.');
    _projects[idx] = _projects[idx].copyWith(
      archived: !_projects[idx].archived,
    );
  }

  Future<Project?> fetchById(String id) async {
    await _ensureInit();
    await Future.delayed(_latency);
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
