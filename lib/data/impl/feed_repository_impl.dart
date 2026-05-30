import '../../domain/models/feed_post.dart';
import '../../domain/repository/feed_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/feed_post_dto.dart';

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<FeedPost>> listFeed() async {
    final result = await _apiClient.get(
      path: ApiUrl.feed,
      parser: (json) => (json as List<dynamic>)
          .map((item) => FeedPostDto.fromJson(item as Map<String, dynamic>))
          .map((item) => item.toDomain())
          .toList(),
    );
    return result ?? [];
  }
}
