import '../../domain/models/activity_entry.dart';
import '../../domain/models/plan.dart';
import '../../domain/models/plan_note.dart';
import '../../domain/models/plan_task.dart';
import '../../domain/repository/plan_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/activity_entry_dto.dart';
import '../dto/plan_dto.dart';
import '../dto/plan_note_dto.dart';
import '../dto/plan_task_dto.dart';

class PlanRepositoryImpl implements PlanRepository {
  PlanRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<Plan>> listPlans({String? status}) {
    return _apiClient.get(
      ApiUrl.plans,
      queryParameters: status == null ? null : {'status': status},
      parser: (json) => _mapList(
        json,
        PlanDto.fromJson,
      ).map((item) => item.toDomain()).toList(),
    );
  }

  @override
  Future<Plan> createPlan(Plan plan) {
    return _apiClient.post(
      ApiUrl.plans,
      data: PlanDto.createBody(plan),
      parser: (json) =>
          PlanDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
  }

  @override
  Future<Plan> getPlan(String planId) {
    return _apiClient.get(
      ApiUrl.plan(planId),
      parser: (json) =>
          PlanDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
  }

  @override
  Future<List<PlanTask>> listTasks(String planId) {
    return _apiClient.get(
      ApiUrl.planTasks(planId),
      parser: (json) => _mapList(
        json,
        PlanTaskDto.fromJson,
      ).map((item) => item.toDomain()).toList(),
    );
  }

  @override
  Future<PlanTask> createTask(String planId, String title) {
    return _apiClient.post(
      ApiUrl.planTasks(planId),
      data: {'title': title},
      parser: (json) =>
          PlanTaskDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
  }

  @override
  Future<PlanTask> updateTaskDone(String planId, String taskId, bool isDone) {
    return _apiClient.patch(
      ApiUrl.planTask(planId, taskId),
      data: {'isDone': isDone},
      parser: (json) =>
          PlanTaskDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
  }

  @override
  Future<List<PlanNote>> listNotes(String planId) {
    return _apiClient.get(
      ApiUrl.planNotes(planId),
      parser: (json) => _mapList(
        json,
        PlanNoteDto.fromJson,
      ).map((item) => item.toDomain()).toList(),
    );
  }

  @override
  Future<PlanNote> createNote(String planId, String content) {
    return _apiClient.post(
      ApiUrl.planNotes(planId),
      data: {'content': content},
      parser: (json) =>
          PlanNoteDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
  }

  @override
  Future<List<ActivityEntry>> listActivity(String planId) {
    return _apiClient.get(
      ApiUrl.planActivity(planId),
      parser: (json) => _mapList(
        json,
        ActivityEntryDto.fromJson,
      ).map((item) => item.toDomain()).toList(),
    );
  }

  @override
  Future<Map<String, dynamic>> createInvite(String planId) {
    return _apiClient.post(
      ApiUrl.planInvites(planId),
      parser: (json) => json as Map<String, dynamic>,
    );
  }

  List<T> _mapList<T>(
    dynamic json,
    T Function(Map<String, dynamic> item) fromJson,
  ) {
    return (json as List<dynamic>)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
