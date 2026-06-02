import '../../domain/models/paged_result.dart';
import '../../domain/models/plan_comment.dart';
import '../../domain/repository/comment_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/plan_comment_dto.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<PagedResult<PlanComment>> listComments(
    String planId, {
    int limit = 20,
    String? cursor,
  }) async {
    final result = await _apiClient.get(
      path: ApiUrl.planComments(planId),
      queryParameters: {
        'limit': limit,
        ...?(cursor == null ? null : {'cursor': cursor}),
      },
      parser: (json) => PagedResult.fromJson(
        json,
        (item) => PlanCommentDto.fromJson(item).toDomain(),
      ),
    );
    return result ??
        const PagedResult(
          items: [],
          nextCursor: null,
          hasNextPage: false,
          totalCount: 0,
        );
  }

  @override
  Future<PlanComment> createComment(
    String planId,
    String content, {
    String? parentCommentId,
  }) async {
    final body = <String, dynamic>{'content': content};
    if (parentCommentId != null) {
      body['parentCommentId'] = parentCommentId;
    }
    final result = await _apiClient.post(
      path: ApiUrl.planComments(planId),
      body: body,
      parser: (json) =>
          PlanCommentDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
    if (result == null) {
      throw 'Could not create comment';
    }
    return result;
  }

  @override
  Future<void> deleteComment(String planId, String commentId) async {
    await _apiClient.delete(path: ApiUrl.planComment(planId, commentId));
  }

  @override
  Future<Map<String, dynamic>> likeComment(
    String planId,
    String commentId,
  ) async {
    final result = await _apiClient.post(
      path: ApiUrl.planCommentLikes(planId, commentId),
      body: {},
      parser: (json) => json as Map<String, dynamic>,
    );
    return result ?? {};
  }

  @override
  Future<Map<String, dynamic>> unlikeComment(
    String planId,
    String commentId,
  ) async {
    final result = await _apiClient.delete(
      path: ApiUrl.planCommentLikes(planId, commentId),
      parser: (json) => json as Map<String, dynamic>,
    );
    return result ?? {};
  }
}
