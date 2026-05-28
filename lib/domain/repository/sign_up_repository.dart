abstract interface class SignUpRepository {
  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
  });
}
