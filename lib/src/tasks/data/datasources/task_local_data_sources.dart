import 'dart:math';
import 'package:taskflow_mini/core/data/data_source/seed_data_source.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task.dart';

class TaskLocalDataSource {
  final _random = Random();
  final _latencyBase = 500;
  final List<Task> _tasks = [];
  bool _initialized = false;

  Future<void> _init() async {
    await Future.delayed(Duration.zero);
    //
    if (!SeedConfig.enabled) return;
    if (_initialized) return;
    await Future.delayed(Duration.zero);
    if (_tasks.isEmpty) {
      _tasks.addAll(SeedData.tasks());
    }
    _initialized = true;
  }

  Duration _latency() =>
      Duration(milliseconds: _latencyBase + _random.nextInt(300));

  Future<List<Task>> fetchForProject(
    String projectId, {
    bool includeArchived = false,
  }) async {
    await _init();
    await Future.delayed(_latency());
    final list =
        _tasks
            .where(
              (t) =>
                  t.projectId == projectId && (includeArchived || !t.archived),
            )
            .toList();
    return List.unmodifiable(list);
  }

  Future<Task> create(Task task) async {
    await _init();
    await Future.delayed(_latency());
    final trimmed = task.title.trim();
    if (trimmed.isEmpty) throw ArgumentError('Title required');
    if (_tasks.any(
      (t) =>
          t.projectId == task.projectId &&
          t.title.toLowerCase() == trimmed.toLowerCase(),
    )) {
      throw StateError('A task with same title exists in this project.');
    }
    final t = task.copyWith(
      id: 't_${DateTime.now().millisecondsSinceEpoch}',
      title: trimmed,
    );
    _tasks.add(t);
    return t;
  }

  Future<Task> update(Task task) async {
    await _init();
    await Future.delayed(_latency());
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    if (idx == -1) throw StateError('Task not found');
    if (_tasks.any(
      (t) =>
          t.id != task.id &&
          t.projectId == task.projectId &&
          t.title.toLowerCase() == task.title.toLowerCase(),
    )) {
      throw StateError('Another task with same title exists in this project.');
    }
    _tasks[idx] = task.copyWith(title: task.title.trim());
    return _tasks[idx];
  }

  Future<void> delete(String taskId) async {
    await _init();
    await Future.delayed(_latency());
    _tasks.removeWhere((t) => t.id == taskId);
  }

  Future<void> archive(String taskId) async {
    await _init();
    await Future.delayed(_latency());
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) throw StateError('Task not found');
    _tasks[idx] = _tasks[idx].copyWith(archived: !_tasks[idx].archived);
  }
}
