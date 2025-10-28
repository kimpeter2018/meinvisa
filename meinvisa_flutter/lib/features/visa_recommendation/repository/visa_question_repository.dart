import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';

class VisaQuestionRepository {
  final SupabaseClient _supabase;
  final Map<String, List<String>> _optionsCache = {};

  VisaQuestionRepository(this._supabase);

  /// Fetch all questions (with options) from Supabase
  Future<List<VisaQuestion>> getAllQuestions() async {
    final response = await _supabase
        .from('visa_question')
        .select('*')
        .order('category', ascending: true)
        .order('order_index', ascending: true);

    final questions = (response as List<dynamic>)
        .map((json) => VisaQuestion.fromJson(json as Map<String, dynamic>))
        .toList();

    // Fill options from optionsSource if needed
    final futures = questions.map((q) async {
      if (q.optionsSource != null && q.optionsSource!.isNotEmpty) {
        final opts = await getOptions(q.optionsSource!);
        return q.copyWith(options: opts);
      }
      return q;
    });

    return Future.wait(futures);
  }

  /// Option caching for Supabase lookup
  Future<List<String>> getOptions(String source) async {
    if (_optionsCache.containsKey(source)) return _optionsCache[source]!;

    List<String> result;
    switch (source) {
      case 'country':
        final data = await _supabase.from('country').select('name');
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
}
