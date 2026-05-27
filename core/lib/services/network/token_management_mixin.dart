import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'abstract_network_client.dart';

mixin TokenManagementMixin on AbstractNetworkClient {
  String accessToken = '';
  String refreshToken = '';
  DateTime accessTokenExpired = DateTime.now();
  Completer<String?>? _refreshCompleter;
  final _storage = const FlutterSecureStorage();
  final String _storageKey = 'auth_token';

  @override
  Future<void> init() async {
    super.init();
    await getToken();
  }

  @override
  void applyAuthentication(RequestOptions options) {
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  @override
  Future<String?> onUnauthorized(RequestOptions requestOptions) async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }
    _refreshCompleter = Completer<String?>();
    try {
      final response = await refreshTokenCall();

      final newAccessToken = response['accessToken'];

      _refreshCompleter!.complete(newAccessToken);

      return newAccessToken;
    } catch (e) {
      _refreshCompleter!.completeError(e);
      return null;
    }
  }

  Future<void> saveToken(
    String accessToken,
    String refreshToken,
    DateTime accessTokenExpired,
  ) async {
    final tokenData = {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'accessTokenExpired': accessTokenExpired.millisecondsSinceEpoch,
    };

    await _storage.write(key: _storageKey, value: jsonEncode(tokenData));
    await init();
  }

  Future<void> getToken() async {
    String? storedToken = await _storage.read(key: _storageKey);
    if (storedToken != null) {
      final tokenJson = jsonDecode(storedToken) as Map<String, dynamic>;

      accessToken = tokenJson['accessToken'] ?? '';
      refreshToken = tokenJson['refreshToken'] ?? '';
      accessTokenExpired = DateTime.fromMillisecondsSinceEpoch(
        tokenJson['accessTokenExpired'] ??
            DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _storageKey);
    accessToken = '';
    refreshToken = '';
  }

  Future<dynamic> refreshTokenCall();

  bool isLoggedIn() {
    return accessToken.isNotEmpty &&
        DateTime.now().isBefore(accessTokenExpired);
  }
}
