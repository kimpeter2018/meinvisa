import 'package:meinvisa/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingRepository {
  final SupabaseClient _client;
  OnboardingRepository(this._client);

  // ---------------------------------------------------------------------------
  // CREATE / UPDATE USER PROFILE
  // ---------------------------------------------------------------------------
  Future<void> saveOnboardingData({
    required String userId,
    required String name,
    String? nationality,
    String? occupation,
    String? purposeOfStay,
  }) async {
    final data = {
      'id': userId,
      'name': name,
      'nationality': nationality,
      'occupation': occupation,
      'purpose_of_stay': purposeOfStay,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // upsert = insert or update existing record
    await _client.from('users').upsert(data);
  }

  // ---------------------------------------------------------------------------
  // FETCH EXISTING USER (if needed)
  // ---------------------------------------------------------------------------
  Future<UserModel?> fetchUser(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  // ---------------------------------------------------------------------------
  // CHECK IF USER ALREADY COMPLETED ONBOARDING
  // ---------------------------------------------------------------------------
  Future<bool> isOnboardingComplete(String userId) async {
    final response = await _client
        .from('users')
        .select('name, nationality, occupation, purpose_of_stay')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return false;

    return response['name'] != null &&
        response['nationality'] != null &&
        response['occupation'] != null &&
        response['purpose_of_stay'] != null;
  }
}
