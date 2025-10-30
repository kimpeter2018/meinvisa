import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_recommendation_repository.dart';

class VisaRecommendationNotifier
    extends AutoDisposeAsyncNotifier<VisaQuestionnaire?> {
  late final VisaRecommendationRepository _repo;

  /// Internal state
  List<VisaQuestion> _allQuestions = [];
  List<VisaQuestion> _queue = [];
  Map<String, dynamic> _answers = {};

  @override
  Future<VisaQuestionnaire?> build() async {
    _repo = ref.read(visaRecommendationRepositoryProvider);

    // Load draft if any
    final draft = _repo.getDraft();

    // Fetch all questions
    _allQuestions = await _repo.getAllQuestions();

    // Initialize queue
    _queue = _initializeQueue(draft);

    _answers = draft?.toJson() ?? {};
    return draft;
  }

  /// Initialize the question queue (start from "universal" or "purpose")
  List<VisaQuestion> _initializeQueue(VisaQuestionnaire? draft) {
    final initial = _allQuestions
        .where((q) => q.category == 'universal')
        .toList();

    // If user already answered purpose, load related ones
    final purpose = draft?.purposeOfStay;
    if (purpose != null) {
      final related = _filterQuestionsByPurpose(purpose);
      return [...initial, ...related];
    }

    return initial;
  }

  /// Filter questions dynamically based on user's chosen purpose
  List<VisaQuestion> _filterQuestionsByPurpose(String purpose) {
    return _allQuestions.where((q) {
      final cond = q.optionsSource ?? '';
      if (cond.contains('IN')) {
        final match = RegExp(r'purpose_of_stay IN \((.+)\)').firstMatch(cond);
        if (match != null) {
          final list = match
              .group(1)!
              .replaceAll('"', '')
              .split(',')
              .map((e) => e.trim())
              .toList();
          return list.contains(purpose);
        }
      }
      return true;
    }).toList();
  }

  /// Public getter for UI
  List<VisaQuestion> get queue => _queue;

  /// Get current answers
  Map<String, dynamic> get answers => _answers;

  /// Handle answering a question
  Future<void> answerQuestion(VisaQuestion q, dynamic answer) async {
    _answers[q.fieldKey] = answer;

    // Handle dynamic branching
    if (q.fieldKey == 'purpose_of_stay') {
      final related = _filterQuestionsByPurpose(answer.toString());
      _queue.addAll(related);
    }

    // Save to draft
    await _repo.saveDraft(VisaQuestionnaire.fromJson(_answers));

    // Notify UI
    state = AsyncData(VisaQuestionnaire.fromJson(_answers));
  }

  /// Pop the next question (Progressive flow)
  VisaQuestion? nextQuestion() {
    if (_queue.isEmpty) return null;
    return _queue.removeAt(0);
  }

  /// Submit and fetch result
  Future<VisaEligibilityResult> handleSubmit() async {
    final data = _repo.getDraft();
    if (data == null) {
      throw Exception('No questionnaire data to submit.');
    }

    state = const AsyncLoading();

    try {
      final result = await _repo.filterVisa(data);
      state = AsyncData(data);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  void clearDraft() {
    _repo.clearDraft();
    _answers.clear();
    _queue.clear();
    state = const AsyncData(null);
  }
}
