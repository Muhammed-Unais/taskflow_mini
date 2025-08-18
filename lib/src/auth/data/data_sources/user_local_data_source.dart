import 'dart:async';
import 'dart:math';
import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';

class UserLocalDataSource {
  final _latency = Duration(milliseconds: 550 + Random().nextInt(250));
  final List<User> _seeded = const [
    User(id: 'u_admin', name: 'Alice (Admin)', role: Role.admin),
    User(id: 'u_staff1', name: 'Bob (Staff)', role: Role.staff),
    User(id: 'u_staff2', name: 'Carol (Staff)', role: Role.staff),
  ];

  String _currentUserId = 'u_admin';

  Future<T> _withDelay<T>(T Function() cb) async {
    await Future.delayed(_latency);
    return cb();
  }

  Future<User> getCurrentUser() => _withDelay(() {
    return _seeded.firstWhere((u) => u.id == _currentUserId);
  });

  Future<void> switchUser(String userId) => _withDelay(() {
    final exists = _seeded.any((u) => u.id == userId);
    if (!exists) throw Exception('User not found');
    _currentUserId = userId;
  });

  Future<List<User>> getAllUsers() => _withDelay(() => List.of(_seeded));
}
