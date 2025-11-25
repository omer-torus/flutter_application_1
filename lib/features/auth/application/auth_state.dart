import '../domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  final AuthStatus status;
  final UserEntity? user;
  final String? error;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }

  AuthState clearError() {
    return AuthState(
      status: status,
      user: user,
      error: null,
    );
  }
}

