import 'package:meinvisa/features/app/auth_gate.dart';
import 'package:meinvisa/features/auth/view/email_confirmation_screen.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:meinvisa/features/auth/view/signup_screen.dart';
import 'package:meinvisa/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          // Session exists, now delegate to AuthGate
          return const AuthGate();
        }
        return const LoginScreen();
      },
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    // GoRoute(
    //   path: '/onboarding',
    //   builder: (context, state) => const OnboardingScreen(),
    // ),
    GoRoute(
      path: '/email-confirmation',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        final password = state.uri.queryParameters['password'] ?? '';
        return EmailConfirmationScreen(email: email, password: password);
      },
    ),
    GoRoute(
      path: '/auth-callback',
      builder: (context, state) {
        final uri = state.uri; // deep link Uri

        return FutureBuilder(
          future: Supabase.instance.client.auth.getSessionFromUrl(uri),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return EmailConfirmationScreen(
                email: '', // or pass state.queryParams['email']
                password: '', // or pass state.queryParams['password']
                // You might want to show an error message here
                // errorMessage: snapshot.error.toString(),
              );
            }

            final session = snapshot.data;
            if (session != null) {
              return const HomeScreen(); // success — user confirmed
            } else {
              return const LoginScreen(); // failed — retry login
            }
          },
        );
      },
    ),
  ],
);
