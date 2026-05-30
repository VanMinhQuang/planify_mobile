import 'package:equatable/equatable.dart';

import 'app_user.dart';
import 'friendship.dart';
import 'plan.dart';

class UserProfile extends Equatable {
  const UserProfile({required this.user, required this.plans, this.friendship});

  final AppUser user;
  final Friendship? friendship;
  final List<Plan> plans;

  @override
  List<Object?> get props => [user, friendship, plans];
}
