import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/models/app_user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unknown, this.user, this.message});

  final AuthStatus status;
  final AppUser? user;
  final String? message;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? message,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
    on<AuthSignOutRequested>(_onSignOut);
  }

  final AuthRepository _authRepository;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final session = await _authRepository.restoreSession();
      emit(
        session == null
            ? state.copyWith(
                status: AuthStatus.unauthenticated,
                clearUser: true,
              )
            : state.copyWith(
                status: AuthStatus.authenticated,
                user: session.user,
              ),
      );
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
    }
  }

  Future<void> _onGoogleSignIn(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final session = await _authRepository.signInWithGoogle();
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

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
  }
}
