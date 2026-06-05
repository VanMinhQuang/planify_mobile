import '../../domain/models/friend_search_result.dart';
import '../../domain/models/friendship.dart';
import 'app_user_dto.dart';
import 'friendship_dto.dart';

class FriendSearchResultDto {
  const FriendSearchResultDto({
    required this.user,
    this.friendship,
    this.friendshipStatus,
    this.isOutgoingRequest = false,
  });

  final AppUserDto user;
  final FriendshipDto? friendship;
  final FriendshipStatus? friendshipStatus;
  final bool isOutgoingRequest;

  factory FriendSearchResultDto.fromJson(Map<String, dynamic> json) {
    return FriendSearchResultDto(
      user: AppUserDto.fromJson(json['user'] as Map<String, dynamic>),
      friendship: json['friendship'] == null
          ? null
          : FriendshipDto.fromJson(json['friendship'] as Map<String, dynamic>),
      friendshipStatus: _statusFromApi(json['friendshipStatus'] as String?),
      isOutgoingRequest: json['isOutgoingRequest'] as bool? ?? false,
    );
  }

  FriendSearchResult toDomain() {
    return FriendSearchResult(
      user: user.toDomain(),
      friendship: friendship?.toDomain(),
      friendshipStatus: friendshipStatus,
      isOutgoingRequest: isOutgoingRequest,
    );
  }

  static FriendshipStatus? _statusFromApi(String? value) {
    if (value == null) return null;
    return FriendshipStatus.values.firstWhere(
      (status) => status.name.toUpperCase() == value,
      orElse: () => FriendshipStatus.pending,
    );
  }
}
