import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:meinvisa/data/models/user_model/user_model.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_recommendation_repository.dart';
import 'package:meinvisa/features/visa_recommendation/view_model/visa_recommendation_viewmodel.dart';

/// Provides the visaRecommendation repository (depends on UserRepository)
final visaRecommendationRepositoryProvider =
    Provider<VisaRecommendationRepository>((ref) {
      final userRepo = ref.read(userRepositoryProvider);
      return VisaRecommendationRepository(userRepo);
    });

/// Main VisaRecommendation state provider
final visaRecommendationProvider =
    AutoDisposeAsyncNotifierProvider<VisaRecommendationNotifier, UserModel?>(
      VisaRecommendationNotifier.new,
    );
