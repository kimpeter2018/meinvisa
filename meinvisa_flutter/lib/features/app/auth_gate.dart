import 'package:meinvisa/data/providers/auth_provider.dart';
import 'package:meinvisa/data/providers/user_provider.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:meinvisa/features/home/view/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      data: (auth) {
        if (auth == null) {
          return const LoginScreen();
        }
        return const HomeLayout();
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
