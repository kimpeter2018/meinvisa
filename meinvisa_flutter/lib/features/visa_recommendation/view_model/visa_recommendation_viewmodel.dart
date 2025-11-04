// lib/features/visa_recommendation/view_model/visa_recommendation_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_recommendation_repository.dart';

class VisaRecommendationNotifier
    extends AutoDisposeAsyncNotifier<VisaQuestionnaire?> {
  late final VisaRecommendationRepository _repo;

  /// Internal state
  final List<VisaQuestion> _queue = [];
  final List<VisaQuestion> _answeredQuestionsList =
      []; // Track answered questions in order
  final Map<String, dynamic> _answers = {};
  final Set<String> _answeredFields = {}; // O(1) lookup

  VisaQuestion? _currentQuestion;
  bool _isInitialized = false;

  @override
  Future<VisaQuestionnaire?> build() async {
    _repo = ref.read(visaRecommendationRepositoryProvider);

    if (_isInitialized) {
      DebugLogger().log('🔄 Re-entering questionnaire - using existing state');
      _logQueueState('RE-ENTRY');
      return _repo.getDraft();
    }

    DebugLogger().log('🆕 First-time initialization');

    // Load draft if any (from DB or memory)
    await _repo.loadDraft();
    final draft = _repo.getDraft();

    try {
      // Initialize with universal questions only
      final initialQuestions = await _repo.getInitialQuestions();

      DebugLogger().log(
        '📥 Loaded ${initialQuestions.length} initial questions',
      );

      if (draft != null && draft.toJson().isNotEmpty) {
        DebugLogger().log(
          '📝 Found existing draft with ${draft.toJson().length} answers',
        );
        await _restoreFromDraft(draft, initialQuestions);
      } else {
        DebugLogger().log('✨ Starting fresh questionnaire');
        _queue.addAll(initialQuestions);
        _currentQuestion = _queue.isNotEmpty ? _queue.first : null;
      }

      _isInitialized = true;
      _logQueueState('INITIALIZATION COMPLETE');
    } catch (e, st) {
      DebugLogger().error('❌ Error initializing questionnaire', e, st);
      rethrow;
    }

    return draft;
  }

  /// Restore state from draft
  Future<void> _restoreFromDraft(
    VisaQuestionnaire draft,
    List<VisaQuestion> initialQuestions,
  ) async {
    final draftData = draft.toJson();

    // Restore answers
    _answers.addAll(draftData);
    _answeredFields.addAll(draftData.keys.where((k) => draftData[k] != null));

    DebugLogger().log('🔍 Restoring ${_answeredFields.length} answered fields');

    // Build answered questions list by replaying the questionnaire flow
    final tempQueue = List<VisaQuestion>.from(initialQuestions);

    for (final question in initialQuestions) {
      final fieldKey = question.fieldKey;

      if (_answeredFields.contains(fieldKey)) {
        // This question was answered
        _answeredQuestionsList.add(question);

        // Fetch what questions this answer would have unlocked
        final answer = _answers[fieldKey];
        if (answer != null) {
          try {
            final nextQuestions = await _repo.getNextQuestions(
              fieldKey,
              answer,
              _answeredFields.toList(),
            );

            // Add next questions to temp queue if not already answered
            for (final next in nextQuestions) {
              if (!_answeredFields.contains(next.fieldKey) &&
                  !tempQueue.any((q) => q.fieldKey == next.fieldKey)) {
                tempQueue.add(next);
              } else if (_answeredFields.contains(next.fieldKey)) {
                // This was also answered - add to answered list if not there
                if (!_answeredQuestionsList.any(
                  (q) => q.fieldKey == next.fieldKey,
                )) {
                  _answeredQuestionsList.add(next);
                }
              }
            }
          } catch (e) {
            DebugLogger().error(
              '⚠️ Error fetching next questions for $fieldKey',
              e,
            );
          }
        }
      }
    }

    // Remaining unanswered questions go to queue
    _queue.addAll(
      tempQueue.where((q) => !_answeredFields.contains(q.fieldKey)),
    );

    // Set current question to first unanswered
    _currentQuestion = _queue.isNotEmpty ? _queue.first : null;

    DebugLogger().log('✅ Restored state:');
    DebugLogger().log(
      '   - Answered: ${_answeredQuestionsList.length} questions',
    );
    DebugLogger().log('   - Remaining: ${_queue.length} questions');
    DebugLogger().log('   - Current: ${_currentQuestion?.fieldKey ?? "NONE"}');
  }

  /// Log current queue state for debugging
  void _logQueueState(String phase) {
    DebugLogger().log('═══════════════════════════════════════');
    DebugLogger().log('📊 QUEUE STATE - $phase');
    DebugLogger().log('═══════════════════════════════════════');
    DebugLogger().log(
      'Current Question: ${_currentQuestion?.fieldKey ?? "NONE"}',
    );
    DebugLogger().log('Answered Count: ${_answeredQuestionsList.length}');
    DebugLogger().log('Queue Size: ${_queue.length}');
    DebugLogger().log('Total Answered Fields: ${_answeredFields.length}');

    if (_answeredQuestionsList.isNotEmpty) {
      DebugLogger().log('\n📝 Answered Questions:');
      for (var i = 0; i < _answeredQuestionsList.length; i++) {
        final q = _answeredQuestionsList[i];
        final answer = _answers[q.fieldKey];
        DebugLogger().log('   ${i + 1}. ${q.fieldKey} = $answer');
      }
    }

    if (_queue.isNotEmpty) {
      DebugLogger().log('\n⏳ Queue:');
      for (var i = 0; i < _queue.length; i++) {
        final q = _queue[i];
        DebugLogger().log('   ${i + 1}. ${q.fieldKey} (${q.category})');
      }
    }

    DebugLogger().log('═══════════════════════════════════════\n');
  }

  /// ============================================
  /// PUBLIC GETTERS
  /// ============================================

  VisaQuestion? get currentQuestion {
    _logQueueState('GET_CURRENT_QUESTION');
    return _currentQuestion;
  }

  List<VisaQuestion> get queue => _queue;
  List<VisaQuestion> get answeredQuestionsList => _answeredQuestionsList;
  Map<String, dynamic> get answers => _answers;
  Set<String> get answeredFields => _answeredFields;

  /// ============================================
  /// ANSWER HANDLING
  /// ============================================

  Future<void> answerQuestion(VisaQuestion q, dynamic answer) async {
    DebugLogger().log('\n🎯 Answering: ${q.fieldKey} = $answer');

    // Check if this is a re-answer (editing previous question)
    final isReAnswer = _answeredFields.contains(q.fieldKey);

    if (isReAnswer) {
      DebugLogger().log('   ↩️ Re-answering previous question');

      // Find index of this question in answered list
      final index = _answeredQuestionsList.indexWhere(
        (aq) => aq.fieldKey == q.fieldKey,
      );

      if (index != -1) {
        // Remove all questions after this one
        final removedQuestions = _answeredQuestionsList.sublist(index + 1);
        _answeredQuestionsList.removeRange(
          index + 1,
          _answeredQuestionsList.length,
        );

        // Remove their answers
        for (final removed in removedQuestions) {
          _answers.remove(removed.fieldKey);
          _answeredFields.remove(removed.fieldKey);
        }

        // Clear queue and rebuild
        _queue.clear();

        DebugLogger().log(
          '   🗑️ Removed ${removedQuestions.length} subsequent answers',
        );
      }
    }

    // Store answer
    _answers[q.fieldKey] = answer;
    _answeredFields.add(q.fieldKey);

    // Add to answered questions list if not already there
    if (!_answeredQuestionsList.any((aq) => aq.fieldKey == q.fieldKey)) {
      _answeredQuestionsList.add(q);
    }

    // Remove current question from queue
    _queue.removeWhere((x) => x.fieldKey == q.fieldKey);

    // Fetch next questions based on this answer
    try {
      final nextQuestions = await _repo.getNextQuestions(
        q.fieldKey,
        answer,
        _answeredFields.toList(),
      );

      DebugLogger().log('   📥 Fetched ${nextQuestions.length} next questions');

      // Add new questions to queue
      for (final newQ in nextQuestions) {
        if (!_answeredFields.contains(newQ.fieldKey) &&
            !_queue.any((existing) => existing.fieldKey == newQ.fieldKey)) {
          _queue.add(newQ);
          DebugLogger().log('      + Added: ${newQ.fieldKey}');
        }
      }

      // Update current question
      _currentQuestion = _queue.isNotEmpty ? _queue.first : null;

      // Save draft asynchronously
      await _repo.saveDraft(VisaQuestionnaire.fromJson(_answers));

      _logQueueState('AFTER ANSWER');

      // Notify listeners
      state = AsyncData(VisaQuestionnaire.fromJson(_answers));
    } catch (e, st) {
      DebugLogger().error('❌ Error fetching next questions', e, st);
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// ============================================
  /// NAVIGATION HELPERS
  /// ============================================

  /// Edit a previously answered question
  void editQuestion(VisaQuestion q) {
    DebugLogger().log('✏️ Editing question: ${q.fieldKey}');

    // Move question to front of queue
    _queue.removeWhere((x) => x.fieldKey == q.fieldKey);
    _queue.insert(0, q);
    _currentQuestion = q;

    _logQueueState('EDIT_QUESTION');

    state = AsyncData(VisaQuestionnaire.fromJson(_answers));
  }

  /// ============================================
  /// SUBMISSION
  /// ============================================

  Future<VisaEligibilityResult> handleSubmit() async {
    DebugLogger().log('\n📤 Submitting questionnaire');

    final data = _repo.getDraft();
    if (data == null) {
      throw Exception('No questionnaire data to submit.');
    }

    _logQueueState('BEFORE_SUBMIT');

    state = const AsyncLoading();

    try {
      final result = await _repo.recommendVisa(data);
      DebugLogger().log('✅ Received visa recommendation');
      state = AsyncData(data);
      return result;
    } catch (e, st) {
      DebugLogger().error('❌ Submission failed', e, st);
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// ============================================
  /// RESET
  /// ============================================

  void clearDraft() {
    DebugLogger().log('🗑️ Clearing draft');

    _repo.clearDraft();
    _answers.clear();
    _answeredFields.clear();
    _answeredQuestionsList.clear();
    _queue.clear();
    _currentQuestion = null;
    _isInitialized = false;

    state = const AsyncData(null);
  }
}
