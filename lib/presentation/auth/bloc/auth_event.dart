part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthLoad extends AuthEvent {}

class AuthSwitchUser extends AuthEvent {
  final String userId;
  const AuthSwitchUser(this.userId);
  @override
  List<Object?> get props => [userId];
}
