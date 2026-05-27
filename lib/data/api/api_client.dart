import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../services/secure_token_store.dart';

class ApiClient {
  ApiClient({Dio? dio, SecureTokenStore? tokenStore})
    : tokenStore = tokenStore ?? SecureTokenStore(),
      dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
            ),
          ) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await this.tokenStore.readAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;
  final SecureTokenStore tokenStore;
}
