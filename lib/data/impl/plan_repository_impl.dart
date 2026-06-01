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
  Future<List<Plan>> listPlans({String? status}) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.plans,
        queryParameters: status == null ? null : {'status': status},
        parser: (json) => _mapList(
          json,
          PlanDto.fromJson,
        ).map((item) => item.toDomain()).toList(),
      );
      return result ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Plan> createPlan(Plan plan) async {
    try {
      final result = await _apiClient.post(
        path: ApiUrl.plans,
        body: PlanDto.createBody(plan),
        parser: (json) =>
            PlanDto.fromJson(json as Map<String, dynamic>).toDomain(),
      );

      if (result == null) {
        throw 'Lỗi khi tạo dữ liệu';
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Plan> getPlan(String planId) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.plan(planId),
        parser: (json) =>
            PlanDto.fromJson(json as Map<String, dynamic>).toDomain(),
      );

      if (result == null) {
        throw 'Lỗi khi lấy dữ liệu';
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlanTask>> listTasks(String planId) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.planTasks(planId),
        parser: (json) => _mapList(
          json,
          PlanTaskDto.fromJson,
        ).map((item) => item.toDomain()).toList(),
      );
      return result ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlanTask> createTask(String planId, String title) async {
    try {
      final result = await _apiClient.post(
        path: ApiUrl.planTasks(planId),
        body: {'title': title},
        parser: (json) =>
            PlanTaskDto.fromJson(json as Map<String, dynamic>).toDomain(),
      );

      if (result == null) {
        throw 'Lỗi khi tạo dữ liệu';
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlanTask> updateTaskDone(
    String planId,
    String taskId,
    bool isDone,
  ) async {
    try {
      final result = await _apiClient.patch(
        path: ApiUrl.planTask(planId, taskId),
        body: {'isDone': isDone},
        parser: (json) =>
            PlanTaskDto.fromJson(json as Map<String, dynamic>).toDomain(),
      );

      if (result == null) {
        throw 'Lỗi khi cập nhật dữ liệu';
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlanNote>> listNotes(String planId) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.planNotes(planId),
        parser: (json) => _mapList(
          json,
          PlanNoteDto.fromJson,
        ).map((item) => item.toDomain()).toList(),
      );
      return result ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlanNote> createNote(String planId, String content) async {
    try {
      final result = await _apiClient.post(
        path: ApiUrl.planNotes(planId),
        body: {'content': content},
        parser: (json) =>
            PlanNoteDto.fromJson(json as Map<String, dynamic>).toDomain(),
      );

      if (result == null) {
        throw 'Lỗi khi tạo dữ liệu';
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ActivityEntry>> listActivity(String planId) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.planActivity(planId),
        parser: (json) => _mapList(
          json,
          ActivityEntryDto.fromJson,
        ).map((item) => item.toDomain()).toList(),
      );
      return result ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createInvite(
    String planId, {
    String? inviteeId,
  }) async {
    try {
      final result = await _apiClient.post(
        path: ApiUrl.planInvites(planId),
        body: inviteeId == null ? {} : {'inviteeId': inviteeId},
        parser: (json) => json as Map<String, dynamic>,
      );
      return result ?? {};
    } catch (e) {
      rethrow;
    }
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
