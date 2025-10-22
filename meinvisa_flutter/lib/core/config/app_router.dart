import 'package:flutter/foundation.dart';
import 'package:meinvisa/core/debug/debug_overlay.dart';
import 'package:meinvisa/features/app/auth_gate.dart';
import 'package:meinvisa/features/auth/view/email_confirmation_screen.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:meinvisa/features/auth/view/signup_screen.dart';
import 'package:meinvisa/features/home/view/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/features/onboarding/view/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
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
    GoRoute(
      path: HomeLayout.routeName,
      builder: (context, state) => const HomeLayout(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: SignupScreen.routeName,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: EmailConfirmationScreen.routeName,
      builder: (context, state) {
        final args = state.extra as Map<String, String>? ?? {};
        final email = args['email'] ?? '';
        final password = args['password'] ?? '';
        return EmailConfirmationScreen(email: email, password: password);
      },
    ),
    GoRoute(
      path: OnboardingScreen.routeName,
      builder: (context, state) => OnboardingScreen(),
    ),
    if (kDebugMode)
      GoRoute(
        path: DebugOverlay.routeName,
        builder: (context, state) => const DebugOverlay(),
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
              return const OnboardingScreen(); // success — user confirmed
            } else {
              return const LoginScreen(); // failed — retry login
            }
          },
        );
      },
    ),
  ],
);
