import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState()) {
    _init();
  }

  final AuthRepository _repository;
  StreamSubscription? _authSubscription;

  void _init() {
    // Auth state değişikliklerini dinle
    _authSubscription = _repository.authStateChanges().listen(
      (user) {
        if (user != null) {
          state = AuthState(status: AuthStatus.authenticated, user: user);
        } else {
          state = const AuthState(status: AuthStatus.unauthenticated);
        }
      },
      onError: (error) {
        state = AuthState(
          status: AuthStatus.error,
          error: error.toString(),
        );
      },
    );

    // İlk kontrol
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (error) {
      state = AuthState(
        status: AuthStatus.error,
        error: error.toString(),
      );
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (error) {
      state = AuthState(
        status: AuthStatus.error,
        error: error.toString(),
      );
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final user = await _repository.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (error) {
      state = AuthState(
        status: AuthStatus.error,
        error: error.toString(),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      await _repository.signOut();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (error) {
      state = AuthState(
        status: AuthStatus.error,
        error: error.toString(),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _repository.resetPassword(email);
    } catch (error) {
      state = state.copyWith(error: error.toString());
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

