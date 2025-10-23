import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/view/name_screen.dart';
import 'package:meinvisa/features/visa_recommendation/view/nationality_screen.dart';
import 'package:meinvisa/features/visa_recommendation/view/occupation_screen.dart';
import 'package:meinvisa/features/visa_recommendation/view/result_screen.dart';
import 'package:meinvisa/features/visa_recommendation/view/salary_recognition_page.dart';

class VisaRecommendationScreen extends ConsumerStatefulWidget {
  static const routeName = '/visa-recommendation';

  const VisaRecommendationScreen({super.key});

  @override
  ConsumerState<VisaRecommendationScreen> createState() =>
      _VisaRecommendationScreenState();
}

class _VisaRecommendationScreenState
    extends ConsumerState<VisaRecommendationScreen> {
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
      await _submitVisaData();
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

  Future<void> _submitVisaData() async {
    final response = await ref
        .read(visaRecommendationProvider.notifier)
        .handleSubmit();
    if (mounted) {
      context.pushReplacement(VisaResultScreen.routeName, extra: response);
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevPage,
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
                  PassportNamePage(
                    onNext: () {
                      _nextPage();
                    },
                  ),
                  OccupationPage(onNext: _nextPage),
                  NationalityPage(
                    onNext: (String? countryCode) {
                      _nextPage();
                    },
                  ),
                  SalaryRecognitionPage(onNext: _nextPage),
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
  }
}
