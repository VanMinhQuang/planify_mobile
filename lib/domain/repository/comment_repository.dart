import '../models/paged_result.dart';
import '../models/plan_comment.dart';

abstract interface class CommentRepository {
  Future<PagedResult<PlanComment>> listComments(
    String planId, {
    int limit = 20,
    String? cursor,
  });

  Future<PlanComment> createComment(
    String planId,
    String content, {
    String? parentCommentId,
  });

  Future<void> deleteComment(String planId, String commentId);

  Future<Map<String, dynamic>> likeComment(String planId, String commentId);

  Future<Map<String, dynamic>> unlikeComment(String planId, String commentId);
}
