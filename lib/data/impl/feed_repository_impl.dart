import '../../domain/models/feed_post.dart';
import '../../domain/models/paged_result.dart';
import '../../domain/repository/feed_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/feed_post_dto.dart';

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<PagedResult<FeedPost>> listFeed({
    int limit = 20,
    String? cursor,
  }) async {
    final result = await _apiClient.get(
      path: ApiUrl.feed,
      queryParameters: {
        'limit': limit,
        ...?(cursor == null ? null : {'cursor': cursor}),
      },
      parser: (json) => PagedResult.fromJson(
        json,
        (item) => FeedPostDto.fromJson(item).toDomain(),
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
}
