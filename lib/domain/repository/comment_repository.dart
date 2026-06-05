import '../models/paged_result.dart';
import '../models/plan_comment.dart';
import '../models/requests/create_comment_request.dart';

abstract interface class CommentRepository {
  Future<PagedResult<PlanComment>> listComments(
    String planId, {
    int limit = 20,
    String? cursor,
  });

  Future<PlanComment> createComment(
    String planId,
    CreateCommentRequest request,
  );

  Future<void> deleteComment(String planId, String commentId);

  Future<Map<String, dynamic>> likeComment(String planId, String commentId);

  Future<Map<String, dynamic>> unlikeComment(String planId, String commentId);
}
