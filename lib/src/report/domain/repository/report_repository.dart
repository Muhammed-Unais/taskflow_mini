import 'package:taskflow_mini/src/report/domain/entities/project_report.dart';

abstract class ReportRepository {
  Future<ProjectReport> projectStatus(
    String projectId, {
    bool includeArchived = false,
  });
}
