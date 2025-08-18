import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskflow_mini/domain/entities/user.dart';
import 'package:taskflow_mini/domain/repositories/auth_repositories.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoad>(_onLoad);
    on<AuthSwitchUser>(_onSwitch);
  }

  Future<void> _onLoad(AuthLoad _, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getCurrentUser();
      final users = await authRepository.getAllUsers();
      emit(AuthLoaded(user: user, allUsers: users));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSwitch(AuthSwitchUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.switchUser(event.userId);
      final user = await authRepository.getCurrentUser();
      final users = await authRepository.getAllUsers();
      emit(AuthLoaded(user: user, allUsers: users));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
