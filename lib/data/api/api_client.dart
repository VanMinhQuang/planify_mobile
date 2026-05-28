import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../app/config.dart';
import '../services/secure_token_store.dart';

class ApiClient {
  ApiClient({required AppConfig config, SecureTokenStore? tokenStore, Dio? dio})
    : tokenStore = tokenStore ?? SecureTokenStore(),
      dio = dio ?? Dio() {
    this.dio.options = BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 40),
      sendTimeout: const Duration(seconds: 40),
      headers: {'Accept': 'application/json'},
    );
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await this.tokenStore.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: _extractMessage(error),
            ),
          );
        },
      ),
    );
  }

  final Dio dio;
  final SecureTokenStore tokenStore;

  Future<T> get<T>(
    String path, {
    required T Function(dynamic json) parser,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
    );
    return parser(_payload(response.data));
  }

  Future<T> post<T>(
    String path, {
    Object? data,
    required T Function(dynamic json) parser,
  }) async {
    final response = await dio.post<dynamic>(path, data: data);
    return parser(_payload(response.data));
  }

  Future<T> patch<T>(
    String path, {
    Object? data,
    required T Function(dynamic json) parser,
  }) async {
    final response = await dio.patch<dynamic>(path, data: data);
    return parser(_payload(response.data));
  }

  Future<void> delete(String path) async {
    await dio.delete<dynamic>(path);
  }

  dynamic _payload(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return data['data'];
    }
    return data;
  }

  static String _extractMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      final message = error.message;
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }
    if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }
    if (error is SocketException) {
      return 'No internet connection.';
    }
    return 'Something went wrong. Please try again.';
  }
}
