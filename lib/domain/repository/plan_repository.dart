import '../models/activity_entry.dart';
import '../models/plan.dart';
import '../models/plan_note.dart';
import '../models/plan_task.dart';

abstract interface class PlanRepository {
  Future<List<Plan>> listPlans({String? status});

  Future<Plan> createPlan(Plan plan);

  Future<Plan> getPlan(String planId);

  Future<List<PlanTask>> listTasks(String planId);

  Future<PlanTask> createTask(String planId, String title);

  Future<PlanTask> updateTaskDone(String planId, String taskId, bool isDone);

  Future<List<PlanNote>> listNotes(String planId);

  Future<PlanNote> createNote(String planId, String content);

  Future<List<ActivityEntry>> listActivity(String planId);

  Future<Map<String, dynamic>> createInvite(String planId);
}
