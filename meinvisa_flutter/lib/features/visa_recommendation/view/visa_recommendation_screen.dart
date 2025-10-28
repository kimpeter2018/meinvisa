import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/providers/visa_question_provider.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/view/progressive_question_page.dart';
import 'package:meinvisa/features/visa_recommendation/view/result_screen.dart';

class VisaRecommendationScreen extends ConsumerStatefulWidget {
  static const routeName = '/visa-recommendation';
  const VisaRecommendationScreen({super.key});

  @override
  ConsumerState<VisaRecommendationScreen> createState() =>
      _VisaRecommendationScreenState();
}

class _VisaRecommendationScreenState
    extends ConsumerState<VisaRecommendationScreen> {
  late List<VisaQuestion> _questions;
  late Map<String, dynamic> _draftAnswers;

  @override
  void initState() {
    super.initState();
    _questions = [];
    _draftAnswers = {};
  }

  List<VisaQuestion> _filterQuestions(
    List<VisaQuestion> all,
    Map<String, dynamic> answers,
  ) {
    final purpose = answers['purpose_of_stay'];

    return all.where((q) {
      if (q.category == 'purpose') return true;
      if (q.parentCondition == null || q.parentCondition!.isEmpty) return false;

      // Handle IN condition
      if (q.parentCondition!.contains('IN')) {
        final match = RegExp(
          r'purpose_of_stay IN \((.+)\)',
        ).firstMatch(q.parentCondition!);
        if (match != null) {
          final list = match
              .group(1)!
              .replaceAll('"', '')
              .split(',')
              .map((e) => e.trim())
              .toList();
          return purpose != null && list.contains(purpose);
        }
      }

      // Handle exact match
      final parts = q.parentCondition!.split('=');
      if (parts.length != 2) return true;
      final field = parts[0].trim();
      final expected = parts[1].trim();
      return answers[field]?.toString() == expected;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(visaRecommendationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Visa Recommendation'),
        centerTitle: true,
      ),
      body: ref
          .watch(visaQuestionsProvider)
          .when(
            data: (allQuestions) {
              // Load draft answers
              _draftAnswers = notifier.getDraft()?.toJson() ?? {};
              // Filter questions dynamically based on answers
              _questions = _filterQuestions(allQuestions, _draftAnswers);

              return ProgressiveQuestionPage(
                questions: _questions,
                initialAnswers: _draftAnswers,
                onNext: (answers) async {
                  // Save user responses
                  final questionnaire = VisaQuestionnaire.fromJson(answers);
                  await notifier.saveUserResponse(questionnaire);

                  // Re-filter questions dynamically if any crucial answers changed
                  _draftAnswers = notifier.getDraft()?.toJson() ?? {};
                  _questions = _filterQuestions(allQuestions, _draftAnswers);

                  // Check if we should submit (all answered)
                  final allAnswered = _questions.every(
                    (q) =>
                        !q.required ||
                        (_draftAnswers[q.id] != null &&
                            (_draftAnswers[q.id] is! String ||
                                (_draftAnswers[q.id] as String).isNotEmpty) &&
                            (_draftAnswers[q.id] is! List ||
                                (_draftAnswers[q.id] as List).isNotEmpty)),
                  );

                  if (allAnswered) {
                    final result = await notifier.handleSubmit();
                    context.pushReplacement(
                      VisaResultScreen.routeName,
                      extra: result,
                    );
                  }
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Failed to load questions: $e')),
          ),
    );
  }
}
