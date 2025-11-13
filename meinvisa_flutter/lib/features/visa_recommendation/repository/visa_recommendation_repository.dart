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

  /// Save draft: Always to SharedPreferences, mark as pending for Supabase
  Future<void> saveDraft(VisaQuestionnaire data, {bool syncToSupabase = false}) async {
    _draft = data;

    // Always save to SharedPreferences (fast, local)
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_draftKey, jsonEncode(data.toJson()));

      if (!syncToSupabase) {
        // Mark as having pending changes
        await prefs.setBool(_hasPendingSyncKey, true);
        // Update local timestamp to track when draft was last saved
        await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
      }

      DebugLogger().log('💾 Draft saved to SharedPreferences');
    } catch (e) {
      DebugLogger().error('❌ Failed to save draft to SharedPreferences', e);
    }

    // Only sync to Supabase if explicitly requested
    if (syncToSupabase) {
      await _syncToSupabase(data);
    }
  }

  /// Check if there are pending changes not synced to Supabase
  Future<bool> hasPendingChanges() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasPendingSyncKey) ?? false;
  }

  /// Sync to Supabase (called explicitly by user or on completion)
  Future<void> syncToSupabase() async {
    if (_draft == null) {
      DebugLogger().log('⚠️ No draft to sync');
      return;
    }

    await _syncToSupabase(_draft!);
  }

  /// Internal sync method
  Future<void> _syncToSupabase(VisaQuestionnaire data) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      DebugLogger().error('⚠️ No authenticated user, cannot sync to Supabase');
      return;
    }

    try {
      await _supabase.from('user_visa_responses').upsert({
        'user_id': userId,
        'responses': data.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
      await prefs.setBool(_hasPendingSyncKey, false);

      DebugLogger().log('☁️ Draft synced to Supabase');
    } catch (e) {
      DebugLogger().error('⚠️ Failed to sync draft to Supabase', e);
      rethrow; // Rethrow so caller knows sync failed
    }
  }

  /// Load draft: Try SharedPreferences first, fallback to Supabase
  Future<void> loadDraft() async {
    // Try SharedPreferences first (fast)
    try {
      final prefs = await SharedPreferences.getInstance();
      final localData = prefs.getString(_draftKey);

      if (localData != null) {
        _draft = VisaQuestionnaire.fromJson(Map<String, dynamic>.from(jsonDecode(localData)));
        DebugLogger().log('📂 Draft loaded from SharedPreferences');

        // Check if we need to sync from Supabase (if local is old)
        final lastSync = prefs.getInt(_lastSyncKey) ?? 0;
        final lastSyncDate = DateTime.fromMillisecondsSinceEpoch(lastSync);
        final now = DateTime.now();
        final hoursSinceSync = now.difference(lastSyncDate).inHours;

        if (hoursSinceSync > 24) {
          DebugLogger().log('🔄 Local draft is $hoursSinceSync old, checking Supabase...');
          await _loadFromSupabase();
        }

        return;
      }
    } catch (e) {
      DebugLogger().error('⚠️ Error loading from SharedPreferences', e);
    }

    // Fallback to Supabase
    await _loadFromSupabase();
  }

  Future<void> _loadFromSupabase() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await _supabase
          .from('user_visa_responses')
          .select('responses')
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null && response['responses'] != null) {
        _draft = VisaQuestionnaire.fromJson(Map<String, dynamic>.from(response['responses']));

        // Save to SharedPreferences for next time
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_draftKey, jsonEncode(_draft!.toJson()));
        await prefs.setBool(_hasPendingSyncKey, false);

        DebugLogger().log('☁️ Draft loaded from Supabase');
      }
    } catch (e) {
      DebugLogger().error('⚠️ Error loading from Supabase', e);
    }
  }

  /// Clear draft from both storages
  Future<void> clearDraft() async {
    _draft = null;

    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
    await prefs.remove(_lastSyncKey);
    await prefs.remove(_hasPendingSyncKey);
    DebugLogger().log('🗑️ Draft cleared from SharedPreferences');

    // Clear Supabase
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      try {
        await _supabase.from('user_visa_responses').delete().eq('user_id', userId);
        DebugLogger().log('🗑️ Draft cleared from Supabase');
      } catch (e) {
        DebugLogger().error('⚠️ Error clearing Supabase', e);
      }
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
