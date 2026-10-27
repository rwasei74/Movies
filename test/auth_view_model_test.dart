import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/presentation/viewmodels/auth_view_model.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<String?> get authStateChanges => const Stream.empty();
  @override
  String? get currentUserId => null;
  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {}
  @override
  Future<void> sendPasswordReset(String email) async {}
  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {}
  @override
  Future<void> signInWithGoogle() async {}
  @override
  Future<void> signOut() async {}
}

void main() {
  test('reports authentication errors and clears loading state', () async {
    final model = AuthViewModel(FakeAuthRepository());
    final success = await model.run(
      () async => throw const AuthFailure('Incorrect email or password.'),
    );
    expect(success, isFalse);
    expect(model.loading, isFalse);
    expect(model.error, 'Incorrect email or password.');
    await model.close();
  });

  test('a successful retry clears the previous error', () async {
    final model = AuthViewModel(FakeAuthRepository());
    model.validationError('Missing fields');
    expect(await model.run(() async {}), isTrue);
    expect(model.error, isNull);
    expect(model.loading, isFalse);
    await model.close();
  });
}
