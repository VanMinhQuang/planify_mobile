import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:planify_mobile/data/dto/app_user_dto.dart';

import 'auth_session.dart';

class ApiClient {
  final NetworkService _service;

  ApiClient(this._service);

  Future<T?> get<T>({
    required String path,
    required T Function(dynamic json) parser,
    Map<String, dynamic>? queryParameters,
    Duration timeout = const Duration(minutes: 1),
  }) async {
    try {
      final res = await _service
          .get(path, queryParameters: queryParameters)
          .timeout(timeout);

      return _handleResponse(res, parser);
    } catch (e) {
      throw _extractMessage(e);
    }
  }

  Future<T?> post<T>({
    required String path,
    required dynamic body,
    required T Function(dynamic json) parser,
    bool extractMessage = false,
    Duration timeout = const Duration(minutes: 1),
  }) async {
    try {
      print(jsonEncode(body));
      final res = await _service.post(path, data: body).timeout(timeout);

      if (extractMessage) {
        final data = res.data;
        if (data['success'] == false) {
          throw _extractMessage(data);
        }
        return parser(data['message']);
      }
      return _handleResponse(res, parser);
    } catch (e) {
      throw _extractMessage(e);
    }
  }

  Future<T?> put<T>({
    required String path,
    required dynamic body,
    required T Function(dynamic json) parser,
    Duration timeout = const Duration(minutes: 1),
  }) async {
    try {
      final res = await _service.put(path, data: body).timeout(timeout);

      return _handleResponse(res, parser);
    } catch (e) {
      throw _extractMessage(e);
    }
  }

  Future<T?> patch<T>({
    required String path,
    required dynamic body,
    required T Function(dynamic json) parser,
    Duration timeout = const Duration(minutes: 1),
  }) async {
    try {
      final res = await _service.patch(path, data: body).timeout(timeout);

      return _handleResponse(res, parser);
    } catch (e) {
      throw _extractMessage(e);
    }
  }

  Future<T?> delete<T>({
    required String path,
    T Function(dynamic json)? parser,
    Duration timeout = const Duration(minutes: 1),
  }) async {
    try {
      final res = await _service.delete(path).timeout(timeout);

      final data = res.data;

      if (parser != null) {
        return parser(data);
      }

      return data as T?;
    } catch (e) {
      throw _extractMessage(e);
    }
  }

  Future<T?> uploadFile<T>({
    required String path,
    required String filePath,
    String fieldName = 'file',
    Map<String, dynamic> fields = const {},
    Duration timeout = const Duration(seconds: 60),
  }) async {
    try {
      final res = await _service
          .uploadFile(
            filePath: filePath,
            url: path,
            fieldName: fieldName,
            fields: fields,
          )
          .timeout(timeout);

      final data = res.data;

      if (data['success'] == false) {
        throw _extractMessage(data);
      }

      return data as T?;
    } catch (e) {
      throw _extractMessage(e);
    }
  }

  Future<T?> uploadFiles<T>({
    required String path,
    required List<String> filePaths,
    String fieldName = 'files',
    Map<String, dynamic> fields = const {},
    Duration timeout = const Duration(seconds: 120),
  }) async {
    try {
      final res = await _service
          .uploadFiles(
            filePaths: filePaths,
            url: path,
            fieldName: fieldName,
            fields: fields,
          )
          .timeout(timeout);

      final data = res.data;

      if (data['success'] == false) {
        throw _extractMessage(data);
      }

      return data as T?;
    } catch (e) {
      throw _extractMessage(e);
    }
  }

  Future<AuthSession> authenticate<t>({
    required String path,
    required dynamic body,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    await _service.deleteToken();
    try {
      final res = await _service.post(path, data: body).timeout(timeout);

      final data = res.data;

      await _service.saveToken(
        data['accessToken'],
        data['refreshToken'],
        DateTime.now(),
      );

      return AuthSession(
        user: AppUserDto.fromJson(data['user']).toDomain(),
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );
    } catch (e) {
      throw _extractMessage(e);
    }
  }

  Future<void> clearToken() async {
    await _service.deleteToken();
  }

  T? _handleResponse<T>(Response res, T Function(dynamic json) parser) {
    final statusCode = res.statusCode;
    final data = res.data;

    if (statusCode == null || statusCode < 200 || statusCode >= 300) {
      throw _extractMessage(data);
    }

    return parser(data);
  }

  String _extractMessage(dynamic data) {
    if (data is DioException) {
      final response = data.response?.data;

      if (response is Map) {
        final message = response['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
    }
    if (data is TimeoutException) {
      return LocaleKeys.api_timeout.tr();
    }
    if (data is SocketException) {
      return LocaleKeys.api_no_internet.tr();
    }

    return LocaleKeys.api_error.tr();
  }
}
