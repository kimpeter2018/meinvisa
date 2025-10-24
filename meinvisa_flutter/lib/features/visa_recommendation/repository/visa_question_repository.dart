import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VisaQuestionRepository {
  final SupabaseClient _supabase;

  VisaQuestionRepository(this._supabase);

  /// Fetch all questions ordered by category and index
  Future<List<VisaQuestion>> getAllQuestions() async {
    try {
      final response = await _supabase
          .from('visa_question')
          .select('*')
          .order('category', ascending: true)
          .order('order_index', ascending: true);

      return (response as List<dynamic>)
          .map((json) => VisaQuestion.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch visa questions.');
    }
  }

  /// Fetch questions filtered by category (e.g., "personal_info", "education")
  Future<List<VisaQuestion>> getQuestionsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('visa_question')
          .select('*')
          .eq('category', category)
          .order('order_index', ascending: true);

      return (response as List<dynamic>)
          .map((json) => VisaQuestion.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch visa questions for category $category.');
    }
  }

  /// Fetch a single question by field key
  Future<VisaQuestion?> getQuestionByFieldKey(String fieldKey) async {
    final response = await _supabase
        .from('visa_question')
        .select('*')
        .eq('field_key', fieldKey)
        .maybeSingle();

    if (response == null) return null;

    return VisaQuestion.fromJson(response);
  }

  /// Optional: cache locally (you can integrate SharedPreferences later)
  /// so that if offline, questions still show up.
}
