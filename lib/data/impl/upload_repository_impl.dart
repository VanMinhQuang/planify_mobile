import 'dart:io';

import 'package:dio/dio.dart';

import '../../domain/models/plan.dart';
import '../../domain/repository/upload_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/plan_dto.dart';

class UploadRepositoryImpl implements UploadRepository {
  UploadRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<String> uploadPlanCover({
    required String planId,
    required File file,
    String mode = 'iis',
  }) async {
    if (mode != 'iis' && mode != 'r2') {
      throw UnsupportedError('Unsupported upload mode: $mode');
    }
    return _uploadMultipart(ApiUrl.upload(mode), planId, file);
  }

  @override
  Future<Plan> attachCoverUrl(String planId, String url) async {
    try {
      final result = await _apiClient.patch(
        path: ApiUrl.plan(planId),
        body: {'coverImageUrl': url},
        parser: (json) =>
            PlanDto.fromJson(json as Map<String, dynamic>).toDomain(),
      );
      if (result == null) {
        throw 'Lỗi khi cập nhật dữ liệu';
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _uploadMultipart(String path, String planId, File file) async {
    return '';
    // final formData = FormData.fromMap({
    //   'kind': 'PLAN_COVER',
    //   'planId': planId,
    //   'file': await MultipartFile.fromFile(
    //     file.path,
    //     filename: file.uri.pathSegments.last,
    //   ),
    // });
    // final response = await _apiClient.post(
    //   path,
    //   data: formData,
    //   parser: (json) => json as Map<String, dynamic>,
    // );
    // return response['publicUrl'] as String;
  }
}
