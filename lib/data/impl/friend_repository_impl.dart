import '../../domain/models/friendship.dart';
import '../../domain/repository/friend_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/friendship_dto.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<Friendship>> listFriends() async {
    final result = await _apiClient.get(
      path: ApiUrl.friends,
      parser: (json) => (json as List<dynamic>)
          .map((item) => FriendshipDto.fromJson(item as Map<String, dynamic>))
          .map((item) => item.toDomain())
          .toList(),
    );
    return result ?? [];
  }

  @override
  Future<Friendship> createRequest(String addresseeId) async {
    final result = await _apiClient.post(
      path: ApiUrl.friendRequests,
      body: {'addresseeId': addresseeId},
      parser: (json) =>
          FriendshipDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
    if (result == null) {
      throw 'Could not create friend request';
    }
    return result;
  }

  @override
  Future<Friendship> acceptRequest(String requestId) async {
    final result = await _apiClient.patch(
      path: ApiUrl.acceptFriendRequest(requestId),
      body: {},
      parser: (json) =>
          FriendshipDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
    if (result == null) {
      throw 'Could not accept friend request';
    }
    return result;
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    await _apiClient.patch(
      path: ApiUrl.rejectFriendRequest(requestId),
      body: {},
      parser: (_) => null,
    );
  }
}
