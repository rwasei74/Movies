class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}

abstract interface class AuthRepository {
  Stream<String?> get authStateChanges;
  String? get currentUserId;
  Future<void> signIn({required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}
