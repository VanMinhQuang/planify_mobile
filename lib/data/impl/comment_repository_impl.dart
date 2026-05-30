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
  Future<List<PlanComment>> listComments(String planId) async {
    final result = await _apiClient.get(
      path: ApiUrl.planComments(planId),
      parser: (json) => (json as List<dynamic>)
          .map((item) => PlanCommentDto.fromJson(item as Map<String, dynamic>))
          .map((item) => item.toDomain())
          .toList(),
    );
    return result ?? [];
  }

  @override
  Future<PlanComment> createComment(String planId, String content) async {
    final result = await _apiClient.post(
      path: ApiUrl.planComments(planId),
      body: {'content': content},
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
}
