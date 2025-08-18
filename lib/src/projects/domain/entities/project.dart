import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final bool archived;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.archived,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    bool? archived,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    archived: archived ?? this.archived,
  );

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    archived: json['archived'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'archived': archived,
  };

  @override
  List<Object?> get props => [id, name, description, archived];
}
