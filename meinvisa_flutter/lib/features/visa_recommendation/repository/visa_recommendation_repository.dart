// lib/features/visa_recommendation/repository/visa_recommendation_repository.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VisaRecommendationRepository {
  final UserRepository _userRepository;
  final SupabaseClient _supabase = Supabase.instance.client;

  // In-memory cache for options (countries, occupations)
  final Map<String, List<String>> _optionsCache = {};

  // In-memory draft (no database storage for now)
  VisaQuestionnaire? _draft;

  VisaRecommendationRepository(this._userRepository);

  /// ============================================
  /// DRAFT MANAGEMENT (In-Memory + Optional DB)
  /// ============================================

  VisaQuestionnaire? getDraft() => _draft;

  Future<void> saveDraft(VisaQuestionnaire data) async {
    _draft = data;

    // Optional: Persist to database for multi-device sync
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      try {
        await _supabase.from('user_visa_responses').upsert({
          'user_id': userId,
          'responses': data.toJson(),
          'last_question_field': null, // You can track this if needed
        });
      } catch (e) {
        DebugLogger().log('Failed to save draft to DB: $e');
        // Continue anyway - in-memory draft is still valid
      }
    }
  }

  Future<void> loadDraft() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await _supabase
          .from('user_visa_responses')
          .select('responses')
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null && response['responses'] != null) {
        _draft = VisaQuestionnaire.fromJson(
          Map<String, dynamic>.from(response['responses']),
        );
      }
    } catch (e) {
      DebugLogger().log('Failed to load draft from DB: $e');
    }
  }

  void clearDraft() {
    _draft = null;

    // Optional: Clear from database
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      _supabase
          .from('user_visa_responses')
          .delete()
          .eq('user_id', userId)
          .then((_) {
            DebugLogger().log('Cleared draft from DB');
          })
          .catchError((e) {
            DebugLogger().log('Failed to clear draft from DB: $e');
          });
    }
  }

  /// ============================================
  /// QUESTION FETCHING (Optimized)
  /// ============================================

  /// Get initial questions (universal category only)
  Future<List<VisaQuestion>> getInitialQuestions() async {
    try {
      final response = await _supabase
          .from('visa_questions')
          .select('*')
          .eq('category', 'universal')
          .order('order_index', ascending: true);

      return await _hydrateQuestions(
        (response as List).map((json) => VisaQuestion.fromJson(json)).toList(),
      );
    } catch (e) {
      DebugLogger().error('Failed to fetch initial questions', e);
      return [];
    }
  }

  /// Get next questions based on current answer (Optimized O(log n) branching)
  Future<List<VisaQuestion>> getNextQuestions(
    String fieldKey,
    dynamic answer,
    List<String> answeredFields,
  ) async {
    try {
      // Call PostgreSQL function for efficient branching
      final response = await _supabase.rpc(
        'get_next_questions',
        params: {
          'p_field_key': fieldKey,
          'p_answer': answer.toString(),
          'p_answered_fields': answeredFields,
        },
      );

      if (response == null) return [];

      final questions = (response as List)
          .map((json) => VisaQuestion.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      return await _hydrateQuestions(questions);
    } catch (e) {
      DebugLogger().error('Failed to fetch next questions', e);
      return [];
    }
  }

  /// Hydrate questions with dynamic options (countries, occupations)
  Future<List<VisaQuestion>> _hydrateQuestions(
    List<VisaQuestion> questions,
  ) async {
    final futures = questions.map((q) async {
      if (q.optionsSource != null && q.optionsSource!.isNotEmpty) {
        final opts = await getOptions(q.optionsSource!);
        return q.copyWith(options: opts);
      }
      return q;
    });

    return Future.wait(futures);
  }

  /// ============================================
  /// OPTIONS FETCHING (Cached)
  /// ============================================

  Future<List<String>> getOptions(String source) async {
    // Check cache first
    if (_optionsCache.containsKey(source)) {
      return _optionsCache[source]!;
    }

    List<String> result;

    switch (source) {
      case 'countries':
        final data = await _supabase
            .from('countries')
            .select('name')
            .order('name', ascending: true);
        result = (data as List).map((e) => e['name'] as String).toList();
        break;

      case 'occupations':
        final data = await _supabase
            .from('occupations')
            .select('title')
            .order('title', ascending: true);
        result = (data as List).map((e) => e['title'] as String).toList();
        break;

      default:
        result = [];
    }

    // Cache the result
    _optionsCache[source] = result;
    return result;
  }

  /// ============================================
  /// VISA RECOMMENDATION (Edge Function)
  /// ============================================

  Future<VisaEligibilityResult> recommendVisa(VisaQuestionnaire data) async {
    DebugLogger().log('Submitting Visa Questionnaire: ${data.toJson()}');

    final response = await _supabase.functions.invoke(
      'visa-recommendation',
      body: data.toJson(),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['SUPABASE_FUNCTION_KEY'] ?? ''}',
      },
    );

    if (response.status >= 400) {
      final details = response.data?.toString();
      throw FunctionException(
        status: response.status,
        details: details ?? 'Unknown error',
        reasonPhrase: 'Function returned an error',
      );
    }

    if (response.data == null) {
      throw Exception("Empty response from visa eligibility function.");
    }

    return VisaEligibilityResult.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
