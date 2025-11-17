import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VisaRecommendationRepository {
  final UserRepository _userRepository;
  final SupabaseClient _supabase = Supabase.instance.client;

  // In-memory cache for options (countries, occupations)
  final Map<String, List<String>> _optionsCache = {};

  // In-memory draft (primary source)
  VisaQuestionnaire? _draft;

  // Local storage keys
  static const String _draftKey = 'visa_questionnaire_draft';
  static const String _lastSyncKey = 'visa_draft_last_sync';
  static const String _hasPendingSyncKey = 'visa_draft_pending_sync';

  VisaRecommendationRepository(this._userRepository);

  /// ============================================
  /// HYBRID DRAFT MANAGEMENT (SharedPreferences + Supabase)
  /// ============================================

  VisaQuestionnaire? getDraft() => _draft;

  /// Save draft to SharedPreferences only
  Future<void> saveDraft(VisaQuestionnaire data) async {
    _draft = data;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_draftKey, jsonEncode(data.toJson()));
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
      DebugLogger().log('💾 Draft saved to SharedPreferences');
    } catch (e) {
      DebugLogger().error('❌ Failed to save draft to SharedPreferences', e);
      rethrow;
    }
  }

  /// Check if there are any saved changes
  Future<bool> hasPendingChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getString(_draftKey);
    return localData != null && localData.isNotEmpty;
  }

  /// Load draft from SharedPreferences
  Future<void> loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localData = prefs.getString(_draftKey);

      if (localData != null && localData.isNotEmpty) {
        _draft = VisaQuestionnaire.fromJson(Map<String, dynamic>.from(jsonDecode(localData)));
        DebugLogger().log('📂 Draft loaded from SharedPreferences');
      } else {
        _draft = null;
        DebugLogger().log('📂 No draft found in SharedPreferences');
      }
    } catch (e) {
      DebugLogger().error('⚠️ Error loading from SharedPreferences', e);
      _draft = null;
    }
  }

  /// Clear draft from SharedPreferences
  Future<void> clearDraft() async {
    DebugLogger().log('🗑️ Clearing draft...');

    // Clear in-memory draft first
    _draft = null;

    // Clear SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
      await prefs.remove(_lastSyncKey);
      await prefs.remove(_hasPendingSyncKey);
      DebugLogger().log('✅ Draft cleared from SharedPreferences');
    } catch (e) {
      DebugLogger().error('❌ Error clearing SharedPreferences', e);
      rethrow;
    }
  }

  /// ============================================
  /// QUESTION FETCHING
  /// ============================================

  Future<List<VisaQuestion>> getInitialQuestions() async {
    try {
      final response = await _supabase
          .from('visa_questions')
          .select('*')
          .eq('category', 'universal')
          .order('order_index', ascending: true);

      DebugLogger().log('📥 Fetched ${(response as List).length} initial questions');

      return await _hydrateQuestions(
        (response).map((json) => VisaQuestion.fromJson(json)).toList(),
      );
    } catch (e, st) {
      DebugLogger().error('❌ Failed to fetch initial questions', e, st);
      return [];
    }
  }

  /// UPDATED: Now passes all answers as JSONB for complex logic
  Future<List<VisaQuestion>> getNextQuestions(
    String fieldKey,
    dynamic answer,
    List<String> answeredFields,
  ) async {
    try {
      DebugLogger().log('🔍 Fetching next questions for: $fieldKey = $answer');

      // Convert current draft to JSONB for the function
      final allAnswers = _draft?.toJson() ?? {};

      // Add the current answer
      if (answer is Map<String, dynamic>) {
        allAnswers.addAll(answer);
      } else {
        allAnswers[fieldKey] = answer;
      }

      String answerStr = _convertAnswerToString(answer);

      final response = await _supabase.rpc(
        'get_next_questions',
        params: {
          'p_field_key': fieldKey,
          'p_answer': answerStr,
          'p_answered_fields': answeredFields,
          'p_all_answers': allAnswers, // NEW: Pass all answers for complex logic
        },
      );

      if (response == null || (response as List).isEmpty) {
        DebugLogger().log('ℹ️ No next questions for this path.');
        return [];
      }

      final questions = (response)
          .map((json) => VisaQuestion.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      DebugLogger().log('📥 Retrieved ${questions.length} questions from SQL');

      return await _hydrateQuestions(questions);
    } catch (e, st) {
      DebugLogger().error('❌ Failed to fetch next questions', e, st);
      return [];
    }
  }

  /// Convert answer to string for database comparison
  String _convertAnswerToString(dynamic answer) {
    if (answer == null) return '';
    if (answer is bool) return answer.toString();
    if (answer is DateTime) return answer.toIso8601String();
    if (answer is Map) {
      // For multi-field answers like birthday+age, use the primary field
      // Find the first non-null value
      final firstValue = answer.values.firstWhere((v) => v != null, orElse: () => '');
      if (firstValue is DateTime) return firstValue.toIso8601String();
      return firstValue.toString();
    }
    return answer.toString();
  }

  /// Validate if all required questions have been answered
  Future<bool> validateCompleteness(VisaQuestionnaire data) async {
    final answeredFields = data.toJson().keys.where((k) => data.toJson()[k] != null).toSet();

    try {
      // Get all questions that should have been asked based on the flow
      final allQuestions = await _supabase
          .from('visa_questions')
          .select('field_key, required, category, purpose_filter')
          .eq('required', true);

      final requiredQuestions = (allQuestions as List)
          .where((q) {
            // Check if this question's purpose matches user's purpose
            final purposeFilter = q['purpose_filter'] as List?;
            final userPurpose = data.purpose;

            if (purposeFilter == null || purposeFilter.isEmpty || userPurpose == null) {
              return q['category'] == 'universal'; // Only universal questions are always required
            }

            return purposeFilter.contains(userPurpose);
          })
          .map((q) => q['field_key'] as String)
          .toSet();

      final unanswered = requiredQuestions.difference(answeredFields);

      if (unanswered.isNotEmpty) {
        DebugLogger().log('⚠️ Missing required fields: ${unanswered.join(', ')}');
        return false;
      }

      return true;
    } catch (e) {
      DebugLogger().error('❌ Error validating completeness', e);
      return false;
    }
  }

  Future<List<VisaQuestion>> _hydrateQuestions(List<VisaQuestion> questions) async {
    final cache = <String, List<String>>{};
    final futures = questions.map((q) async {
      if (q.optionsSource != null && q.optionsSource!.isNotEmpty) {
        cache[q.optionsSource!] ??= await getOptions(q.optionsSource!);
        return q.copyWith(options: cache[q.optionsSource]!);
      }
      return q;
    });

    return Future.wait(futures);
  }

  /// ============================================
  /// OPTIONS FETCHING (Cached)
  /// ============================================

  Future<List<String>> getOptions(String source) async {
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

      case 'universities':
        final data = await _supabase
            .from('universities')
            .select('name')
            .order('name', ascending: true);
        result = (data as List).map((e) => e['name'] as String).toList();
        break;

      case 'degree_fields':
        final data = await _supabase
            .from('degree_fields')
            .select('field')
            .order('field', ascending: true);
        result = (data as List).map((e) => e['field'] as String).toList();
        break;

      default:
        result = [];
    }

    _optionsCache[source] = result;
    return result;
  }

  /// ============================================
  /// VISA RECOMMENDATION (Edge Function)
  /// ============================================

  Future<VisaRecommendationResponse> recommendVisa(VisaQuestionnaire data) async {
    DebugLogger().log('📤 Submitting Visa Questionnaire');

    final session = Supabase.instance.client.auth.currentSession;
    final userToken = session?.accessToken;

    if (userToken == null) {
      throw Exception('User not logged in');
    }

    final response = await _supabase.functions.invoke(
      'visa-recommendation',
      body: data.toJson(),
      headers: {'Authorization': 'Bearer $userToken'},
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

    // Parse the response data
    final Map<String, dynamic> responseData = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    DebugLogger().log('📥 Received response: ${jsonEncode(responseData)}');

    return VisaRecommendationResponse.fromJson(responseData);
  }
}
