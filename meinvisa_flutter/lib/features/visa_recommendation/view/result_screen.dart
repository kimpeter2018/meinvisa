import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/models/visa_eligibility_result_model/visa_eligibility_result_model.dart';

class VisaResultScreen extends StatelessWidget {
  static const routeName = '/visa-result';
  final VisaEligibilityResult result;

  const VisaResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final bestVisa = result.eligibleVisas.isNotEmpty
        ? result.eligibleVisas.first
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Visa Recommendation Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bestVisa == null
            ? _buildNoVisaFound(context)
            : _buildVisaResult(context, bestVisa, result.eligibleVisas),
      ),
    );
  }

  Widget _buildNoVisaFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            'No suitable visa found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            result.ineligibleReasons.join('\n'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildVisaResult(
    BuildContext context,
    EligibleVisa bestVisa,
    List<EligibleVisa> allVisas,
  ) {
    final alternativeVisas = allVisas.skip(1).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Matching Visa',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bestVisa.visaType,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(bestVisa.reason),
                  const SizedBox(height: 12),
                  if (bestVisa.nextSteps != null &&
                      bestVisa.nextSteps!.isNotEmpty) ...[
                    const Text(
                      'What to Prepare:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final step in bestVisa.nextSteps!) Text('• $step'),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    onPressed: () => context.go('/apply/${bestVisa.visaType}'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Apply for this Visa'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (alternativeVisas.isNotEmpty) ...[
            Text(
              'Alternative Visas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            for (final visa in alternativeVisas)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(visa.visaType),
                  subtitle: Text(visa.reason),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => context.go('/apply/${visa.visaType}'),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
