import 'package:taskflow_mini/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> getCurrentUser();

  Future<void> switchUser(String userId);

  Future<List<User>> getAllUsers();
}
