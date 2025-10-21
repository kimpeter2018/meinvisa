import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/features/onboarding/repository/onboarding_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingViewModel extends StateNotifier<AsyncValue<void>> {
  final OnboardingRepository _repository;
  final SupabaseClient _client;

  // Local fields for onboarding data
  String? name;
  String? nationality;
  String? occupation;
  String? purposeOfStay;

  OnboardingViewModel(this._repository, this._client)
    : super(const AsyncValue.data(null));

  // ---------------------------------------------------------------------------
  // UPDATE LOCAL DATA
  // ---------------------------------------------------------------------------
  void setName(String value) => name = value.trim();
  void setNationality(String? value) => nationality = value?.trim();
  void setOccupation(String? value) => occupation = value?.trim();
  void setPurposeOfStay(String? value) => purposeOfStay = value?.trim();

  // ---------------------------------------------------------------------------
  // SUBMIT TO SUPABASE
  // ---------------------------------------------------------------------------
  Future<void> completeOnboarding() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    if (name == null || name!.isEmpty) {
      throw Exception("Name is required");
    }

    state = const AsyncValue.loading();

    try {
      await _repository.saveOnboardingData(
        userId: user.id,
        name: name!,
        nationality: nationality,
        occupation: occupation,
        purposeOfStay: purposeOfStay,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ---------------------------------------------------------------------------
  // HELPER: Check if onboarding already done
  // ---------------------------------------------------------------------------
  Future<bool> isOnboardingComplete() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    return _repository.isOnboardingComplete(user.id);
  }
}
