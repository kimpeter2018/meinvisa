import 'package:meinvisa/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends StateNotifier<AsyncValue<Session?>> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(const AsyncValue.loading()) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    state = AsyncValue.data(_repository.currentSession);
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      await _repository.signInWithGoogle();
      final session = _repository.currentSession;
      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Email Sign-Up
  Future<void> signUpWithEmail(String email, String password) async {
    // state = const AsyncValue.loading();
    try {
      await _repository.signUpWithEmail(email, password);
      state = AsyncValue.data(_repository.currentSession);
    } catch (e) {
      state = AsyncValue.data(null);
      rethrow;
    }
  }

  /// Email Sign-In
  Future<void> signInWithEmail(String email, String password) async {
    // state = const AsyncValue.loading();
    try {
      await _repository.signInWithEmail(email, password);
      state = AsyncValue.data(_repository.currentSession);
    } catch (e) {
      state = AsyncValue.data(null);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> doesEmailExist(String email) async {
    try {
      return await _repository.doesEmailExist(email);
    } catch (e) {
      return false;
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      await _repository.resendVerificationEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  void setSession(Session session) {
    state = AsyncValue.data(session);
  }
}
