import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:meinvisa/features/home/view/home_layout.dart';
import 'package:meinvisa/features/onboarding/view/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  Future<bool> _checkOnboardingCompleted(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed_$userId') ?? false;
  }

  Future<void> _recoverSession(BuildContext context) async {
    try {
      final session = await Supabase.instance.client.auth.recoverSession();
      if (session == null) {
        context.go(LoginScreen.routeName);
        return;
      }

      final userId = session.user?.id ?? '';
      final completed = await _checkOnboardingCompleted(userId);
      if (context.mounted) {
        if (completed) {
          context.go(HomeLayout.routeName);
        } else {
          context.go(OnboardingScreen.routeName);
        }
      }
    } catch (e) {
      debugPrint('Auth session recovery failed: $e');
      if (context.mounted) context.go(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _recoverSession(context),
      builder: (context, snapshot) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
