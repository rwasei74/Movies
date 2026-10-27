import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);
  final FirebaseAuth _auth;
  static Future<void>? _googleInitialization;
  Future<void> _initializeGoogle() =>
      _googleInitialization ??= GoogleSignIn.instance.initialize();

  Future<T> _perform<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(switch (e.code) {
        'invalid-email' => 'Please enter a valid email address.',
        'email-already-in-use' => 'This email is already registered.',
        'weak-password' => 'Password must contain at least 6 characters.',
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' => 'Incorrect email or password.',
        'network-request-failed' => 'Please check your internet connection.',
        'operation-not-allowed' => 'Email sign-in is not enabled in Firebase.',
        _ => 'Could not complete your request. Please try again.',
      });
    }
  }

  @override
  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);
  @override
  String? get currentUserId => _auth.currentUser?.uid;
  @override
  Future<void> signIn({required String email, required String password}) async {
    await _perform(
      () => _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _initializeGoogle();
      final account = await GoogleSignIn.instance.authenticate();
      final token = account.authentication.idToken;
      if (token == null) {
        throw const AuthFailure(
          'Google sign-in could not obtain an identity token.',
        );
      }
      await _perform(
        () => _auth.signInWithCredential(
          GoogleAuthProvider.credential(idToken: token),
        ),
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthFailure('Google sign-in was cancelled.');
      }
      throw const AuthFailure(
        'Google sign-in failed. Check your connection and Google account.',
      );
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final credentials = await _perform(
      () => _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
    await _perform(
      () async => credentials.user?.updateDisplayName(name.trim()),
    );
  }

  @override
  Future<void> sendPasswordReset(String email) =>
      _perform(() => _auth.sendPasswordResetEmail(email: email.trim()));
  @override
  Future<void> signOut() async {
    await _perform(() => _auth.signOut());
    if (_googleInitialization != null) {
      try {
        await _initializeGoogle();
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        /* Firebase session is already closed. */
      }
    }
  }
}
