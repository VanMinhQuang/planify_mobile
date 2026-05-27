import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../domain/models/plan.dart';
import '../api/api_client.dart';

class UploadRepository {
  UploadRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<String> uploadPlanCover({
    required String planId,
    required File file,
  }) async {
    if (AppConfig.uploadMode == 'iis') {
      return _uploadMultipart('/uploads/iis', planId, file);
    }

    if (AppConfig.uploadMode == 'r2') {
      return _uploadMultipart('/uploads/r2', planId, file);
    }

    throw UnsupportedError('Unsupported upload mode: ${AppConfig.uploadMode}');
  }

  Future<String> _uploadMultipart(String path, String planId, File file) async {
    final formData = FormData.fromMap({
      'kind': 'PLAN_COVER',
      'planId': planId,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
      ),
    });
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      path,
      data: formData,
    );
    return response.data!['publicUrl'] as String;
  }

  Future<Plan> attachCoverUrl(String planId, String url) async {
    final response = await _apiClient.dio.patch<Map<String, dynamic>>(
      '/plans/$planId',
      data: {'coverImageUrl': url},
    );
    return Plan.fromJson(response.data!);
  }
}
