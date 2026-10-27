import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthState {
  const AuthState({this.loading = false, this.error});
  final bool loading;
  final String? error;

  AuthState copyWith({bool? loading, String? error, bool clearError = false}) =>
      AuthState(
        loading: loading ?? this.loading,
        error: clearError ? null : error ?? this.error,
      );
}

class AuthViewModel extends Cubit<AuthState> {
  AuthViewModel(this.repository) : super(const AuthState());
  final AuthRepository repository;
  bool get loading => state.loading;
  String? get error => state.error;

  Future<bool> run(Future<void> Function() action) async {
    if (state.loading) return false;
    emit(const AuthState(loading: true));
    try {
      await action();
      return true;
    } on AuthFailure catch (e) {
      emit(AuthState(error: e.message));
      return false;
    } catch (_) {
      emit(
        const AuthState(
          error: 'Could not complete your request. Please try again.',
        ),
      );
      return false;
    } finally {
      if (!isClosed) emit(AuthState(loading: false, error: state.error));
    }
  }

  void validationError(String message) {
    emit(AuthState(error: message));
  }
}
