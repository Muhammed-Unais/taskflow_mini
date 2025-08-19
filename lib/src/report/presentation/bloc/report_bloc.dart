import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskflow_mini/src/report/domain/entities/project_report.dart';
import 'package:taskflow_mini/src/report/domain/repository/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repo;
  final String projectId;

  ReportBloc({required this.repo, required this.projectId})
    : super(const ReportState.initial()) {
    on<ReportLoadRequested>(_onLoad);
    on<ReportRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
    ReportLoadRequested event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(status: ReportStatus.loading, error: null));
    try {
      final report = await repo.projectStatus(
        projectId,
        includeArchived: event.includeArchived,
      );
      if (report.total == 0) {
        emit(state.copyWith(status: ReportStatus.empty, report: report));
      } else {
        emit(state.copyWith(status: ReportStatus.ready, report: report));
      }
    } catch (e) {
      emit(state.copyWith(status: ReportStatus.error, error: e.toString()));
    }
  }

  Future<void> _onRefresh(
    ReportRefreshRequested event,
    Emitter<ReportState> emit,
  ) async {
    add(ReportLoadRequested(includeArchived: state.includeArchived));
  }
}
