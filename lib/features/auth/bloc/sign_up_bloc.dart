import 'package:app_core/app_core.dart';

import '../../../domain/repository/sign_up_repository.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted({
    required this.name,
    required this.phone,
    required this.password,
  });

  final String name;
  final String phone;
  final String password;

  @override
  List<Object?> get props => [name, phone, password];
}

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  const SignUpState({this.status = SignUpStatus.initial, this.message});

  final SignUpStatus status;
  final String? message;

  SignUpState copyWith({SignUpStatus? status, String? message}) {
    return SignUpState(status: status ?? this.status, message: message);
  }

  @override
  List<Object?> get props => [status, message];
}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required SignUpRepository signUpRepository})
    : _signUpRepository = signUpRepository,
      super(const SignUpState()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  final SignUpRepository _signUpRepository;

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpState(status: SignUpStatus.loading));
    try {
      await _signUpRepository.signUp(
        name: event.name,
        phone: event.phone,
        password: event.password,
      );
      emit(const SignUpState(status: SignUpStatus.success));
    } catch (error) {
      emit(
        SignUpState(status: SignUpStatus.failure, message: error.toString()),
      );
    }
  }
}
