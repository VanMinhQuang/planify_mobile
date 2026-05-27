import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../domain/models/plan.dart';
import '../api/api_client.dart';
import '../services/firebase_upload_service.dart';

class UploadRepository {
  UploadRepository({
    required ApiClient apiClient,
    required FirebaseUploadService uploadService,
  }) : _apiClient = apiClient,
       _uploadService = uploadService;

  final ApiClient _apiClient;
  final FirebaseUploadService _uploadService;

  Future<String> uploadPlanCover({
    required String planId,
    required File file,
  }) async {
    if (AppConfig.uploadMode == 'iis') {
      final formData = FormData.fromMap({
        'kind': 'PLAN_COVER',
        'planId': planId,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
        ),
      });
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/uploads/iis',
        data: formData,
      );
      return response.data!['publicUrl'] as String;
    }

    final pathResponse = await _apiClient.dio.post<Map<String, dynamic>>(
      '/uploads/firebase-path',
      data: {
        'kind': 'PLAN_COVER',
        'planId': planId,
        'fileName': file.uri.pathSegments.last,
      },
    );
    final objectPath = pathResponse.data!['objectPath'] as String;
    final url = await _uploadService.uploadFile(
      file: file,
      objectPath: objectPath,
    );
    await _apiClient.dio.post(
      '/uploads/complete',
      data: {
        'kind': 'PLAN_COVER',
        'planId': planId,
        'objectPath': objectPath,
        'publicUrl': url,
        'sizeBytes': await file.length(),
      },
    );
    return url;
  }

  Future<Plan> attachCoverUrl(String planId, String url) async {
    final response = await _apiClient.dio.patch<Map<String, dynamic>>(
      '/plans/$planId',
      data: {'coverImageUrl': url},
    );
    return Plan.fromJson(response.data!);
  }
}
