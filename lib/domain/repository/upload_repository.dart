import 'dart:io';

import '../models/plan.dart';

abstract interface class UploadRepository {
  Future<String> uploadPlanCover({
    required String planId,
    required File file,
    String mode,
  });

  Future<List<String>> uploadPlanImages({
    required String planId,
    required List<File> files,
    String mode,
  });

  Future<String> uploadAvatar({required File file, String mode});

  Future<Plan> attachCoverUrl(String planId, String url);
}
