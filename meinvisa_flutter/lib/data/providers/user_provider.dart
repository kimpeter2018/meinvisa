import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/user_model/user_model.dart';
import 'package:meinvisa/data/providers/auth_provider.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';

final userProvider = StreamProvider<UserModel?>((ref) {
  final client = ref.read(supabaseProvider);

  final controller = StreamController<UserModel?>();

  Future<void> emitCurrentUser() async {
    final session = client.auth.currentSession;
    if (session == null) {
      controller.add(null);
      return;
    }

    DebugLogger().log(
      "UserProvider: Fetching user from 'users' table for ${session.user.id}",
    );
    try {
      final response = await client
          .from('users')
          .select()
          .eq('id', session.user.id)
          .maybeSingle();
      DebugLogger().log("UserProvider: users response = $response");
      if (response == null) {
        controller.add(null);
      } else {
        controller.add(UserModel.fromJson(response));
      }
    } catch (e, st) {
      DebugLogger().log("UserProvider: ERROR fetching user: $e\n$st");
      controller.add(null);
    }
  }

  // Emit immediately if session exists
  emitCurrentUser();

  // Listen to auth changes
  final authSub = client.auth.onAuthStateChange.listen((event) async {
    DebugLogger().log("UserProvider: Auth event = ${event.event.name}");
    await emitCurrentUser();
  });

  ref.onDispose(() {
    authSub.cancel();
    controller.close();
  });

  return controller.stream;
});
