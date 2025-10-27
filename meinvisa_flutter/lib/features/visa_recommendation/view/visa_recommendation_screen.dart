import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/providers/visa_question_provider.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/view/result_screen.dart';
import 'package:meinvisa/features/visa_recommendation/view/dynamic_question_page.dart';

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
  void dispose() {
    _pageController.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  List<List<VisaQuestion>> _groupQuestionsByCategory(
    List<VisaQuestion> all,
    Map<String, dynamic> answers,
  ) {
    final Map<String, List<VisaQuestion>> grouped = {};

    final filtered = _filterQuestions(all, answers);

    for (final q in filtered) {
      grouped.putIfAbsent(q.category, () => []).add(q);
    }
    return grouped.values.toList();
  }

  List<VisaQuestion> _filterQuestions(
    List<VisaQuestion> all,
    Map<String, dynamic> answers,
  ) {
    return all.where((q) {
      if (q.parentCondition == null || q.parentCondition!.isEmpty) {
        return true; // always include top-level questions
      }

      // Example format: "purpose_of_stay=Work"
      final parts = q.parentCondition!.split('=');
      if (parts.length != 2) return true;

      final field = parts[0];
      final expected = parts[1];

      return answers[field]?.toString() == expected;
    }).toList();
  }

  Widget _buildPageIndicator() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (_, index, __) {
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
    final notifier = ref.read(visaRecommendationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentIndex.value > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Visa Recommendation'),
        centerTitle: true,
      ),
      body: ref
          .watch(visaQuestionsProvider)
          .when(
            data: (questions) {
              _pages = _groupQuestionsByCategory(questions);

              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _pages.length,
                      onPageChanged: (i) => _currentIndex.value = i,
                      itemBuilder: (_, pageIndex) {
                        final pageQuestions = _pages[pageIndex];
                        final draft = notifier.getDraft()?.toJson();

                        return DynamicQuestionPage(
                          questions: pageQuestions,
                          initialAnswers: draft,
                          onNext: (answers) async {
                            final questionnaire = VisaQuestionnaire.fromJson(
                              answers,
                            );
                            await notifier.saveUserResponse(questionnaire);

                            // recompute pages dynamically
                            final draft = notifier.getDraft()?.toJson() ?? {};
                            _pages = _groupQuestionsByCategory(
                              questions,
                              draft,
                            );

                            if (_currentIndex.value < _pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              final result = await notifier.handleSubmit();
                              context.pushReplacement(
                                VisaResultScreen.routeName,
                                extra: result,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPageIndicator(),
                  const SizedBox(height: 24),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Failed to load questions: $e')),
          ),
    );
  }
}
