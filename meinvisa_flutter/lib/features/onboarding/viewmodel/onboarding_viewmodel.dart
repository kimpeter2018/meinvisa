import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/user_model.dart';
import 'package:meinvisa/data/providers/onboarding_provider.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:meinvisa/features/onboarding/repository/onboarding_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingNotifier extends AutoDisposeAsyncNotifier<UserModel?> {
  late final OnboardingRepository _onboardingRepository;
  late final UserRepository _userRepository;

  @override
  Future<UserModel?> build() async {
    _onboardingRepository = ref.read(onboardingRepositoryProvider);
    _userRepository = ref.read(userRepositoryProvider);

    // Get current logged-in user ID
    final sessionUser = Supabase.instance.client.auth.currentUser;
    if (sessionUser == null) return null;

    // Fetch existing user from DB
    final existingUser = await _userRepository.getUser(sessionUser.id);

    // Save initial draft in onboarding repository
    if (existingUser != null) {
      await _onboardingRepository.saveDraft(existingUser);
    }

    return existingUser;
  }

  // -------------------------
  // UPDATE FIELDS DURING ONBOARDING
  // -------------------------
  Future<void> updateName(String name) async {
    final current = state.value!;
    final updated = current.copyWith(name: name);
    state = AsyncValue.data(updated);
    await _onboardingRepository.saveDraft(updated);
  }

  Future<void> updateAvatar(String avatarUrl) async {
    final current = state.value!;
    final updated = current.copyWith(avatarUrl: avatarUrl);
    state = AsyncValue.data(updated);
    await _onboardingRepository.saveDraft(updated);
  }

  Future<void> updateNationality(String nationality) async {
    final current = state.value!;
    final updated = current.copyWith(nationality: nationality);
    state = AsyncValue.data(updated);
    await _onboardingRepository.saveDraft(updated);
  }

  Future<void> updateOccupation(String occupation) async {
    final current = state.value!;
    final updated = current.copyWith(occupation: occupation);
    state = AsyncValue.data(updated);
    await _onboardingRepository.saveDraft(updated);
  }

  Future<void> updatePurpose(String purpose) async {
    final current = state.value!;
    final updated = current.copyWith(purposeOfStay: purpose);
    state = AsyncValue.data(updated);
    await _onboardingRepository.saveDraft(updated);
  }

  // -------------------------
  // COMPLETE ONBOARDING
  // -------------------------
  Future<void> completeOnboarding() async {
    final user = state.value;
    if (user != null) {
      await _onboardingRepository.completeOnboarding(user);
    }
  }
}
