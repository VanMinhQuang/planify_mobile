import '../models/activity_entry.dart';
import '../models/paged_result.dart';
import '../models/plan.dart';
import '../models/plan_note.dart';
import '../models/plan_task.dart';
import '../models/requests/requests.dart';

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

  Future<PlanTask> createTask(String planId, CreateTaskRequest request);

  Future<PlanTask> updateTask(
    String planId,
    String taskId,
    UpdateTaskRequest request,
  );

  Future<PagedResult<PlanNote>> listNotes(
    String planId, {
    NoteFilterRequest filters = const NoteFilterRequest(),
    int limit = 20,
    String? cursor,
  });

  Future<PlanNote> createNote(String planId, CreateNoteRequest request);

  Future<PagedResult<ActivityEntry>> listActivity(
    String planId, {
    ActivityFilterRequest filters = const ActivityFilterRequest(),
    int limit = 20,
    String? cursor,
  });

  Future<Map<String, dynamic>> createInvite(
    String planId,
    CreateInviteRequest request,
  );
}
