import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/user_provider.dart';
import 'package:meinvisa/features/home/view/home_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      await _completeOnboarding();
    }
  }

  Future<void> _prevPage() async {
    if (_currentIndex.value > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final user = ref.read(userProvider).value;

    final prefs = await SharedPreferences.getInstance();
    final userId = user!.id;

    await prefs.setBool('onboarding_completed_$userId', true);

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
                color: value == index ? Colors.black : Colors.grey.shade400,
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
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (context, value, _) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: value > 0 ? _prevPage : null,
                );
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) => _currentIndex.value = index,
                    children: [
                      // Page 1
                      Center(
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          child: const Text('Next'),
                        ),
                      ),
                      // Page 2
                      Center(
                        child: ElevatedButton(
                          onPressed: _completeOnboarding,
                          child: const Text('Complete'),
                        ),
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
