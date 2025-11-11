// lib/features/home/view/home_screen.dart (updated section)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/user_provider.dart';
import 'package:meinvisa/data/providers/visa_recommendation_storage_provider.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';
import 'package:meinvisa/features/home/widgets/quick_action_card.dart';
import 'package:meinvisa/features/home/widgets/visa_card.dart';
import 'package:meinvisa/features/visa_recommendation/view/result_screen.dart';
import 'package:meinvisa/features/visa_recommendation/view/visa_recommendation_screen.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _handleNewVisaCheck(BuildContext context, WidgetRef ref) async {
    final hasRecommendation = ref.read(visaRecommendationStorageProvider).value != null;

    if (hasRecommendation) {
      // Show dialog asking if they want to start a new process
      final shouldStart = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Start New Recommendation?'),
          content: const Text(
            'You already have a visa recommendation. Starting a new one will replace your current results. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Start New'),
            ),
          ],
        ),
      );

      if (shouldStart != true) return;

      // Clear existing recommendation
      await ref.read(visaRecommendationStorageProvider.notifier).clearRecommendation();
      
      // Also clear any draft data
      await ref.read(visaRecommendationProvider.notifier).clearDraft();
    }

    if (context.mounted) {
      context.push(VisaRecommendationScreen.routeName);
    }
  }

  Future<void> _handleClearDraft(BuildContext context, WidgetRef ref) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Draft?'),
        content: const Text(
          'This will delete all your saved progress. This action cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldClear != true) return;

    // Show loading
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      // Clear the draft
      await ref.read(visaRecommendationProvider.notifier).clearDraft();
      
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Draft cleared successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewRecommendation(BuildContext context, WidgetRef ref) {
    final recommendation = ref.read(visaRecommendationStorageProvider).value;
    if (recommendation != null) {
      context.push(VisaResultScreen.routeName, extra: recommendation);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final recommendationAsync = ref.watch(visaRecommendationStorageProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(visaRecommendationStorageProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Greeting Section
          userAsync.when(
            data: (user) => _buildGreetingSection(user?.name),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 28),

          // Quick Actions
          _buildQuickActionsSection(context, ref),

          const SizedBox(height: 32),

          // Recommendation Results Section
          recommendationAsync.when(
            data: (recommendation) {
              if (recommendation != null) {
                return _buildRecommendationSection(context, ref, recommendation);
              }
              return _buildEmptyRecommendationState(context, ref);
            },
            loading: () => const Center(
              child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(String? firstName) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;

    if (hour < 12) {
      greeting = 'Good Morning';
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (hour < 18) {
      greeting = 'Good Afternoon';
      greetingIcon = Icons.wb_sunny;
    } else {
      greeting = 'Good Evening';
      greetingIcon = Icons.nightlight_outlined;
    }

    final displayName = firstName ?? 'there';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(greetingIcon, size: 28, color: Colors.amber[700]),
            const SizedBox(width: 8),
            Text(
              greeting,
              style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back, $displayName',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            QuickActionCard(
              icon: Icons.explore_outlined,
              label: 'New Visa Check',
              onTap: () => _handleNewVisaCheck(context, ref),
            ),
            QuickActionCard(
              icon: Icons.delete_outline,
              label: 'Clear Draft',
              onTap: () => _handleClearDraft(context, ref),
            ),
            QuickActionCard(
              icon: Icons.assignment_outlined,
              label: 'Track Application',
              onTap: () {},
            ),
            QuickActionCard(icon: Icons.alarm_outlined, label: 'Termin Alerts', onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyRecommendationState(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[50]!, Colors.purple[50]!],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.rocket_launch_outlined, size: 64, color: Colors.blue[700]),
          const SizedBox(height: 16),
          const Text(
            'Start Your Visa Journey',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Get personalized visa recommendations based on your profile',
            style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _handleNewVisaCheck(context, ref),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Get Started'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection(BuildContext context, WidgetRef ref, dynamic recommendation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _handleNewVisaCheck(context, ref),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('New Check'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Recommended Visa (Primary)
        VisaCard(
          title: recommendation.recommended.name,
          description: recommendation.recommended.summary,
          isPrimary: true,
          confidence: _extractConfidence(recommendation.recommended.summary),
          onApply: () => _viewRecommendation(context, ref),
        ),

        // Alternative Visas
        if (recommendation.alternatives.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...recommendation.alternatives.map((alt) {
            return VisaCard(
              title: alt.name,
              description: alt.summary,
              isPrimary: false,
              confidence: _extractConfidence(alt.summary),
              onApply: () => _viewRecommendation(context, ref),
            );
          }),
        ],

        // View Full Details Button
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => _viewRecommendation(context, ref),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('View Full Details'),
        ),
      ],
    );
  }

  String _extractConfidence(String summary) {
    final confidenceMatch = RegExp(r'Confidence:\s*(\w+)').firstMatch(summary);
    return confidenceMatch?.group(1) ?? 'Unknown';
  }
}