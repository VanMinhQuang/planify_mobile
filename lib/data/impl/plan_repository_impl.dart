import '../../domain/models/activity_entry.dart';
import '../../domain/models/paged_result.dart';
import '../../domain/models/plan.dart';
import '../../domain/models/plan_note.dart';
import '../../domain/models/plan_task.dart';
import '../../domain/models/requests/requests.dart';
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
  Future<PagedResult<Plan>> listPlans({
    String? status,
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.plans,
        queryParameters: {
          ...?(status == null ? null : {'status': status}),
          'limit': limit,
          ...?(cursor == null ? null : {'cursor': cursor}),
        },
        parser: (json) =>
            _mapPage(json, PlanDto.fromJson, (item) => item.toDomain()),
      );
      return result ??
          const PagedResult(
            items: [],
            nextCursor: null,
            hasNextPage: false,
            totalCount: 0,
          );
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
  Future<PagedResult<PlanTask>> listTasks(
    String planId, {
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.planTasks(planId),
        queryParameters: {
          'limit': limit,
          ...?(cursor == null ? null : {'cursor': cursor}),
        },
        parser: (json) =>
            _mapPage(json, PlanTaskDto.fromJson, (item) => item.toDomain()),
      );
      return result ??
          const PagedResult(
            items: [],
            nextCursor: null,
            hasNextPage: false,
            totalCount: 0,
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlanTask> createTask(String planId, CreateTaskRequest request) async {
    try {
      final result = await _apiClient.post(
        path: ApiUrl.planTasks(planId),
        body: request.toJson(),
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
  Future<PlanTask> updateTask(
    String planId,
    String taskId,
    UpdateTaskRequest request,
  ) async {
    try {
      final result = await _apiClient.patch(
        path: ApiUrl.planTask(planId, taskId),
        body: request.toJson(),
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
  Future<PagedResult<PlanNote>> listNotes(
    String planId, {
    NoteFilterRequest filters = const NoteFilterRequest(),
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.planNotes(planId),
        queryParameters: {
          'limit': limit,
          ...filters.toQueryParameters(),
          ...?(cursor == null ? null : {'cursor': cursor}),
        },
        parser: (json) =>
            _mapPage(json, PlanNoteDto.fromJson, (item) => item.toDomain()),
      );
      return result ??
          const PagedResult(
            items: [],
            nextCursor: null,
            hasNextPage: false,
            totalCount: 0,
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlanNote> createNote(String planId, CreateNoteRequest request) async {
    try {
      final result = await _apiClient.post(
        path: ApiUrl.planNotes(planId),
        body: request.toJson(),
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
  Future<PagedResult<ActivityEntry>> listActivity(
    String planId, {
    ActivityFilterRequest filters = const ActivityFilterRequest(),
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.planActivity(planId),
        queryParameters: {
          'limit': limit,
          ...filters.toQueryParameters(),
          ...?(cursor == null ? null : {'cursor': cursor}),
        },
        parser: (json) => _mapPage(
          json,
          ActivityEntryDto.fromJson,
          (item) => item.toDomain(),
        ),
      );
      return result ??
          const PagedResult(
            items: [],
            nextCursor: null,
            hasNextPage: false,
            totalCount: 0,
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createInvite(
    String planId,
    CreateInviteRequest request,
  ) async {
    try {
      final result = await _apiClient.post(
        path: ApiUrl.planInvites(planId),
        body: request.toJson(),
        parser: (json) => json as Map<String, dynamic>,
      );
      return result ?? {};
    } catch (e) {
      rethrow;
    }
  }

  PagedResult<R> _mapPage<T, R>(
    dynamic json,
    T Function(Map<String, dynamic> item) fromJson,
    R Function(T item) toDomain,
  ) {
    return PagedResult.fromJson(json, (item) => toDomain(fromJson(item)));
  }
}
