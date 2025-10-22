// lib/features/visa_recommendation/repository/visa_recommendation_repository.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VisaRecommendationRepository {
  final UserRepository _userRepository;
  final SupabaseClient _supabase = Supabase.instance.client;

  VisaQuestionnaire? _draft;

  VisaRecommendationRepository(this._userRepository);

  /// Returns the current draft questionnaire
  VisaQuestionnaire? getDraft() => _draft;

  /// Saves questionnaire progress temporarily in memory
  Future<void> saveDraft(VisaQuestionnaire data) async {
    _draft = data;
  }

  /// Calls the Supabase Edge Function to filter eligible visas
  Future<VisaEligibilityResult> filterVisa() async {
    if (_draft == null) {
      throw Exception("No questionnaire data available.");
    }

    final response = await _supabase.functions.invoke(
      'visa-eligibility',
      body: _draft!.toJson(),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['SUPABASE_FUNCTION_KEY']}',
      },
    );
    // Handle status-based errors
    if (response.status >= 400) {
      final details = response.data?.toString();
      throw FunctionException(
        status: response.status,
        details: details ?? 'Unknown error',
        reasonPhrase: 'Function returned an error',
      );
    }

    // Handle missing data
    if (response.data == null) {
      throw Exception("Empty response from visa eligibility function.");
    }

    // Parse success response
    return VisaEligibilityResult.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// Clears the current questionnaire draft
  void clearDraft() => _draft = null;
}
