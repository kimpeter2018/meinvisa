import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;
  final GoogleSignIn _googleSignIn;
  final String webClientId;
  final String iosClientId;
  final List<String> scopes;

  AuthRepository(
    this._client,
    this._googleSignIn, {
    required this.webClientId,
    required this.iosClientId,
    required this.scopes,
  });

  Session? get currentSession => _client.auth.currentSession;

  Future<void> signInWithGoogle() async {
    if (!_googleSignIn.supportsAuthenticate()) {
      throw Exception("Authenticate not supported on this platform");
    }

    try {
      final googleUser = await _googleSignIn.authenticate(scopeHint: scopes);

      final googleAuthentication = googleUser.authentication;
      final googleAuthorization = await googleUser.authorizationClient.authorizationForScopes(
        scopes,
      );

      if (googleAuthorization == null) {
        // Deal with the case where this scope is not approved (I don't even know if it's possible as it's a basic OAuth2.0 scope for google).
      }
      final accessToken = googleAuthorization?.accessToken;
      final idToken = googleAuthentication.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Email Sign Up
  Future<void> signUpWithEmail(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      // emailRedirectTo: 'com.meinvisa://auth-callback', // deep link
      emailRedirectTo: 'http://localhost:3000/email-confirmed',
    );

    if (response.session == null) {
      throw 'Failed to sign up with email.';
    }
  }

  /// Email Sign In
  // Future<User?> signInWithEmail(String email, String password) async {
  //   DebugLogger().log('🔐 AuthRepository: Starting signInWithEmail');
  //   DebugLogger().log('📧 Email: $email');
  //   DebugLogger().log('🌐 Supabase URL: ${_client.supabaseUrl}');
  //   DebugLogger().log('🔑 Auth endpoint: ${_client.supabaseUrl}/auth/v1/token');
  //   final response = await _client.auth.signInWithPassword(email: email, password: password);

  //   if (response.session == null) {
  //     throw 'Failed to sign in with email.';
  //   }

  //   if (response.user == null) return null;
  //   return response.user;
  // }
  Future<User?> signInWithEmail(String email, String password) async {
    DebugLogger().log('🔐 AuthRepository: Starting signInWithEmail');
    DebugLogger().log('📧 Email: $email');
    DebugLogger().log('🌐 Supabase header: ${_client.headers}');
    DebugLogger().log('🌐 Supabase header: ${_client.toString()}');

    try {
      DebugLogger().log('⏳ Calling signInWithPassword...');

      final response = await _client.auth.signInWithPassword(email: email, password: password);

      DebugLogger().log('✅ Sign in successful');
      DebugLogger().log('👤 User ID: ${response.user?.id}');
      DebugLogger().log('📨 Email confirmed: ${response.user?.emailConfirmedAt != null}');

      if (response.session == null) {
        DebugLogger().log('❌ No session returned');
        throw 'Failed to sign in with email.';
      }

      if (response.user == null) {
        DebugLogger().log('⚠️ No user returned');
        return null;
      }

      return response.user;
    } on AuthRetryableFetchException catch (e) {
      DebugLogger().error('❌ AuthRetryableFetchException: ${e.message}');
      DebugLogger().error('📊 Status Code: ${e.statusCode}');
      rethrow;
    } on AuthException catch (e) {
      DebugLogger().error('❌ AuthException: ${e.message}');
      DebugLogger().error('📊 Status Code: ${e.statusCode}');
      rethrow;
    } catch (e, stackTrace) {
      DebugLogger().log('❌ Unexpected error during sign in: $e');
      DebugLogger().log('📚 Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<bool> checkEmailConfirmed() async {
    await _client.auth.refreshSession(); // refresh user state

    final user = _client.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  Future<void> resendVerificationEmail(String email) async {
    await _client.auth.resend(type: OtpType.signup, email: email);
  }

  Future<void> refreshSession() async {
    await _client.auth.refreshSession();
  }

  // Also disconnect Google sign-in
  Future<void> signOut() async {
    await _client.auth.signOut();
    await _googleSignIn.signOut();
    await _googleSignIn.disconnect();
  }
}
