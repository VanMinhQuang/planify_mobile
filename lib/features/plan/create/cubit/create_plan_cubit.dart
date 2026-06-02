import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:planify_mobile/domain/enum/create_plan_enum.dart';
import 'package:planify_mobile/domain/models/plan.dart';
import 'package:planify_mobile/domain/repository/plan_repository.dart';
import 'package:planify_mobile/domain/repository/upload_repository.dart';

part 'create_plan_state.dart';

class CreatePlanCubit extends Cubit<CreatePlanState> {
  CreatePlanCubit({
    required this.planRepository,
    required this.uploadRepository,
  }) : super(CreatePlanState());
  final PlanRepository planRepository;
  final UploadRepository uploadRepository;

  void updateField(CreatePlanField field, Object value) {
    emit(state.copyWith(plan: state.plan.copyWithField(field, value)));
  }

  void onAddImage(List<File> items) {
    final attachments = items
        .map(
          (e) => AttachmentItem(
            id: e.hashCode.toString(),
            isImage: true,
            isLocal: true,
            path: e.path,
          ),
        )
        .toList();
    emit(
      state.copyWith(journeyImages: [...state.journeyImages, ...attachments]),
    );
  }

  void removeImage(AttachmentItem item) {
    emit(
      state.copyWith(
        journeyImages: state.journeyImages
            .where((e) => e.id != item.id)
            .toList(),
      ),
    );
  }

  Future<void> createPlan() async {
    emit(state.copyWith(status: CreatePlanStatus.loading));
    try {
      final plan = await planRepository.createPlan(state.plan);
      final imageFiles = state.journeyImages
          .where((item) => item.isLocal && item.path.isNotEmpty)
          .map((item) => File(item.path))
          .toList();
      final imageUrls = await uploadRepository.uploadPlanImages(
        planId: plan.id,
        files: imageFiles,
      );
      emit(
        state.copyWith(
          status: CreatePlanStatus.success,
          createdPlan: plan.copyWith(
            coverImageUrl: imageUrls.isEmpty
                ? plan.coverImageUrl
                : imageUrls.first,
            imageUrls: imageUrls,
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CreatePlanStatus.failure,
          errorMsg: error.toString(),
        ),
      );
    }
  }
}
