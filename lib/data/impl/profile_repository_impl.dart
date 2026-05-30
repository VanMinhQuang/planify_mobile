import '../../domain/models/app_user.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repository/profile_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/app_user_dto.dart';
import '../dto/user_profile_dto.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<AppUser>> searchUsers(String query) async {
    final result = await _apiClient.get(
      path: ApiUrl.usersSearch,
      queryParameters: {'q': query},
      parser: (json) => (json as List<dynamic>)
          .map((item) => AppUserDto.fromJson(item as Map<String, dynamic>))
          .map((item) => item.toDomain())
          .toList(),
    );
    return result ?? [];
  }

  @override
  Future<UserProfile> getProfile(String userId) async {
    final result = await _apiClient.get(
      path: ApiUrl.userProfile(userId),
      parser: (json) =>
          UserProfileDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
    if (result == null) {
      throw 'Could not load profile';
    }
    return result;
  }

  @override
  Future<AppUser> updateMe({String? name, String? avatarUrl}) async {
    final body = <String, dynamic>{};
    if (name != null) {
      body['name'] = name;
    }
    if (avatarUrl != null) {
      body['avatarUrl'] = avatarUrl;
    }
    final result = await _apiClient.patch(
      path: ApiUrl.me,
      body: body,
      parser: (json) =>
          AppUserDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
    if (result == null) {
      throw 'Could not update profile';
    }
    return result;
  }
}
