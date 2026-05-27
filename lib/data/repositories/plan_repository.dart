import '../../domain/models/activity_entry.dart';
import '../../domain/models/plan.dart';
import '../../domain/models/plan_note.dart';
import '../../domain/models/plan_task.dart';
import '../api/api_client.dart';

class PlanRepository {
  PlanRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Plan>> listPlans({String? status}) async {
    final response = await _apiClient.dio.get<List<dynamic>>(
      '/plans',
      queryParameters: status == null ? null : {'status': status},
    );
    return response.data!
        .map((item) => Plan.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Plan> createPlan(Plan plan) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/plans',
      data: plan.toCreateJson(),
    );
    return Plan.fromJson(response.data!);
  }

  Future<Plan> getPlan(String planId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      '/plans/$planId',
    );
    return Plan.fromJson(response.data!);
  }

  Future<List<PlanTask>> listTasks(String planId) async {
    final response = await _apiClient.dio.get<List<dynamic>>(
      '/plans/$planId/tasks',
    );
    return response.data!
        .map((item) => PlanTask.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<PlanTask> createTask(String planId, String title) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/plans/$planId/tasks',
      data: {'title': title},
    );
    return PlanTask.fromJson(response.data!);
  }

  Future<PlanTask> updateTaskDone(
    String planId,
    String taskId,
    bool isDone,
  ) async {
    final response = await _apiClient.dio.patch<Map<String, dynamic>>(
      '/plans/$planId/tasks/$taskId',
      data: {'isDone': isDone},
    );
    return PlanTask.fromJson(response.data!);
  }

  Future<List<PlanNote>> listNotes(String planId) async {
    final response = await _apiClient.dio.get<List<dynamic>>(
      '/plans/$planId/notes',
    );
    return response.data!
        .map((item) => PlanNote.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<PlanNote> createNote(String planId, String content) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/plans/$planId/notes',
      data: {'content': content},
    );
    return PlanNote.fromJson(response.data!);
  }

  Future<List<ActivityEntry>> listActivity(String planId) async {
    final response = await _apiClient.dio.get<List<dynamic>>(
      '/plans/$planId/activity',
    );
    return response.data!
        .map((item) => ActivityEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> createInvite(String planId) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/plans/$planId/invites',
    );
    return response.data!;
  }
}
