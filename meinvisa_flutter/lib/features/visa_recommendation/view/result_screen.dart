import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';
import 'package:meinvisa/features/home/view/home_layout.dart';
import 'package:meinvisa/features/visa_application/view/application_review_screen.dart';

class VisaResultScreen extends StatelessWidget {
  static const routeName = '/visa-result';
  final VisaRecommendationResponse result;

  const VisaResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Visa Recommendation'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          onPressed: () => context.go(HomeLayout.routeName),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Success header
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_outline, size: 56, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Recommendation Ready!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We\'ve analyzed your profile and found the best visa options',
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Recommended visa
            _buildRecommendedVisa(context, result.recommended),

            const SizedBox(height: 24),

            // Alternative visas
            if (result.alternatives.isNotEmpty) ...[
              Text(
                'Alternative Options',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...result.alternatives.map((alt) => _buildAlternativeVisa(context, alt)),
            ],

            const SizedBox(height: 24),

            // General notes
            if (result.notes.isNotEmpty) ...[
              Text(
                'Important Notes',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildNotesCard(context, result.notes),
            ],

            const SizedBox(height: 32),

            // Action buttons
            FilledButton.icon(
              onPressed: () {
                context.push(ApplicationReviewScreen.routeName, extra: result);
              },
              icon: const Icon(Icons.assignment_outlined),
              label: const Text('Start Application Process'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () => context.go(HomeLayout.routeName),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Back to Home'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedVisa(BuildContext context, VisaOption visa) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.green[300]!, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.green[700]),
                      const SizedBox(width: 6),
                      Text(
                        'RECOMMENDED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(visa.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              visa.code.toUpperCase(),
              style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 18),
            Text(
              visa.summary.split('\n').first,
              style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5),
            ),
            if (visa.requirements!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              ...visa.requirements!.map(
                (req) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        req.startsWith('✓') ? Icons.check_circle : Icons.warning_amber,
                        size: 20,
                        color: req.startsWith('✓') ? Colors.green[600] : Colors.orange[600],
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(req, style: const TextStyle(fontSize: 14, height: 1.4))),
                    ],
                  ),
                ),
              ),
            ],
            if (visa.notes!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...visa.notes!.map(
                      (note) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          note,
                          style: TextStyle(fontSize: 13, color: Colors.blue[900], height: 1.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeVisa(BuildContext context, VisaOption visa) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(visa.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              visa.code.toUpperCase(),
              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visa.summary.split('\n').first,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
                  ),
                  if (visa.requirements!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    ...visa.requirements!.map(
                      (req) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $req', style: const TextStyle(fontSize: 13)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, List<String> notes) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: notes
              .map(
                (note) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, size: 20, color: Colors.amber[700]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(note, style: const TextStyle(fontSize: 14, height: 1.4)),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
