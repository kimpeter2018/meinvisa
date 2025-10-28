import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/auth_provider.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:meinvisa/features/home/view/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/features/onboarding/view/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  Future<bool> _checkOnboardingCompleted(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed_$userId') ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      data: (auth) {
        if (auth == null) {
          Future.microtask(() => context.go(LoginScreen.routeName));
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Logged in → check onboarding before showing anything
        final user = Supabase.instance.client.auth.currentUser;
        final userId = user?.id ?? '';

        Future.microtask(() async {
          final completed = await _checkOnboardingCompleted(userId);

          if (context.mounted) {
            if (completed) {
              context.go(HomeLayout.routeName);
            } else {
              context.go(OnboardingScreen.routeName);
            }
          }
        });

        // Show loading until navigation occurs
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading: () {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (_, __) {
        return const LoginScreen();
      },
    );
  }
}
