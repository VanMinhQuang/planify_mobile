import 'package:dio/dio.dart';

import 'abstract_network_client.dart';

abstract class RestApiClient extends AbstractNetworkClient {
  RestApiClient({required super.baseUrl});

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return executeRequest(
      () => dio.get(path, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Options? options,
  }) {
    return executeRequest(() => dio.post(path, data: data, options: options));
  }

  Future<Response<dynamic>> uploadFile({
    required String filePath,
    required String url,
    String fieldName = 'file',
  }) async {
    final fileName = filePath.split('/').last;

    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath, filename: fileName),
    });

    return executeRequest(
      () => dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "multipart/form-data",
          },
        ),
      ),
    );
  }

  Future<Response<dynamic>> put(String path, {dynamic data, Options? options}) {
    return executeRequest(() => dio.put(path, data: data, options: options));
  }

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Options? options,
  }) {
    return executeRequest(() => dio.patch(path, data: data, options: options));
  }

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Options? options,
  }) {
    return executeRequest(() => dio.delete(path, data: data, options: options));
  }
}
