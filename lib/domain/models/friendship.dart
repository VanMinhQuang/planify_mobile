import 'package:equatable/equatable.dart';

import 'app_user.dart';

enum FriendshipStatus { pending, accepted, blocked }

class Friendship extends Equatable {
  const Friendship({
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
  final AppUser? requester;
  final AppUser? addressee;

  @override
  List<Object?> get props => [
    id,
    requesterId,
    addresseeId,
    status,
    requester,
    addressee,
  ];
}
