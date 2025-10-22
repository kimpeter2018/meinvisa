import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/user_model/user_model.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_recommendation_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VisaRecommendationNotifier extends AutoDisposeAsyncNotifier<UserModel?> {
  late final VisaRecommendationRepository _visaRepository;
  late final UserRepository _userRepository;

  @override
  Future<UserModel?> build() async {
    _visaRepository = ref.read(visaRecommendationRepositoryProvider);
    _userRepository = ref.read(userRepositoryProvider);

    final sessionUser = Supabase.instance.client.auth.currentUser;
    if (sessionUser == null) return null;

    final existingUser = await _userRepository.getUser(sessionUser.id);
    return existingUser;
  }

  VisaQuestionnaire? getDraft() => _visaRepository.getDraft();

  /// Save questionnaire response as a draft
  Future<void> saveUserResponse(VisaQuestionnaire questionnaire) async {
    await _visaRepository.saveDraft(questionnaire);
  }

  /// Submits the final questionnaire and retrieves the eligibility result
  Future<VisaEligibilityResult> handleSubmit() async {
    final result = await _visaRepository.filterVisa();
    return result;
  }

  /// Clears all saved responses
  void clearResponses() {
    _visaRepository.clearDraft();
  }
  // -------------------------
  // UPDATE FIELDS DURING ONBOARDING
  // -------------------------
  // Future<void> updateName(
  //   String firstName,
  //   String? middleName,
  //   String lastName,
  // ) async {
  //   final current = state.value!;
  //   final updated = current.copyWith(
  //     firstName: firstName,
  //     middleName: middleName,
  //     lastName: lastName,
  //   );
  //   state = AsyncValue.data(updated);
  //   await _visaRepository.saveDraft(updated);
  // }

  // Future<void> updateAvatar(String avatarUrl) async {
  //   final current = state.value!;
  //   final updated = current.copyWith(avatarUrl: avatarUrl);
  //   state = AsyncValue.data(updated);
  //   await _visaRepository.saveDraft(updated);
  // }

  // Future<void> updateNationality(String nationality) async {
  //   final current = state.value!;
  //   final updated = current.copyWith(nationality: nationality);
  //   state = AsyncValue.data(updated);
  //   await _visaRecommendationRepository.saveDraft(updated);
  // }

  // Future<void> updateOccupation(String occupation) async {
  //   final current = state.value!;
  //   final updated = current.copyWith(occupation: occupation);
  //   state = AsyncValue.data(updated);
  //   await _visaRecommendationRepository.saveDraft(updated);
  // }

  // Future<void> updatePurpose(String purpose) async {
  //   final current = state.value!;
  //   final updated = current.copyWith(purposeOfStay: purpose);
  //   state = AsyncValue.data(updated);
  //   await _visaRecommendationRepository.saveDraft(updated);
  // }
}
