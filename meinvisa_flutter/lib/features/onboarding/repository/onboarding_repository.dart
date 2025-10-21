import 'package:meinvisa/data/models/user_model.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';

/// Handles temporary user draft during onboarding
class OnboardingRepository {
  final UserRepository _userRepository;
  UserModel? _draft;

  OnboardingRepository(this._userRepository);

  UserModel? getDraft() => _draft;

  Future<void> saveDraft(UserModel user) async {
    _draft = user;
  }

  /// Persist the updated user to Supabase
  Future<void> completeOnboarding(UserModel user) async {
    await _userRepository.updateUser(user);
    _draft = null; // clear temporary draft
  }

  void clearDraft() {
    _draft = null;
  }
}
