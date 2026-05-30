import '../models/app_user.dart';
import '../models/user_profile.dart';

abstract interface class ProfileRepository {
  Future<List<AppUser>> searchUsers(String query);

  Future<UserProfile> getProfile(String userId);

  Future<AppUser> updateMe({String? name, String? avatarUrl});
}
