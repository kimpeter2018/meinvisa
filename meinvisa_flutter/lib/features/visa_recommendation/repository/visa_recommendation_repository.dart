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
  /// AUTO-DERIVATION LOGIC
  /// ============================================

  /// Derive field attributes from profession or degree field
  Future<Map<String, dynamic>> deriveFieldAttributes({
    String? profession,
    String? degreeField,
  }) async {
    try {
      DebugLogger().log(
        '🔄 Deriving field attributes from profession: $profession, degree: $degreeField',
      );

      final response = await _supabase.rpc(
        'derive_field_attributes',
        params: {'p_profession': profession, 'p_degree_field': degreeField},
      );

      if (response == null) {
        DebugLogger().log('⚠️ No derived attributes returned');
        return {};
      }

      final derived = response as Map<String, dynamic>;
      DebugLogger().log('✅ Derived attributes: $derived');

      return {
        'is_it_field': derived['is_it_field'],
        'is_healthcare': derived['is_healthcare'],
        'is_engineer': derived['is_engineer'],
        'is_stem': derived['is_stem'],
        if (derived['it_specialization'] != null) 'it_specialization': derived['it_specialization'],
        if (derived['healthcare_profession'] != null)
          'healthcare_profession': derived['healthcare_profession'],
        if (derived['engineering_field'] != null) 'engineering_field': derived['engineering_field'],
      };
    } catch (e, st) {
      DebugLogger().error('❌ Error deriving field attributes', e, st);
      return {};
    }
  }

  /// Get university details from database
  Future<Map<String, dynamic>> getUniversityDetails(String universityName) async {
    try {
      DebugLogger().log('🔄 Fetching university details for: $universityName');

      final response = await _supabase.rpc(
        'get_university_details',
        params: {'p_university_name': universityName},
      );

      if (response == null) {
        DebugLogger().log('⚠️ No university details found');
        return {};
      }

      final details = response as Map<String, dynamic>;
      DebugLogger().log('✅ University details: $details');

      return {
        'university_country': details['country'],
        'city': details['city'],
        'is_recognized': details['is_recognized'],
        'anabin_status': details['anabin_status'],
      };
    } catch (e, st) {
      DebugLogger().error('❌ Error fetching university details', e, st);
      return {};
    }
  }

  /// Check if degree needs Anerkennung
  Future<bool> needsAnerkennung({
    String? universityName,
    String? universityCountry,
    String? degreeField,
  }) async {
    try {
      DebugLogger().log('🔄 Checking Anerkennung requirement');

      final response = await _supabase.rpc(
        'needs_anerkennung',
        params: {
          'p_university_name': universityName,
          'p_university_country': universityCountry,
          'p_degree_field': degreeField,
        },
      );

      final needs = response as bool? ?? false;
      DebugLogger().log('✅ Needs Anerkennung: $needs');

      return needs;
    } catch (e, st) {
      DebugLogger().error('❌ Error checking Anerkennung', e, st);
      return false;
    }
  }

  /// Auto-populate derived fields when user answers key questions
  Future<Map<String, dynamic>> autoPopulateDerivedFields(
    String fieldKey,
    dynamic answer,
    Map<String, dynamic> allAnswers,
  ) async {
    final derivedFields = <String, dynamic>{};

    try {
      // Derive from profession
      if (fieldKey == 'profession' && answer != null) {
        final derived = await deriveFieldAttributes(profession: answer.toString());
        derivedFields.addAll(derived);
      }

      // Derive from degree field
      if (fieldKey == 'degree_field' && answer != null) {
        final derived = await deriveFieldAttributes(degreeField: answer.toString());
        derivedFields.addAll(derived);
      }

      // Derive from university (work context)
      if (fieldKey == 'university_name_work' && answer != null) {
        final details = await getUniversityDetails(answer.toString());
        derivedFields.addAll(details);

        // Check Anerkennung requirement
        final needsAnerk = await needsAnerkennung(
          universityName: answer.toString(),
          degreeField: allAnswers['degree_field']?.toString(),
        );
        derivedFields['anerkennung_required'] = needsAnerk;

        // Auto-set has_anerkennung to false if required (user needs to get it)
        if (needsAnerk && !allAnswers.containsKey('has_anerkennung')) {
          derivedFields['has_anerkennung'] = false;
        }
      }

      // Derive from university (education context)
      if (fieldKey == 'university_name_edu' && answer != null) {
        final details = await getUniversityDetails(answer.toString());
        derivedFields.addAll(details);
      }

      if (derivedFields.isNotEmpty) {
        DebugLogger().log('✅ Auto-populated ${derivedFields.length} derived fields');
      }
    } catch (e, st) {
      DebugLogger().error('❌ Error auto-populating derived fields', e, st);
    }

    return derivedFields;
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

  /// Fetch next questions with auto-derivation support
  Future<List<VisaQuestion>> getNextQuestions(
    String fieldKey,
    dynamic answer,
    List<String> answeredFields,
  ) async {
    try {
      DebugLogger().log('🔍 Fetching next questions for: $fieldKey = $answer');

      // Get all current answers including derived fields
      final allAnswers = _draft?.toJson() ?? {};

      // Add the current answer
      if (answer is Map<String, dynamic>) {
        allAnswers.addAll(answer);
      } else {
        allAnswers[fieldKey] = answer;
      }

      // Auto-populate derived fields
      final derivedFields = await autoPopulateDerivedFields(fieldKey, answer, allAnswers);

      // Merge derived fields into all answers
      allAnswers.addAll(derivedFields);

      // Update draft with derived fields
      if (derivedFields.isNotEmpty) {
        final updatedDraft = VisaQuestionnaire.fromJson(allAnswers);
        await saveDraft(updatedDraft);
      }

      String answerStr = _convertAnswerToString(answer);

      final response = await _supabase.rpc(
        'get_next_questions',
        params: {
          'p_field_key': fieldKey,
          'p_answer': answerStr,
          'p_answered_fields': answeredFields,
          'p_all_answers': allAnswers,
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
      final allQuestions = await _supabase
          .from('visa_questions')
          .select('field_key, required, category, purpose_filter')
          .eq('required', true);

      final requiredQuestions = (allQuestions as List)
          .where((q) {
            final purposeFilter = q['purpose_filter'] as List?;
            final userPurpose = data.purpose;

            if (purposeFilter == null || purposeFilter.isEmpty || userPurpose == null) {
              return q['category'] == 'universal';
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

    // Ensure all derived fields are populated before submission
    final allAnswers = data.toJson();

    // Derive field attributes if not already present
    if (allAnswers['profession'] != null &&
        (allAnswers['is_it_field'] == null ||
            allAnswers['is_healthcare'] == null ||
            allAnswers['is_engineer'] == null)) {
      final derived = await deriveFieldAttributes(profession: allAnswers['profession']?.toString());
      allAnswers.addAll(derived);
    }

    // Derive university details if not already present
    if (allAnswers['university_name_work'] != null && allAnswers['university_country'] == null) {
      final details = await getUniversityDetails(allAnswers['university_name_work'].toString());
      allAnswers.addAll(details);
    }

    if (allAnswers['university_name_edu'] != null && allAnswers['university_country'] == null) {
      final details = await getUniversityDetails(allAnswers['university_name_edu'].toString());
      allAnswers.addAll(details);
    }

    final response = await _supabase.functions.invoke(
      'visa-recommendation',
      body: allAnswers,
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

    final Map<String, dynamic> responseData = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    DebugLogger().log('📥 Received response: ${jsonEncode(responseData)}');

    return VisaRecommendationResponse.fromJson(responseData);
  }
}
