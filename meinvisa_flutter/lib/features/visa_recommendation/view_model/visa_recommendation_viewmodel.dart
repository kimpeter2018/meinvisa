// lib/features/visa_recommendation/view_model/visa_recommendation_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_recommendation_repository.dart';

class VisaRecommendationNotifier extends AutoDisposeAsyncNotifier<VisaQuestionnaire?> {
  late final VisaRecommendationRepository _repo;

  /// Internal state
  final List<VisaQuestion> _queue = [];
  final List<VisaQuestion> _answeredQuestionsList = [];
  final Map<String, dynamic> _answers = {};
  final Set<String> _answeredFields = {};

  VisaQuestion? _currentQuestion;
  bool _isInitialized = false;

  @override
  Future<VisaQuestionnaire?> build() async {
    _repo = ref.read(visaRecommendationRepositoryProvider);

    // Handle re-entry (e.g., navigating back to this screen)
    if (_isInitialized) {
      _logQueueState('RE-ENTRY', level: LogLevel.info);
      return _repo.getDraft();
    }

    _logQueueState('INITIALIZATION START', level: LogLevel.info);

    // Load draft from repository (DB or memory)
    await _repo.loadDraft();
    final draft = _repo.getDraft();

    try {
      // Fetch initial questions (universal category)
      final initialQuestions = await _repo.getInitialQuestions();

      DebugLogger().log('📥 Loaded ${initialQuestions.length} initial questions');

      if (draft != null && draft.toJson().isNotEmpty) {
        // Case: User has previous progress - restore state
        DebugLogger().log('📝 Restoring from draft with ${draft.toJson().length} answers');
        await _restoreFromDraft(draft, initialQuestions);
      } else {
        // Case: Fresh start - load initial questions
        DebugLogger().log('✨ Starting fresh questionnaire');
        _queue.addAll(initialQuestions);
        _currentQuestion = _queue.isNotEmpty ? _queue.first : null;
      }

      _isInitialized = true;
      _logQueueState('INITIALIZATION COMPLETE', level: LogLevel.success);

      return draft;
    } catch (e, st) {
      DebugLogger().error('❌ Initialization failed', e, st);
      _logQueueState('INITIALIZATION FAILED', level: LogLevel.error);
      rethrow;
    }
  }

  /// Restore state from saved draft
  Future<void> _restoreFromDraft(
    VisaQuestionnaire draft,
    List<VisaQuestion> initialQuestions,
  ) async {
    final draftData = draft.toJson();

    // Restore answers and answered fields
    _answers.addAll(draftData);
    _answeredFields.addAll(draftData.keys.where((k) => draftData[k] != null));

    DebugLogger().log('🔄 Restoring ${_answeredFields.length} answered fields');

    // Replay the question flow to rebuild state
    final tempQueue = List<VisaQuestion>.from(initialQuestions);

    for (final question in initialQuestions) {
      final fieldKey = question.fieldKey;

      if (_answeredFields.contains(fieldKey)) {
        // Question was previously answered
        _answeredQuestionsList.add(question);
        final answer = _answers[fieldKey];

        if (answer != null) {
          try {
            // Fetch what questions this answer unlocked
            final nextQuestions = await _repo.getNextQuestions(
              fieldKey,
              answer,
              _answeredFields.toList(),
            );

            // Add unlocked questions to temp queue
            for (final next in nextQuestions) {
              if (!_answeredFields.contains(next.fieldKey) &&
                  !tempQueue.any((q) => q.fieldKey == next.fieldKey)) {
                tempQueue.add(next);
              } else if (_answeredFields.contains(next.fieldKey)) {
                // This question was also answered - add to answered list
                if (!_answeredQuestionsList.any((q) => q.fieldKey == next.fieldKey)) {
                  _answeredQuestionsList.add(next);
                }
              }
            }
          } catch (e) {
            DebugLogger().error('⚠️ Error fetching next questions for $fieldKey', e);
          }
        }
      }
    }

    // Remaining unanswered questions go to queue
    _queue.addAll(tempQueue.where((q) => !_answeredFields.contains(q.fieldKey)));

    // Set current question to first unanswered
    _currentQuestion = _queue.isNotEmpty ? _queue.first : null;

    _logQueueState('RESTORE COMPLETE', level: LogLevel.success);
  }

