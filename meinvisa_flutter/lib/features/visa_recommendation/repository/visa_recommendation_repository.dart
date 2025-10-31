import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_question_path_model/visa_question_path_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VisaRecommendationRepository {
  final UserRepository _userRepository;
  final Map<String, List<String>> _optionsCache = {};
  final SupabaseClient _supabase = Supabase.instance.client;

  VisaQuestionnaire? _draft;

  VisaRecommendationRepository(this._userRepository);

  /// ✅ Return the in-memory draft
  VisaQuestionnaire? getDraft() => _draft;

  /// ✅ Save a draft
  Future<void> saveDraft(VisaQuestionnaire data) async {
    _draft = data;
  }

  Future<List<VisaQuestion>> getAllQuestions() async {
    final response = await _supabase
        .from('visa_questions')
        .select('*')
        .order('category', ascending: true)
        .order('order_index', ascending: true);

    final questions = (response as List<dynamic>)
        .map((json) => VisaQuestion.fromJson(json as Map<String, dynamic>))
        .toList();

    final futures = questions.map((q) async {
      if (q.optionsSource != null && q.optionsSource!.isNotEmpty) {
        final opts = await getOptions(q.optionsSource!);
        return q.copyWith(options: opts);
      }
      return q;
    });

    return Future.wait(futures);
  }

  Future<List<VisaQuestionPath>> getAllQuestionPaths() async {
    final response = await _supabase
        .from('visa_question_path')
        .select('*')
        .order('id', ascending: true);

    return (response as List<dynamic>)
        .map((json) => VisaQuestionPath.fromJson(json))
        .toList();
  }

  Future<List<String>> getOptions(String source) async {
    if (_optionsCache.containsKey(source)) return _optionsCache[source]!;

    List<String> result;

    switch (source) {
      case 'countries':
        final data = await _supabase.from('countries').select('name');
        result = (data as List).map((e) => e['name'] as String).toList();
        break;
      case 'occupation':
        final data = await _supabase.from('occupation').select('title');
        result = (data as List).map((e) => e['title'] as String).toList();
        break;
      default:
        result = [];
    }

    _optionsCache[source] = result;
    return result;
  }

  /// ✅ Submit final answers to Edge Function
  Future<VisaEligibilityResult> filterVisa(VisaQuestionnaire data) async {
    DebugLogger().log('Submitting Visa Questionnaire: ${data.toJson()}');

    final response = await _supabase.functions.invoke(
      'visa-filter',
      body: data.toJson(),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['SUPABASE_FUNCTION_KEY']}',
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

  /// ✅ Clear draft
  void clearDraft() => _draft = null;
}
