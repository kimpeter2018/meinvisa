import 'package:echad/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  Future<UserModel?> getUser(String id) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  Future<void> createUser(UserModel user) async {
    await _client.from('users').insert(user.toJson());
  }
}