  /// Enhanced queue state logging
  void _logQueueState(String phase, {LogLevel level = LogLevel.info}) {
    final icon = _getLogIcon(level);
    final separator = '═' * 50;

    DebugLogger().log('\n$separator');
    DebugLogger().log('$icon QUEUE STATE - $phase');
    DebugLogger().log(separator);
    DebugLogger().log('📍 Current Question: ${_currentQuestion?.fieldKey ?? "NONE"}');
    DebugLogger().log('✅ Answered: ${_answeredQuestionsList.length} questions');
    DebugLogger().log('⏳ Queued: ${_queue.length} questions');
    DebugLogger().log('📊 Total Fields: ${_answeredFields.length}');

    if (_answeredQuestionsList.isNotEmpty) {
      DebugLogger().log('\n📝 Answered Questions:');
      for (var i = 0; i < _answeredQuestionsList.length; i++) {
        final q = _answeredQuestionsList[i];
        final answer = _answers[q.fieldKey];
        final answerStr = _formatAnswerForLog(answer);
        DebugLogger().log('   ${i + 1}. ${q.fieldKey} = $answerStr');
      }
    }

    if (_queue.isNotEmpty) {
      DebugLogger().log('\n⏳ Remaining Queue:');
      for (var i = 0; i < _queue.length; i++) {
        final q = _queue[i];
        final isCurrent = q.fieldKey == _currentQuestion?.fieldKey;
        final marker = isCurrent ? '➤' : ' ';
        DebugLogger().log('  $marker ${i + 1}. ${q.fieldKey} (${q.category})');
      }
    }

    DebugLogger().log('$separator\n');
  }

  String _getLogIcon(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return '📊';
      case LogLevel.success:
        return '✅';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }

  String _formatAnswerForLog(dynamic answer) {
    if (answer == null) return 'Not Answered';
    if (answer is bool) return answer ? 'Yes' : 'No';
    if (answer is DateTime) {
      return '${answer.day}/${answer.month}/${answer.year}';
    }
    if (answer is String && answer.length > 30) {
      return '${answer.substring(0, 27)}...';
    }
    return answer.toString();
  }

  /// ============================================
  /// PUBLIC GETTERS
  /// ============================================

  VisaQuestion? get currentQuestion => _currentQuestion;
  List<VisaQuestion> get queue => List.unmodifiable(_queue);
  List<VisaQuestion> get answeredQuestionsList => List.unmodifiable(_answeredQuestionsList);
  Map<String, dynamic> get answers => Map.unmodifiable(_answers);
  Set<String> get answeredFields => Set.unmodifiable(_answeredFields);

  bool get isComplete => _currentQuestion == null && _answeredQuestionsList.isNotEmpty;

  /// ============================================
  /// ANSWER HANDLING
  /// ============================================

  Future<void> answerQuestion(VisaQuestion q, dynamic answer) async {
    _logQueueState('BEFORE ANSWER: ${q.fieldKey}', level: LogLevel.info);

    // Check if this is a re-answer (editing previous question)
    final isReAnswer = _answeredFields.contains(q.fieldKey);

    if (isReAnswer) {
      DebugLogger().log('↩️ Re-answering: ${q.fieldKey}');
      await _handleReAnswer(q, answer);
    } else {
      DebugLogger().log('🆕 New answer: ${q.fieldKey} = $answer');
      await _handleNewAnswer(q, answer);
    }

    _logQueueState('AFTER ANSWER: ${q.fieldKey}', level: LogLevel.success);

    // Handle multi-field answers (like birthday + age)
    if (answer is Map<String, dynamic>) {
      _answers.addAll(answer);

      // Add all fields to answeredFields
      for (final key in answer.keys) {
        _answeredFields.add(key);
      }
    } else {
      _answers[q.fieldKey] = answer;
      _answeredFields.add(q.fieldKey);
    }

    // Notify listeners
    state = AsyncData(VisaQuestionnaire.fromJson(_answers));
  }

  /// Handle new answer (forward progress)
  Future<void> _handleNewAnswer(VisaQuestion q, dynamic answer) async {
    // Store answer(s)
    if (answer is Map<String, dynamic>) {
      _answers.addAll(answer);
      for (final key in answer.keys) {
        _answeredFields.add(key);
      }
    } else {
      _answers[q.fieldKey] = answer;
      _answeredFields.add(q.fieldKey);
    }

    // Add to answered list
    _answeredQuestionsList.add(q);

    // Remove from queue
    _queue.removeWhere((x) => x.fieldKey == q.fieldKey);

    // Fetch next questions
    // Fetch next questions (use primary field key)
    final primaryAnswer = answer is Map<String, dynamic>
        ? answer[q.fieldKey] ?? answer.values.first
        : answer;

    await _fetchAndEnqueueNextQuestions(q.fieldKey, primaryAnswer);

    // Update current question
    _currentQuestion = _queue.isNotEmpty ? _queue.first : null;

    // Save draft
    await _repo.saveDraft(VisaQuestionnaire.fromJson(Map<String, dynamic>.from(_answers)));
  }

