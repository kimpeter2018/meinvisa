import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';

class OccupationPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  const OccupationPage({super.key, required this.onNext});

  @override
  ConsumerState<OccupationPage> createState() => _OccupationPageState();
}

class _OccupationPageState extends ConsumerState<OccupationPage> {
  String? _selectedOccupation;
  String _searchQuery = '';

  final List<String> occupations = [
    'Software Developer',
    'Nurse',
    'Engineer',
    'Teacher',
    'Chef',
    'Doctor',
    'Designer',
    'Scientist',
    'Manager',
  ];

  void _showOccupationPicker() {
    final filtered = occupations
        .where((occ) => occ.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search occupation',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) => setModalState(() {
                      _searchQuery = val;
                    }),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final occ = filtered[index];
                        return ListTile(
                          title: Text(occ),
                          onTap: () {
                            setState(() => _selectedOccupation = occ);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select your occupation', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showOccupationPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedOccupation ?? 'Select your occupation',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedOccupation == null
                          ? Colors.grey.shade600
                          : Colors.black,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _selectedOccupation == null
                ? null
                : () {
                    final notifier = ref.read(
                      visaRecommendationProvider.notifier,
                    );

                    final draft =
                        notifier.getDraft() ??
                        const VisaQuestionnaire(
                          occupationCode: '',
                          nationality: '',
                        );

                    notifier.saveUserResponse(
                      draft.copyWith(occupationCode: _selectedOccupation!),
                    );

                    widget.onNext();
                  },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
