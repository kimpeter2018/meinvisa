import 'dart:async';
import 'package:meinvisa/core/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      final googleAuthorization = await googleUser.authorizationClient
          .authorizationForScopes(scopes);

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
      emailRedirectTo: 'com.meinvisa://auth-callback', // deep link
    );

    if (response.session == null) {
      throw 'Failed to sign up with email.';
    }
  }

  /// Email Sign In
  Future<User?> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session == null) {
      throw 'Failed to sign in with email.';
    }

    if (response.user == null) return null;
    return response.user;
  }

  // Returns true if user exists
  Future<bool> doesEmailExist(String email) async {
    final response = await _client
        .from('users') // or your auth table
        .select('id')
        .eq('email', email)
        .maybeSingle();

    return response != null;
  }

  Future<bool> checkEmailConfirmed() async {
    await _client.auth.refreshSession(); // refresh user state
    print(
      "Email Confirmed at = ${_client.auth.currentUser?.emailConfirmedAt.toString()}",
    );
    final user = _client.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  Future<void> resendVerificationEmail(String email) async {
    await _client.auth.resend(type: OtpType.signup, email: email);
  }

  Future<bool> userExists(String userId) async {
    final response = await _client
        .from('users')
        .select('id')
        .eq('id', userId)
        .maybeSingle();
    return response != null;
  }

  Future<void> createUserRecord(String name, String avatarUrl) async {
    final userId = _client.auth.currentUser!.id;
    final email = _client.auth.currentUser!.email!;

    final user = UserModel(
      id: userId,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
    );

    await _client.from('users').insert(user.toJson());
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
