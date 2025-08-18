import 'package:taskflow_mini/domain/entities/user.dart';
import 'package:taskflow_mini/data/datasources/user_local_data_source.dart';
import 'package:taskflow_mini/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserLocalDataSource local;
  AuthRepositoryImpl(this.local);

  @override
  Future<List<User>> getAllUsers() {
    return local.getAllUsers();
  }

  @override
  Future<User> getCurrentUser() {
    return local.getCurrentUser();
  }

  @override
  Future<void> switchUser(String userId) {
    return local.switchUser(userId);
  }
}
