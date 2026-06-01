import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/app_user.dart';
import '../../../domain/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthPhone>(_onPhone);
    on<ChangePhone>(_onChangePhone);
    on<ChangePassword>(_onChangePassword);
    on<ChangeObsecure>(_onChangeObsecure);
  }

  final AuthRepository _authRepository;

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(user: event.user));
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final session = await _authRepository.restoreSession();
      if (session == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
        return;
      }
      await _authRepository.registerDevice();
      emit(
        state.copyWith(status: AuthStatus.authenticated, user: session.user),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          message: error.toString(),
        ),
      );
    }
  }

  void _onChangePhone(ChangePhone event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(status: AuthStatus.unauthenticated, phone: event.phone),
    );
  }

  void _onChangePassword(ChangePassword event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        password: event.password,
      ),
    );
  }

  void _onChangeObsecure(ChangeObsecure event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        isObsecure: !state.isObsecure,
        status: AuthStatus.unauthenticated,
      ),
    );
  }

  Future<void> _onPhone(AuthPhone event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final session = await _authRepository.loginWithPhonePassword(
        phone: state.phone,
        password: state.password,
      );
      await _authRepository.registerDevice();
      emit(state.copyWith(status: AuthStatus.authenticated, user: session));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          clearUser: true,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onGoogleSignIn(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final session = await _authRepository.signInWithGoogle();
      await _authRepository.registerDevice();
      emit(state.copyWith(status: AuthStatus.authenticated, user: session));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          clearUser: true,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
    } finally {
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
    }
  }
}
