import 'package:taskflow_mini/src/auth/domain/enitities/user.dart';

abstract class AuthRepository {
  Future<User> getCurrentUser();

  Future<void> switchUser(String userId);

  Future<List<User>> getAllUsers();
}
