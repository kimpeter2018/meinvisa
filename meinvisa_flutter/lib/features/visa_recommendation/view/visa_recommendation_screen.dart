// lib/features/visa_recommendation/view/visa_recommendation_screen.dart
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
      body: state.when(
        data: (_) {
          final currentQuestion = notifier.currentQuestion;
          final answers = notifier.answers;
          final totalAnswered = notifier.answeredFields.length;
          final answeredQuestions = notifier.answeredQuestionsList;

          return ProgressiveQuestionPage(
            answeredQuestions: answeredQuestions,
            currentQuestion: currentQuestion,
            answers: answers,
            totalAnswered: totalAnswered,
            onNext: (question, answer) async {
              await notifier.answerQuestion(question, answer);
            },
            onEdit: (question) async {
              notifier.editQuestion(question);
            },
            onComplete: () async {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              try {
                final result = await notifier.handleSubmit();

                if (context.mounted) {
                  // Close loading dialog
                  Navigator.of(context).pop();

                  // Navigate to result
                  context.pushReplacement(VisaResultScreen.routeName, extra: result);
                }
              } catch (e) {
                if (context.mounted) {
                  // Close loading dialog
                  Navigator.of(context).pop();

                  // Show error
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load: $e'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(visaRecommendationProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
