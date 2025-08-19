part of 'report_bloc.dart';

enum ReportStatus { initial, loading, ready, empty, error }

class ReportState extends Equatable {
  final ReportStatus status;
  final ProjectReport? report;
  final bool includeArchived;
  final String? error;

  const ReportState({
    required this.status,
    required this.report,
    required this.includeArchived,
    required this.error,
  });

  const ReportState.initial()
    : status = ReportStatus.initial,
      report = null,
      includeArchived = false,
      error = null;

  ReportState copyWith({
    ReportStatus? status,
    ProjectReport? report,
    bool? includeArchived,
    String? error,
  }) {
    return ReportState(
      status: status ?? this.status,
      report: report ?? this.report,
      includeArchived: includeArchived ?? this.includeArchived,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, report, includeArchived, error];
}
