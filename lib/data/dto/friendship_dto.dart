import '../../domain/models/friendship.dart';
import 'app_user_dto.dart';

class FriendshipDto {
  const FriendshipDto({
    required this.id,
    required this.requesterId,
    required this.addresseeId,
    required this.status,
    this.requester,
    this.addressee,
  });

  final String id;
  final String requesterId;
  final String addresseeId;
  final FriendshipStatus status;
  final AppUserDto? requester;
  final AppUserDto? addressee;

  factory FriendshipDto.fromJson(Map<String, dynamic> json) {
    return FriendshipDto(
      id: json['id'] as String,
      requesterId:
          json['requesterId'] as String? ??
          json['requester_id'] as String? ??
          '',
      addresseeId:
          json['addresseeId'] as String? ??
          json['addressee_id'] as String? ??
          '',
      status: _statusFromApi(json['status'] as String?),
      requester: json['requester'] == null
          ? null
          : AppUserDto.fromJson(json['requester'] as Map<String, dynamic>),
      addressee: json['addressee'] == null
          ? null
          : AppUserDto.fromJson(json['addressee'] as Map<String, dynamic>),
    );
  }

  Friendship toDomain() {
    return Friendship(
      id: id,
      requesterId: requesterId,
      addresseeId: addresseeId,
      status: status,
      requester: requester?.toDomain(),
      addressee: addressee?.toDomain(),
    );
  }

  static FriendshipStatus _statusFromApi(String? value) {
    return FriendshipStatus.values.firstWhere(
      (status) => status.name.toUpperCase() == value,
      orElse: () => FriendshipStatus.pending,
    );
  }
}
