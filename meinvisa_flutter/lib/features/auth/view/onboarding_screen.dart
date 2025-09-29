import 'package:echad/features/auth/view/onboarding_examples.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  String? name;
  String? avatarUrl;
  String? bio;

  int _currentIndex = 0;

  void _nextPage() {
    if (_currentIndex < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    // TODO: Create UserModel and upload to Supabase
    // final userId = Supabase.instance.client.auth.currentUser!.id;

    // final user = UserModel(
    //   id: userId,
    //   email: Supabase.instance.client.auth.currentUser!.email!,
    //   name: name,
    //   avatarUrl: avatarUrl,
    //   createdAt: DateTime.now(),
    // );

    // await Supabase.instance.client.from('users').insert(user.toJson());

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          NamePage(
            onNext: (value) {
              name = value;
              _nextPage();
            },
          ),
          AvatarPage(
            onNext: (value) {
              avatarUrl = value;
              _nextPage();
            },
          ),
          BioPage(
            onNext: (value) {
              bio = value;
              _nextPage();
            },
          ),
        ],
      ),
    );
  }
}
