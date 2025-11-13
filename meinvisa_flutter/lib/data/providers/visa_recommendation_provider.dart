import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_recommendation_repository.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/features/visa_recommendation/view_model/visa_recommendation_viewmodel.dart';

/// ✅ Single repository provider
final visaRecommendationRepositoryProvider = Provider<VisaRecommendationRepository>((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  return VisaRecommendationRepository(userRepo);
});

/// ✅ Main async notifier for questionnaire + result
final visaRecommendationProvider =
    AutoDisposeAsyncNotifierProvider<VisaRecommendationNotifier, VisaQuestionnaire?>(
      VisaRecommendationNotifier.new,
    );
