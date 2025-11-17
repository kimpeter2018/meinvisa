import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/features/home/view/home_layout.dart';
import 'package:meinvisa/features/onboarding/view/onboarding_screen.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meinvisa/data/providers/user_provider.dart';

final onboardingFutureProvider = FutureProvider.family<bool, String>((
  ref,
  userId,
) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_completed_$userId') ?? false;
});

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          // Not logged in
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(LoginScreen.routeName);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User logged in → check onboarding
        final onboardingAsync = ref.watch(onboardingFutureProvider(user.id));

        return onboardingAsync.when(
          data: (completed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(
                completed ? HomeLayout.routeName : OnboardingScreen.routeName,
              );
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (_, __) => const Scaffold(
            body: Center(child: Text("Error loading onboarding status")),
          ),
        );
      },
      loading: () {
        DebugLogger().log("AuthGate: Loading user data...");
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (_, __) => const LoginScreen(),
    );
  }
}
