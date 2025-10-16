import 'package:meinvisa/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends StateNotifier<AsyncValue<Session?>> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(const AsyncValue.loading()) {
    _initialize();
  }

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------
  Future<void> _initialize() async {
    try {
      final session = _repository.currentSession;
      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ---------------------------------------------------------------------------
  // GOOGLE SIGN-IN
  // ---------------------------------------------------------------------------
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      await _repository.signInWithGoogle();

      final session = _repository.currentSession;
      if (session == null) throw Exception('No session found after sign-in.');

      final user = session.user;
      final userExists = await _repository.userExists(user.id);

      if (!userExists) {
        await _repository.createUserRecord(
          user.userMetadata?['name'] ?? '',
          user.email ?? '',
        );
      }

      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ---------------------------------------------------------------------------
  // EMAIL SIGN-UP
  // ---------------------------------------------------------------------------
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _repository.signUpWithEmail(email, password);
      // Don't set loading here — UI can show partial spinner.
      state = AsyncValue.data(_repository.currentSession);
    } catch (e, st) {
      // Keep state null to avoid blocking UI
      state = AsyncValue.data(null);
      throw Exception('Sign-up failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // EMAIL SIGN-IN
  // ---------------------------------------------------------------------------
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final user = await _repository.signInWithEmail(email, password);
      await _repository.refreshSession(); // optional, refresh session
      state = AsyncValue.data(_repository.currentSession);

      return user?.emailConfirmedAt != null;
    } catch (e, st) {
      state = AsyncValue.data(null);
      final message = e is Exception ? e.toString() : '$e';
      if (message.contains('Email not confirmed')) {
        throw EmailNotConfirmedException();
      } else {
        throw AuthFailedException(message);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // EMAIL CONFIRMATION HANDLING
  // ---------------------------------------------------------------------------
  Future<void> handleEmailConfirmation(String email, String password) async {
    final confirmed = await signInWithEmail(email, password);
    if (!confirmed) throw Exception('Email not confirmed yet.');

    final user = _repository.currentSession?.user;
    if (user != null && !(await _repository.userExists(user.id))) {
      await _repository.createUserRecord(
        user.email?.split('@').first ?? '',
        user.email ?? '',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // USER MANAGEMENT
  // ---------------------------------------------------------------------------
  Future<void> createUserRecord(String name, String email) async {
    await _repository.createUserRecord(name, email);
  }

  Future<bool> doesEmailExist(String email) async {
    return _repository.doesEmailExist(email);
  }

  Future<bool> checkEmailConfirmed() async {
    return _repository.checkEmailConfirmed();
  }

  Future<void> resendVerificationEmail(String email) async {
    await _repository.resendVerificationEmail(email);
  }

  // ---------------------------------------------------------------------------
  // SIGN-OUT
  // ---------------------------------------------------------------------------
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ---------------------------------------------------------------------------
  // SESSION HELPERS
  // ---------------------------------------------------------------------------
  void setSession(Session? session) {
    state = AsyncValue.data(session);
  }
}

class EmailNotConfirmedException implements Exception {
  final String message;
  EmailNotConfirmedException([this.message = "Email is not confirmed"]);
}

class AuthFailedException implements Exception {
  final String message;
  AuthFailedException([this.message = "Authentication failed"]);
}
