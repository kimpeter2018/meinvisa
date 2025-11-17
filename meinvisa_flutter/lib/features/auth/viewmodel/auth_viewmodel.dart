import 'package:meinvisa/data/models/user_model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:meinvisa/features/auth/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends StateNotifier<AsyncValue<Session?>> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthViewModel(this._authRepository, this._userRepository)
    : super(const AsyncValue.loading()) {
    _initialize();
  }
  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------
  Future<void> _initialize() async {
    try {
      final session = _authRepository.currentSession;
      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ---------------------------------------------------------------------------
  // GOOGLE SIGN-IN
  // ---------------------------------------------------------------------------
  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      await _authRepository.signInWithGoogle();

      final session = _authRepository.currentSession;
      if (session == null) throw Exception('No session found after sign-in.');

      final user = session.user;
      final userExists = await _userRepository.exists(user.id);

      if (!userExists) {
        await _userRepository.createUser(
          UserModel(id: user.id, email: user.email!, createdAt: DateTime.now()),
        );
      }

      state = AsyncValue.data(session);
      return userExists;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // EMAIL SIGN-UP
  // ---------------------------------------------------------------------------
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _authRepository.signUpWithEmail(email, password);
      // Don't set loading here — UI can show partial spinner.
      state = AsyncValue.data(_authRepository.currentSession);
    } catch (e) {
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
      final user = await _authRepository.signInWithEmail(email, password);
      await _authRepository.refreshSession(); // optional, refresh session
      state = AsyncValue.data(_authRepository.currentSession);

      return user?.emailConfirmedAt != null;
    } catch (e) {
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

    final userSession = _authRepository.currentSession?.user;
    final user = UserModel(
      id: userSession!.id,
      email: userSession.email!,
      createdAt: DateTime.now(),
    );

    if (!(await _userRepository.exists(user.id))) {
      await _userRepository.createUser(user);
    }
  }

  Future<bool> doesEmailExist(String email) async {
    return _userRepository.emailExists(email);
  }

  Future<bool> checkEmailConfirmed() async {
    return _authRepository.checkEmailConfirmed();
  }

  Future<void> resendVerificationEmail(String email) async {
    await _authRepository.resendVerificationEmail(email);
  }

  // ---------------------------------------------------------------------------
  // SIGN-OUT
  // ---------------------------------------------------------------------------
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signOut();
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
