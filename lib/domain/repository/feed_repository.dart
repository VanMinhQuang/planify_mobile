import '../models/feed_post.dart';
import '../models/paged_result.dart';

abstract interface class FeedRepository {
  Future<PagedResult<FeedPost>> listFeed({int limit = 20, String? cursor});
}
