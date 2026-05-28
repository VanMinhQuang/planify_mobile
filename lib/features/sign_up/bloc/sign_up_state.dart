part of 'sign_up_bloc.dart';

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
