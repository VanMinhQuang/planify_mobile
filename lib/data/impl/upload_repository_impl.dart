import 'dart:io';

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
    return _uploadMultipart(
      ApiUrl.upload(mode),
      file,
      fields: {'kind': 'PLAN_COVER', 'planId': planId},
    );
  }

  @override
  Future<List<String>> uploadPlanImages({
    required String planId,
    required List<File> files,
    String mode = 'r2',
  }) async {
    if (mode != 'iis' && mode != 'r2') {
      throw UnsupportedError('Unsupported upload mode: $mode');
    }
    if (files.isEmpty) {
      return const [];
    }
    final response = await _apiClient.uploadFiles<Map<String, dynamic>>(
      path: ApiUrl.uploadMultiple(mode),
      filePaths: files.map((file) => file.path).toList(),
      fields: {'kind': 'PLAN_COVER', 'planId': planId},
    );
    final uploadedFiles = response?['files'] as List<dynamic>? ?? [];
    return uploadedFiles
        .map((item) => (item as Map<String, dynamic>)['publicUrl'] as String?)
        .whereType<String>()
        .toList();
  }

  @override
  Future<String> uploadAvatar({required File file, String mode = 'iis'}) async {
    if (mode != 'iis' && mode != 'r2') {
      throw UnsupportedError('Unsupported upload mode: $mode');
    }
    return _uploadMultipart(
      ApiUrl.upload(mode),
      file,
      fields: {'kind': 'AVATAR'},
    );
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

  Future<String> _uploadMultipart(
    String path,
    File file, {
    required Map<String, dynamic> fields,
  }) async {
    final response = await _apiClient.uploadFile<Map<String, dynamic>>(
      path: path,
      filePath: file.path,
      fields: fields,
    );
    final publicUrl = response?['publicUrl'] as String?;
    if (publicUrl == null || publicUrl.isEmpty) {
      throw 'Upload failed';
    }
    return publicUrl;
  }
}
