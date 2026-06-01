part of 'create_plan_cubit.dart';

enum CreatePlanStatus { initial, loading, success, failure }

extension CreatPlanStatusX on CreatePlanStatus {
  bool get isLoading => this == CreatePlanStatus.loading;
  bool get isSuccess => this == CreatePlanStatus.success;
  bool get isFailure => this == CreatePlanStatus.failure;
}

class CreatePlanState extends Equatable {
  final Plan plan;
  final Plan? createdPlan;
  final CreatePlanStatus status;
  final String errorMsg;
  final List<AttachmentItem> journeyImages;
  const CreatePlanState({
    this.plan = const Plan(),
    this.createdPlan,
    this.status = CreatePlanStatus.initial,
    this.errorMsg = '',
    this.journeyImages = const [],
  });

  @override
  List<Object?> get props => [plan, createdPlan, status, errorMsg, journeyImages];
  CreatePlanState copyWith({
    Plan? plan,
    Plan? createdPlan,
    CreatePlanStatus? status,
    String? errorMsg,
    List<AttachmentItem>? journeyImages,
  }) {
    return CreatePlanState(
      plan: plan ?? this.plan,
      createdPlan: createdPlan ?? this.createdPlan,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      journeyImages: journeyImages ?? this.journeyImages,
    );
  }
}
