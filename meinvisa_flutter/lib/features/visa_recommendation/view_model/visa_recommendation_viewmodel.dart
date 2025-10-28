import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/core/services/draft_service.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_recommendation_repository.dart';

class VisaRecommendationNotifier
    extends AutoDisposeAsyncNotifier<VisaQuestionnaire?> {
  late final VisaRecommendationRepository _visaRepository;
  final DraftService _draftService = DraftService();

  @override
  Future<VisaQuestionnaire?> build() async {
    _visaRepository = ref.read(visaRecommendationRepositoryProvider);

    // Load from cache if exists
    final cached = await _draftService.loadDraft();
    if (cached != null) {
      final questionnaire = VisaQuestionnaire.fromJson(cached);
      await _visaRepository.saveDraft(questionnaire); // keep in sync
      return questionnaire;
    }

    // Otherwise, load from repo (if any)
    return _visaRepository.getDraft();
  }

  VisaQuestionnaire? getDraft() => _visaRepository.getDraft();

  /// Save questionnaire response as a draft
  Future<void> saveUserResponse(VisaQuestionnaire questionnaire) async {
    state = AsyncValue.data(questionnaire);
    await _visaRepository.saveDraft(questionnaire);
    await _draftService.saveDraft(questionnaire.toJson());
  }

  // /// Load locally cached draft
  // Future<void> loadDraft() async {
  //   final draft = await _draftService.loadDraft();
  //   if (draft != null) {
  //     final questionnaire = VisaQuestionnaire.fromJson(draft);
  //     state = AsyncValue.data(questionnaire);
  //     await _visaRepository.saveDraft(questionnaire);
  //   }
  // }

  /// Submit questionnaire and get visa eligibility result
  Future<VisaEligibilityResult> handleSubmit() async {
    final questionnaire = state.value;

    if (questionnaire == null) {
      throw Exception('No questionnaire data to submit.');
    }

    // ensure draft is synced
    await _visaRepository.saveDraft(questionnaire);

    // call Edge Function with the current data
    final result = await _visaRepository.filterVisa(questionnaire);
    return result;
  }

  /// Clears all saved responses
  Future<void> clearResponses() async {
    state = const AsyncValue.data(null);
    _visaRepository.clearDraft();
    await _draftService.clearDraft();
  }
}
