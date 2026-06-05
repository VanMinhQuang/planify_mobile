import '../models/friendship.dart';
import '../models/friend_search_result.dart';

abstract interface class FriendRepository {
  Future<List<Friendship>> listFriends();

  Future<List<FriendSearchResult>> searchFriends(String query);

  Future<Friendship> createRequest(String addresseeId);

  Future<Friendship> acceptRequest(String requestId);

  Future<void> rejectRequest(String requestId);

  Future<void> removeFriend(String userId);
}
