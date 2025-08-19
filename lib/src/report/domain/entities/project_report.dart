import 'package:equatable/equatable.dart';

class ProjectReport extends Equatable {
  final int total;
  final Map<String, int> countsByStatus;
  final int overdue;
  final double completionPercent;
  final Map<String, int> openByAssignee;

  const ProjectReport({
    required this.total,
    required this.countsByStatus,
    required this.overdue,
    required this.completionPercent,
    required this.openByAssignee,
  });

  factory ProjectReport.empty() => const ProjectReport(
    total: 0,
    countsByStatus: {},
    overdue: 0,
    completionPercent: 0.0,
    openByAssignee: {},
  );

  ProjectReport copyWith({
    int? total,
    Map<String, int>? countsByStatus,
    int? overdue,
    double? completionPercent,
    Map<String, int>? openByAssignee,
  }) {
    return ProjectReport(
      total: total ?? this.total,
      countsByStatus: countsByStatus ?? this.countsByStatus,
      overdue: overdue ?? this.overdue,
      completionPercent: completionPercent ?? this.completionPercent,
      openByAssignee: openByAssignee ?? this.openByAssignee,
    );
  }

  @override
  List<Object?> get props => [
    total,
    countsByStatus,
    overdue,
    completionPercent,
    openByAssignee,
  ];
}
