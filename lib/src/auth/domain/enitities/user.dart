import 'package:equatable/equatable.dart';

enum Role { admin, staff }

class User extends Equatable {
  final String id;
  final String name;
  final Role role;

  const User({required this.id, required this.name, required this.role});

  @override
  List<Object?> get props => [id, name, role];

  User copyWith({String? id, String? name, Role? role}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }
}
