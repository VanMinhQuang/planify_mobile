import '../network.dart';

class NetworkService extends RestApiClient with TokenManagementMixin {
  NetworkService({required super.baseUrl});

  @override
  Future<dynamic> refreshTokenCall() async {
    try {
      final response = await dio
          .post('/api/auth/refresh', data: {'refreshToken': refreshToken})
          .timeout(const Duration(seconds: 20));
      final data = response.data as Map<String, dynamic>;
      accessToken = data['accessToken'];
      refreshToken = data['refreshToken'];
      accessTokenExpired = DateTime.now().add(const Duration(hours: 1));
      await saveToken(accessToken, refreshToken, accessTokenExpired);

      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'accessTokenExpired': accessTokenExpired,
      };
    } catch (e) {
      //await deleteToken();
      rethrow;
      // Handle the case where refresh fails (e.g., redirect to login)
    }
  }
}

// Example usage
void main() async {
  final apiClient = NetworkService(baseUrl: 'https://api.example.com');
  try {
    final response = await apiClient.get('/users');
    print('Users: ${response.data}');
  } catch (e) {
    print('Error: $e');
  }
}
