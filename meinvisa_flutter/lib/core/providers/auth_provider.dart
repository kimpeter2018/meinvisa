import 'package:meinvisa/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/auth_repository.dart';

// Supabase client
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Auth state changes
final authStateProvider = StreamProvider<Session?>((ref) {
  final auth = ref.read(supabaseProvider).auth;

  return auth.onAuthStateChange.map((data) {
    final session = data.session;
    return session;
  });
});

// GoogleSignIn singleton
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn.instance;
});

// AuthRepository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  const webClientId =
      "1095073134659-lbsnrjnm2o95sjjuel3t7bv55ccjt40u.apps.googleusercontent.com";
  const iosClientId =
      "1095073134659-p4scb9kfrt7bldjd8mk9d3gli1l9h621.apps.googleusercontent.com";

  return AuthRepository(
    ref.read(supabaseProvider),
    ref.read(googleSignInProvider),
    webClientId: webClientId,
    iosClientId: iosClientId,
    scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
});

// ViewModel
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<Session?>>((ref) {
      final repo = ref.read(authRepositoryProvider);
      return AuthViewModel(repo);
    });
