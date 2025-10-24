// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';
// import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';

// class SalaryRecognitionPage extends ConsumerStatefulWidget {
//   final VoidCallback onNext;
//   const SalaryRecognitionPage({super.key, required this.onNext});

//   @override
//   ConsumerState<SalaryRecognitionPage> createState() =>
//       _SalaryRecognitionPageState();
// }

// class _SalaryRecognitionPageState extends ConsumerState<SalaryRecognitionPage> {
//   double _salary = 20000;
//   bool _hasRecognition = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const Text('Current Salary', style: TextStyle(fontSize: 20)),
//           Slider(
//             min: 20000,
//             max: 200000,
//             divisions: 36,
//             label: _salary.toStringAsFixed(0),
//             value: _salary,
//             onChanged: (val) => setState(() => _salary = val),
//           ),

//           Text('Salary: \$${_salary?.toStringAsFixed(0) ?? '0'}'),
//           const SizedBox(height: 24),
//           CheckboxListTile(
//             title: const Text('Do you have professional recognition?'),
//             value: _hasRecognition,
//             onChanged: (val) => setState(() => _hasRecognition = val ?? false),
//           ),
//           const Spacer(),
//           ElevatedButton(
//             onPressed: _salary != null
//                 ? () {
//                     final notifier = ref.read(
//                       visaRecommendationProvider.notifier,
//                     );
//                     final draft =
//                         notifier.getDraft() ??
//                         const VisaQuestionnaire(
//                           occupationCode: '',
//                           nationality: '',
//                         );

//                     notifier.saveUserResponse(
//                       draft.copyWith(
//                         currentSalary: _salary,
//                         hasRecognition: _hasRecognition,
//                       ),
//                     );

//                     widget.onNext();
//                   }
//                 : null,
//             child: const Text('Submit'),
//           ),
//         ],
//       ),
//     );
//   }
// }
