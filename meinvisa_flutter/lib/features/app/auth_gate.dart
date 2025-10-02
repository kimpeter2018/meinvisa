import 'package:meinvisa/core/providers/user_provider.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:meinvisa/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          print("AuthGate: No user data, navigating to LoginScreen");
          return const LoginScreen();
        }
        return const HomeScreen();
      },
      loading: () {
        print("AuthGate: Loading user data...");
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (err, __) {
        return const LoginScreen();
      },
    );
  }
}
