import '../models/friendship.dart';

abstract interface class FriendRepository {
  Future<List<Friendship>> listFriends();

  Future<Friendship> createRequest(String addresseeId);

  Future<Friendship> acceptRequest(String requestId);

  Future<void> rejectRequest(String requestId);
}
