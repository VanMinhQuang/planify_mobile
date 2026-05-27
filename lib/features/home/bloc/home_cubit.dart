import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/plan_repository.dart';
import '../../../domain/models/plan.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isLoading = false,
    this.plans = const [],
    this.message,
  });

  final bool isLoading;
  final List<Plan> plans;
  final String? message;

  HomeState copyWith({bool? isLoading, List<Plan>? plans, String? message}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      plans: plans ?? this.plans,
      message: message,
    );
  }

  @override
  List<Object?> get props => [isLoading, plans, message];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required PlanRepository planRepository})
    : _planRepository = planRepository,
      super(const HomeState());

  final PlanRepository _planRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final plans = await _planRepository.listPlans(status: 'upcoming');
      emit(state.copyWith(isLoading: false, plans: plans));
    } catch (error) {
      emit(state.copyWith(isLoading: false, message: error.toString()));
    }
  }
}
