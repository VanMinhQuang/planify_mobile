import 'package:app_core/app_core.dart';
import 'package:planify_mobile/domain/repository/auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const SignUpState()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  final AuthRepository _authRepository;

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpState(status: SignUpStatus.loading));
    try {
      await _authRepository.registerWithPhonePassword(
        phone: event.phone,
        password: event.password,
        name: event.name,
      );
      emit(const SignUpState(status: SignUpStatus.success));
    } catch (error) {
      emit(
        SignUpState(status: SignUpStatus.failure, message: error.toString()),
      );
    }
  }
}
