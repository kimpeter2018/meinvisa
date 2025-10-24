import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/providers/visa_question_provider.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/view/result_screen.dart';
import 'package:meinvisa/features/visa_recommendation/widgets/dynamic_question_page.dart';

class VisaRecommendationScreen extends ConsumerStatefulWidget {
  static const routeName = '/visa-recommendation';

  const VisaRecommendationScreen({super.key});

  @override
  ConsumerState<VisaRecommendationScreen> createState() =>
      _VisaRecommendationScreenState();
}

class _VisaRecommendationScreenState
    extends ConsumerState<VisaRecommendationScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  late List<List<VisaQuestion>> _pages;

  @override
  void initState() {
    super.initState();
    final questions = ref
        .read(visaRecommendationRepositoryProvider)
        .getQuestions();

    _pages = _groupQuestionsByCategory(questions);
  }

  List<List<VisaQuestion>> _groupQuestionsByCategory(List<VisaQuestion> all) {
    final Map<String, List<VisaQuestion>> grouped = {};
    for (final q in all) {
      grouped.putIfAbsent(q.category, () => []).add(q);
    }
    return grouped.values.toList();
  }

  Future<void> _nextPage() async {
    if (_currentIndex.value < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _submitVisaData();
    }
  }

  Future<void> _prevPage() async {
    if (_currentIndex.value > 0) {
      _pageController.previousPage(
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
    _pageController.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  Widget _buildPageIndicator() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _pages.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: i == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == index ? Colors.black : Colors.grey.shade400,
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
        title: const Text('Visa Recommendation'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => _currentIndex.value = i,
                itemCount: _pages.length,
                itemBuilder: (context, i) {
                  final questions = _pages[i];
                  return DynamicQuestionPage(
                    questions: questions,
                    onAnswer: (id, value) {
                      ref
                          .read(visaRecommendationProvider.notifier)
                          .updateAnswer(id, value);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildPageIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 16,
                ),
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: _currentIndex,
                builder: (context, i, _) =>
                    Text(i == _pages.length - 1 ? 'Submit' : 'Next'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
