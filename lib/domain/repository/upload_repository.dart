import 'dart:io';

import '../models/plan.dart';

abstract interface class UploadRepository {
  Future<String> uploadPlanCover({
    required String planId,
    required File file,
    String mode,
  });

  Future<String> uploadAvatar({required File file, String mode});

  Future<Plan> attachCoverUrl(String planId, String url);
}