  /// Handle re-answer (editing previous question)
  Future<void> _handleReAnswer(VisaQuestion q, dynamic answer) async {
    // Find index of this question in answered list
    final index = _answeredQuestionsList.indexWhere((aq) => aq.fieldKey == q.fieldKey);

    if (index == -1) {
      DebugLogger().error('⚠️ Question not found in answered list: ${q.fieldKey}');
      return;
    }

    // Remove all questions after this one
    final removedQuestions = _answeredQuestionsList.sublist(index + 1);
    _answeredQuestionsList.removeRange(index + 1, _answeredQuestionsList.length);

    // Remove their answers
    for (final removed in removedQuestions) {
      _answers.remove(removed.fieldKey);
      _answeredFields.remove(removed.fieldKey);
    }

    DebugLogger().log('🗑️ Removed ${removedQuestions.length} subsequent answers');

    // Clear queue (will be rebuilt)
    _queue.clear();

    // Update this question's answer
    _answers[q.fieldKey] = answer;

    // Fetch next questions based on new answer
    await _rebuildQueueFromAnswers();

    // Update current question
    _currentQuestion = _queue.isNotEmpty ? _queue.first : null;

    // Save draft
    await _repo.saveDraft(VisaQuestionnaire.fromJson(_answers));
  }

  /// Rebuild queue by replaying all answers in order
  Future<void> _rebuildQueueFromAnswers() async {
    _queue.clear();

    // Get initial questions
    final initialQuestions = await _repo.getInitialQuestions();

    // Start with initial questions
    final tempQueue = List<VisaQuestion>.from(initialQuestions);

    // Replay each answered question in order
    for (final answeredQ in _answeredQuestionsList) {
      final fieldKey = answeredQ.fieldKey;
      final answer = _answers[fieldKey];

      if (answer != null) {
        try {
          // Fetch what questions this answer unlocked
          final nextQuestions = await _repo.getNextQuestions(
            fieldKey,
            answer,
            _answeredFields.toList(),
          );

          // Add unlocked questions to temp queue
          for (final next in nextQuestions) {
            if (!_answeredFields.contains(next.fieldKey) &&
                !tempQueue.any((q) => q.fieldKey == next.fieldKey)) {
              tempQueue.add(next);
            }
          }
        } catch (e) {
          DebugLogger().error('⚠️ Error fetching next questions for $fieldKey', e);
        }
      }
    }

    // Add remaining unanswered questions to queue
    _queue.addAll(tempQueue.where((q) => !_answeredFields.contains(q.fieldKey)));

    DebugLogger().log('🔄 Queue rebuilt: ${_queue.length} questions remaining');
  }

  /// Fetch and enqueue next questions based on answer
  Future<void> _fetchAndEnqueueNextQuestions(String fieldKey, dynamic answer) async {
    try {
      final nextQuestions = await _repo.getNextQuestions(
        fieldKey,
        answer,
        _answeredFields.toList(),
      );

      DebugLogger().log('📥 Fetched ${nextQuestions.length} next questions for $fieldKey');

      // Add new questions to queue (avoid duplicates)
      for (final newQ in nextQuestions) {
        final isDuplicate =
            _answeredFields.contains(newQ.fieldKey) ||
            _queue.any((existing) => existing.fieldKey == newQ.fieldKey);

        if (!isDuplicate) {
          _queue.add(newQ);
          DebugLogger().log('  ➕ Enqueued: ${newQ.fieldKey}');
        } else {
          DebugLogger().log('  ⏭️ Skipped duplicate: ${newQ.fieldKey}');
        }
      }
    } catch (e, st) {
      DebugLogger().error('❌ Error fetching next questions', e, st);
      rethrow;
    }
  }

  /// ============================================
  /// NAVIGATION HELPERS
  /// ============================================

  /// Edit a previously answered question
  void editQuestion(VisaQuestion q) {
    DebugLogger().log('✏️ Editing question: ${q.fieldKey}');

    // // Move question to front of queue
    // _queue.removeWhere((x) => x.fieldKey == q.fieldKey);
    // _queue.insert(0, q);
    // _currentQuestion = q;

    _logQueueState('EDIT_QUESTION', level: LogLevel.info);

    state = AsyncData(VisaQuestionnaire.fromJson(_answers));
  }

  /// ============================================
  /// SUBMISSION
  /// ============================================

  Future<VisaRecommendationResponse> handleSubmit() async {
    DebugLogger().log('\n📤 Submitting questionnaire');
    _logQueueState('BEFORE_SUBMIT', level: LogLevel.info);

    final data = _repo.getDraft();
    if (data == null) {
      throw Exception('No questionnaire data to submit.');
    }

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

  Future<void> clearDraft() async {
    DebugLogger().log('🗑️ Clearing all data');

    await _repo.clearDraft();
    _answers.clear();
    _answeredFields.clear();
    _answeredQuestionsList.clear();
    _queue.clear();
    _currentQuestion = null;
    _isInitialized = false;

    _logQueueState('AFTER_CLEAR', level: LogLevel.info);

    state = const AsyncData(null);
  }
}

enum LogLevel { info, success, warning, error }
