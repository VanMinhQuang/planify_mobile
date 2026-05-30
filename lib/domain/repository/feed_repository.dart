import '../models/feed_post.dart';

abstract interface class FeedRepository {
  Future<List<FeedPost>> listFeed();
}
