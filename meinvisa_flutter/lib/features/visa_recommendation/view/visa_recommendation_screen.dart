import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/visa_recommendation/view/progressive_question_page.dart';
import 'package:meinvisa/features/visa_recommendation/view/result_screen.dart';
import 'package:meinvisa/features/visa_recommendation/widgets/draft_save_dialog.dart';

class VisaRecommendationScreen extends ConsumerStatefulWidget {
  static const routeName = '/visa-recommendation';

  const VisaRecommendationScreen({super.key});

  @override
  ConsumerState<VisaRecommendationScreen> createState() => _VisaRecommendationScreenState();
}

class _VisaRecommendationScreenState extends ConsumerState<VisaRecommendationScreen> {
  bool _isExiting = false;

  Future<bool> _handleWillPop() async {
    if (_isExiting) return true;

    final notifier = ref.read(visaRecommendationProvider.notifier);
    final repo = ref.read(visaRecommendationRepositoryProvider);

    // Check if there are pending changes
    final hasPending = await repo.hasPendingChanges();

    if (!hasPending) {
      return true; // No pending changes, allow exit
    }

    // Show dialog
    if (!mounted) return false;

    final action = await DraftSaveDialog.show(context);

    if (action == null) {
      return false; // User cancelled
    }

    setState(() => _isExiting = true);

    try {
      switch (action) {
        case DraftAction.saveToCloud:
          // Show loading
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
          }

          // Sync to Supabase
          await repo.syncToSupabase();

          if (mounted) {
            Navigator.of(context).pop(); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Progress saved to cloud'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return true;

        case DraftAction.saveLocal:
          // Already saved locally, just exit
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Progress saved locally'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return true;

        case DraftAction.discard:
          // Clear draft
          notifier.clearDraft();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🗑️ Progress discarded'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return true;
      }
    } catch (e) {
      setState(() => _isExiting = false);

      if (mounted) {
        // Close loading dialog if open
        Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(visaRecommendationProvider.notifier);
    final state = ref.watch(visaRecommendationProvider);

    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
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
                  // Sync to cloud before submitting
                  await ref.read(visaRecommendationRepositoryProvider).syncToSupabase();

                  final result = await notifier.handleSubmit();

                  if (mounted) {
                    // Close loading dialog
                    Navigator.of(context).pop();

                    // Navigate to result
                    context.pushReplacement(VisaResultScreen.routeName, extra: result);
                  }
                } catch (e) {
                  if (mounted) {
                    // Close loading dialog
                    Navigator.of(context).pop();

                    // Show error
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
      ),
    );
  }
}
