import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/onboarding_provider.dart';
import 'package:meinvisa/features/home/view/home_layout.dart';
import 'package:meinvisa/features/onboarding/view/name_screen.dart';
import 'package:meinvisa/features/onboarding/view/nationality_screen.dart';
import 'package:meinvisa/features/onboarding/view/occupation_screen.dart';
import 'package:meinvisa/features/onboarding/view/purpose_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  static const routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final int _totalPages = 4;

  Future<void> _nextPage() async {
    if (_currentIndex.value < _totalPages - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) {
      context.pushReplacementNamed(HomeLayout.routeName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  Widget _buildPageIndicator() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _totalPages,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: value == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: value == index ? Colors.blue : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingAsync = ref.watch(onboardingProvider);

    return onboardingAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) => _currentIndex.value = index,
                    children: [
                      PassportNamePage(
                        onNext: (value) async {
                          await ref
                              .read(onboardingProvider.notifier)
                              .updateName(value);
                          _nextPage();
                        },
                      ),
                      PassportNationalityPage(
                        onNext: (value) async {
                          await ref
                              .read(onboardingProvider.notifier)
                              .updateNationality(value ?? '');
                          _nextPage();
                        },
                      ),
                      OccupationPage(
                        onNext: (value) async {
                          await ref
                              .read(onboardingProvider.notifier)
                              .updateOccupation(value ?? '');
                          _nextPage();
                        },
                      ),
                      PurposeOfStayPage(
                        onNext: (value) async {
                          await ref
                              .read(onboardingProvider.notifier)
                              .updatePurpose(value ?? '');
                          _nextPage();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildPageIndicator(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
