import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_question_path_model/visa_question_path_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_recommendation_repository.dart';

class VisaRecommendationNotifier
    extends AutoDisposeAsyncNotifier<VisaQuestionnaire?> {
  late final VisaRecommendationRepository _repo;

  /// Internal state
  List<VisaQuestion> _allQuestions = [];
  List<VisaQuestionPath> _allPaths = [];
  List<VisaQuestion> _queue = [];
  Map<String, dynamic> _answers = {};

  VisaQuestion? _currentQuestion;

  @override
  Future<VisaQuestionnaire?> build() async {
    _repo = ref.read(visaRecommendationRepositoryProvider);

    // Load draft if any
    final draft = _repo.getDraft();
    try {
      _allQuestions = await _repo.getAllQuestions();
      _allPaths = await _repo.getAllQuestionPaths();
    } catch (e, st) {
      DebugLogger().log('Error loading questions: $e\n$st');
    }
    // Initialize queue
    final initialQueue = _initializeQueue(draft);
    _queue.addAll(initialQueue);

    // Initialize current question
    if (_queue.isNotEmpty) {
      _currentQuestion = _queue.first;
    }

    // Restore answers
    _answers.addAll(draft?.toJson() ?? {});

    return draft;
  }

  /// Initialize the question queue (start from "universal")
  List<VisaQuestion> _initializeQueue(VisaQuestionnaire? draft) {
    return _allQuestions.where((q) => q.category == 'universal').toList();
  }

  /// Public getter for UI
  VisaQuestion? get currentQuestion => _currentQuestion;
  List<VisaQuestion> get queue => _queue;

  /// Get current answers
  Map<String, dynamic> get answers => _answers;

  /// 🧠 Answer handling (with branching)
  Future<void> answerQuestion(VisaQuestion q, dynamic answer) async {
    _answers[q.fieldKey] = answer;

    // Apply path-based logic
    _handleTriggeredPaths(q, answer);

    // Save to draft
    await _repo.saveDraft(VisaQuestionnaire.fromJson(_answers));
    DebugLogger().log('Saved draft: ${_answers.toString()}');

    // Move to next question
    advanceToNextQuestion();

    // Notify listeners (Riverpod rebuild)
    state = AsyncData(VisaQuestionnaire.fromJson(_answers));
  }

  /// 🧩 Handle path-based branching
  void _handleTriggeredPaths(VisaQuestion q, dynamic answer) {
    final triggeredPaths = _allPaths.where(
      (p) =>
          p.fromField == q.fieldKey &&
          (p.answerValue == null ||
              p.answerValue.toString().trim() == answer.toString().trim()),
    );

    for (final path in triggeredPaths) {
      // Add questions from next categories
      for (final category in path.nextCategories) {
        final related = _allQuestions.where((x) => x.category == category);
        for (final newQ in related) {
          if (!_queue.any((existing) => existing.fieldKey == newQ.fieldKey)) {
            _queue.add(newQ);
          }
        }
      }

      // Add specific next questions
      for (final key in path.nextQuestionKeys) {
        final q = _allQuestions.firstWhereOrNull((x) => x.fieldKey == key);
        if (q != null &&
            !_queue.any((existing) => existing.fieldKey == q.fieldKey)) {
          _queue.add(q);
        }
      }
    }
  }

  /// 🆕 Move queue forward
  void advanceToNextQuestion() {
    if (_queue.isNotEmpty) {
      _queue.removeAt(0);
      _currentQuestion = _queue.isNotEmpty ? _queue.first : null;
    }
  }

  /// 🆕 Allow jumping back to an answered question
  void setCurrentQuestion(VisaQuestion q) {
    // If already in queue, bring it forward
    if (_queue.any((x) => x.fieldKey == q.fieldKey)) {
      _queue.removeWhere((x) => x.fieldKey == q.fieldKey);
    }
    _queue.insert(0, q);
    _currentQuestion = q;

    state = AsyncData(VisaQuestionnaire.fromJson(_answers));
  }

  /// Submit and fetch result
  Future<VisaEligibilityResult> handleSubmit() async {
    final data = _repo.getDraft();
    if (data == null) {
      throw Exception('No questionnaire data to submit.');
    }

    state = const AsyncLoading();

    try {
      final result = await _repo.recommendVisa(data);
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
    _currentQuestion = null;
    state = const AsyncData(null);
  }
}
