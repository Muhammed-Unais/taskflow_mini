part of 'report_bloc.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object?> get props => [];
}

class ReportLoadRequested extends ReportEvent {
  final bool includeArchived;
  const ReportLoadRequested({this.includeArchived = false});
  @override
  List<Object?> get props => [includeArchived];
}

class ReportRefreshRequested extends ReportEvent {
  const ReportRefreshRequested();
}
