// lib/features/visa_recommendation/view/visa_recommendation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/data/providers/visa_recommendation_storage_provider.dart';
import 'package:meinvisa/features/visa_recommendation/view/progressive_question_page.dart';
import 'package:meinvisa/features/visa_recommendation/view/result_screen.dart';

class VisaRecommendationScreen extends ConsumerStatefulWidget {
  static const routeName = '/visa-recommendation';

  const VisaRecommendationScreen({super.key});

  @override
  ConsumerState<VisaRecommendationScreen> createState() => _VisaRecommendationScreenState();
}

class _VisaRecommendationScreenState extends ConsumerState<VisaRecommendationScreen> {
  Future<bool> _handleExit() async {
    final notifier = ref.read(visaRecommendationProvider.notifier);
    final repo = ref.read(visaRecommendationRepositoryProvider);

    // Check if there are pending changes
    final hasPending = await repo.hasPendingChanges();

    if (!hasPending) {
      return true; // No pending changes, allow exit
    }

    // Show save dialog
    if (!mounted) return false;

    final shouldSave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.save_outlined, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            const Text('Save Your Progress?'),
          ],
        ),
        content: const Text(
          'You have unsaved changes. Would you like to save your progress?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Save')),
        ],
      ),
    );

    if (shouldSave == null) {
      return false; // User cancelled - stay on page
    }

    if (shouldSave) {
      // Save progress
      try {
        final draft = repo.getDraft();
        if (draft != null) {
          await repo.saveDraft(draft);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Progress saved'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error saving: $e'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    } else {
      // Discard progress
      await notifier.clearDraft();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Progress discarded'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(visaRecommendationProvider.notifier);
    final state = ref.watch(visaRecommendationProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _handleExit();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },
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
                  final result = await notifier.handleSubmit();

                  // Store the result
                  await ref
                      .read(visaRecommendationStorageProvider.notifier)
                      .saveRecommendation(result);

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
