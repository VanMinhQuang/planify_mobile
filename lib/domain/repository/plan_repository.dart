import '../models/activity_entry.dart';
import '../models/paged_result.dart';
import '../models/plan.dart';
import '../models/plan_note.dart';
import '../models/plan_task.dart';

abstract interface class PlanRepository {
  Future<PagedResult<Plan>> listPlans({
    String? status,
    int limit = 20,
    String? cursor,
  });

  Future<Plan> createPlan(Plan plan);

  Future<Plan> getPlan(String planId);

  Future<PagedResult<PlanTask>> listTasks(
    String planId, {
    int limit = 20,
    String? cursor,
  });

  Future<PlanTask> createTask(
    String planId,
    String title, {
    String? description,
    String? locationName,
    double? locationLat,
    double? locationLng,
    DateTime? dueDate,
  });

  Future<PlanTask> updateTaskDone(String planId, String taskId, bool isDone);

  Future<PagedResult<PlanNote>> listNotes(
    String planId, {
    int limit = 20,
    String? cursor,
  });

  Future<PlanNote> createNote(String planId, String content);

  Future<PagedResult<ActivityEntry>> listActivity(
    String planId, {
    int limit = 20,
    String? cursor,
  });

  Future<Map<String, dynamic>> createInvite(String planId, {String? inviteeId});
}
