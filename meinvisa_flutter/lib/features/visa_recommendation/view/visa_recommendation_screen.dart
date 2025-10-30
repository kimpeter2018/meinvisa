import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/view/progressive_question_page.dart';
import 'package:meinvisa/features/visa_recommendation/view/result_screen.dart';

class VisaRecommendationScreen extends ConsumerWidget {
  static const routeName = '/visa-recommendation';

  const VisaRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(visaRecommendationProvider.notifier);
    final state = ref.watch(visaRecommendationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visa Recommendation'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: state.when(
        data: (questionnaire) {
          final queue = notifier.queue;
          final answers = notifier.answers;

          if (queue.isEmpty) {
            return const Center(
              child: Text('No questions available at this time.'),
            );
          }

          return ProgressiveQuestionPage(
            questions: queue,
            initialAnswers: answers,
            onNext: (answers) async {
              // Save current question answers progressively
              final q = queue.isNotEmpty ? queue.first : null;
              if (q != null && answers.containsKey(q.fieldKey)) {
                await notifier.answerQuestion(q, answers[q.fieldKey]);
              }

              // If queue is empty after this answer → submit
              if (notifier.queue.isEmpty) {
                final result = await notifier.handleSubmit();
                if (context.mounted) {
                  context.pushReplacement(
                    VisaResultScreen.routeName,
                    extra: result,
                  );
                }
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Failed to load questionnaire: $e')),
      ),
    );
  }
}
