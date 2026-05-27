import 'dart:async';

import 'package:dio/dio.dart';

abstract class AbstractNetworkClient {
  final Dio dio;
  final CancelToken cancelToken = CancelToken();
  final BaseOptions baseOptions;
  final String baseUrl;

  AbstractNetworkClient({
    required this.baseUrl,
    Dio? dioInstance,
    BaseOptions? baseOption,
  }) : baseOptions = baseOption ?? BaseOptions(),
       dio = dioInstance ?? Dio() {
    dio.options = baseOptions;
    dio.options.baseUrl = baseUrl;
    init();
  }

  Future<void> init() async {
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.cancelToken = cancelToken;
          applyAuthentication(options);
          handler.next(options);
        },
        onError: (error, handler) async {
          if (shouldHandleUnauthorized(error.response?.statusCode)) {
            try {
              final newToken = await onUnauthorized(error.requestOptions);
              if (newToken == null) throw Exception();

              final requestOptions = error.requestOptions;
              requestOptions.headers['Authorization'] = 'Bearer $newToken';

              final response = await dio.fetch(requestOptions);

              return handler.resolve(response);
            } catch (e) {
              return handler.reject(error);
            }
          }
          handler.next(error);
        },
      ),
    ]);
  }

  void applyAuthentication(RequestOptions options);
  Future<String?> onUnauthorized(RequestOptions requestOptions);

  static bool shouldHandleUnauthorized(int? code) {
    return code == 401 || code == 403 || code == 419 || code == 498;
  }

  Future<Response<dynamic>> executeRequest(
    Future<Response<dynamic>> Function() requestFunction,
  ) async {
    try {
      return await requestFunction();
    } on DioException catch (e) {
      rethrow; // Re-throw to propagate the error up the call stack
    }
  }

  void cancelAllRequests() {
    cancelToken.cancel();
  }
}
