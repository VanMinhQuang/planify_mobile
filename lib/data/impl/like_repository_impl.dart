import '../../domain/repository/like_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';

class LikeRepositoryImpl implements LikeRepository {
  LikeRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> getSummary(String planId) async {
    final result = await _apiClient.get(
      path: ApiUrl.planLikes(planId),
      parser: (json) => json as Map<String, dynamic>,
    );
    return result ?? {};
  }

  @override
  Future<Map<String, dynamic>> likePlan(String planId) async {
    final result = await _apiClient.post(
      path: ApiUrl.planLikes(planId),
      body: {},
      parser: (json) => json as Map<String, dynamic>,
    );
    return result ?? {};
  }

  @override
  Future<Map<String, dynamic>> unlikePlan(String planId) async {
    final result = await _apiClient.delete(
      path: ApiUrl.planLikes(planId),
      parser: (json) => json as Map<String, dynamic>,
    );
    return result ?? {};
  }
}
