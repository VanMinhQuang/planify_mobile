import 'package:equatable/equatable.dart';

import 'app_user.dart';
import 'friendship.dart';

class FriendSearchResult extends Equatable {
  const FriendSearchResult({
    required this.user,
    this.friendship,
    this.friendshipStatus,
    this.isOutgoingRequest = false,
  });

  final AppUser user;
  final Friendship? friendship;
  final FriendshipStatus? friendshipStatus;
  final bool isOutgoingRequest;

  bool get isFriend => friendshipStatus == FriendshipStatus.accepted;
  bool get isPending => friendshipStatus == FriendshipStatus.pending;
  bool get isIncomingRequest => isPending && !isOutgoingRequest;

  @override
  List<Object?> get props => [
    user,
    friendship,
    friendshipStatus,
    isOutgoingRequest,
  ];
}
