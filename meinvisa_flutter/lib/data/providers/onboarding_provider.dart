import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:meinvisa/data/models/user_model.dart';
import 'package:meinvisa/features/onboarding/repository/onboarding_repository.dart';
import 'package:meinvisa/features/onboarding/viewmodel/onboarding_viewmodel.dart';

/// Provides the onboarding repository (depends on UserRepository)
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  return OnboardingRepository(userRepo);
});

/// Main onboarding state provider
final onboardingProvider =
    AutoDisposeAsyncNotifierProvider<OnboardingNotifier, UserModel?>(
      OnboardingNotifier.new,
    );
