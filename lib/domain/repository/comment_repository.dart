import '../models/plan_comment.dart';

abstract interface class CommentRepository {
  Future<List<PlanComment>> listComments(String planId);

  Future<PlanComment> createComment(String planId, String content);

  Future<void> deleteComment(String planId, String commentId);
}
