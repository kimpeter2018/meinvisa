import 'dart:async';

import 'package:echad/core/models/user_model.dart';
import 'package:echad/core/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// StreamProvider to always reflect the latest app user
final userProvider = StreamProvider<UserModel?>((ref) {
  final client = ref.read(supabaseProvider);

  // Emit initial user right away
  final controller = StreamController<UserModel?>();

  Future<void> emitCurrentUser() async {
    final session = client.auth.currentSession;
    if (session == null) {
      controller.add(null);
      return;
    }

    // fetch user data from your `users` table
    final response = await client
        .from('users')
        .select()
        .eq('id', session.user.id)
        .maybeSingle();

    if (response == null) {
      controller.add(null); // not onboarded yet
    } else {
      controller.add(UserModel.fromJson(response));
    }
  }

  emitCurrentUser();

  // Listen to auth state changes
  final authSub = client.auth.onAuthStateChange.listen((event) {
    emitCurrentUser();
  });

  ref.onDispose(() {
    authSub.cancel();
    controller.close();
  });

  return controller.stream;
});
