abstract interface class LikeRepository {
  Future<Map<String, dynamic>> getSummary(String planId);

  Future<Map<String, dynamic>> likePlan(String planId);

  Future<Map<String, dynamic>> unlikePlan(String planId);
}
