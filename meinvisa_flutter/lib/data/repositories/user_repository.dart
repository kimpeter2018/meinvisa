import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides a [UserRepository] instance with dependency injection via Riverpod.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final client = Supabase.instance.client;
  return UserRepository(client);
});

/// Repository responsible for all user-related data interactions.
class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  // ---------------------------------------------------------------------------
  // FETCH USER
  // ---------------------------------------------------------------------------
  Future<UserModel?> getUser(String id) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(response));
  }

  // ---------------------------------------------------------------------------
  // CREATE USER
  // ---------------------------------------------------------------------------
  Future<void> createUser(UserModel user) async {
    await _client.from('users').insert(user.toJson());
  }

  // ---------------------------------------------------------------------------
  // UPDATE USER
  // ---------------------------------------------------------------------------
  Future<void> updateUser(UserModel user) async {
    await _client.from('users').update(user.toJson()).eq('id', user.id);
  }

  // ---------------------------------------------------------------------------
  // SAVE USER PROFILE (CREATE OR UPDATE)
  // ---------------------------------------------------------------------------
  Future<void> saveUserProfile(UserModel user) async {
    final existing = await getUser(user.id);

    if (existing == null) {
      await createUser(user);
    } else {
      await updateUser(user);
    }
  }

  Future<bool> exists(String userId) async {
    final response = await _client
        .from('users')
        .select('id')
        .eq('id', userId)
        .maybeSingle();
    return response != null;
  }

  // ---------------------------------------------------------------------------
  // EMAIL CHECK
  // ---------------------------------------------------------------------------
  Future<bool> emailExists(String email) async {
    final response = await _client
        .from('users')
        .select('id')
        .eq('email', email)
        .maybeSingle();
    return response != null;
  }

  // ---------------------------------------------------------------------------
  // DELETE USER (optional)
  // ---------------------------------------------------------------------------
  Future<void> deleteUser(String id) async {
    await _client.from('users').delete().eq('id', id);
  }
}
