import '../../domain/repository/sign_up_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  @override
  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
  }) {
    throw UnimplementedError();
  }
}
