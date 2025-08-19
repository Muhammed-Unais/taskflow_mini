import 'dart:math';
import 'package:taskflow_mini/src/tasks/domain/entities/sub_task.dart';

class SubtaskLocalDataSource {
  final _random = Random();
  final _latencyBase = 520;
  final List<Subtask> _store = [];

  Duration _latency() =>
      Duration(milliseconds: _latencyBase + _random.nextInt(300));

  Future<void> _init() async {
    await Future.delayed(Duration.zero);
  }

  Future<List<Subtask>> fetchForTask(
    String taskId, {
    bool includeArchived = false,
  }) async {
    await _init();
    await Future.delayed(_latency());
    final list =
        _store
            .where(
              (s) => s.taskId == taskId && (includeArchived || !s.archived),
            )
            .toList();
    return List.unmodifiable(list);
  }

  Future<Subtask> create(Subtask subtask) async {
    await _init();
    await Future.delayed(_latency());
    final title = subtask.title.trim();
    if (title.isEmpty) throw ArgumentError('Title required');
    if (_store.any(
      (s) =>
          s.taskId == subtask.taskId &&
          s.title.toLowerCase() == title.toLowerCase(),
    )) {
      throw StateError('A subtask with same title exists for this task.');
    }
    final s = subtask.copyWith(
      id: 'st_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
    );
    _store.add(s);
    return s;
  }

  Future<Subtask> update(Subtask subtask) async {
    await _init();
    await Future.delayed(_latency());
    final idx = _store.indexWhere((s) => s.id == subtask.id);
    if (idx == -1) throw StateError('Subtask not found');
    if (_store.any(
      (s) =>
          s.id != subtask.id &&
          s.taskId == subtask.taskId &&
          s.title.toLowerCase() == subtask.title.toLowerCase(),
    )) {
      throw StateError('Another subtask with same title exists for this task.');
    }
    _store[idx] = subtask.copyWith(title: subtask.title.trim());
    return _store[idx];
  }

  Future<void> delete(String id) async {
    await _init();
    await Future.delayed(_latency());
    _store.removeWhere((s) => s.id == id);
  }

  Future<void> archive(String id) async {
    await _init();
    await Future.delayed(_latency());
    final idx = _store.indexWhere((s) => s.id == id);
    if (idx == -1) throw StateError('Subtask not found');
    _store[idx] = _store[idx].copyWith(archived: true);
  }

  Future<void> deleteByTaskId(String taskId) async {
    await _init();
    await Future.delayed(_latency());
    _store.removeWhere((s) => s.taskId == taskId);
  }
}
