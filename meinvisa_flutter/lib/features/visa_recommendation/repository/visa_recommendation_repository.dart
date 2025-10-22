import 'package:meinvisa/data/models/user_model.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';

/// Handles temporary user draft during onboarding
class VisaRecommendationRepository {
  final UserRepository _userRepository;
  UserModel? _draft;

  VisaRecommendationRepository(this._userRepository);

  UserModel? getDraft() => _draft;

  Future<void> saveDraft(UserModel user) async {
    _draft = user;
  }

  // /// Persist the updated user to Supabase
  // Future<void> completeOnboarding(UserModel user) async {
  //   await _userRepository.updateUser(user);
  //   _draft = null;
  // }

  // TODO: Implement method to handle final submission of visa recommendation data
  Future<void> filterVisa() async {
    // if (_draft != null) {
    //   await _userRepository.updateUser(_draft!);
    //   _draft = null;
    // }
  }

  void clearDraft() {
    _draft = null;
  }
}
