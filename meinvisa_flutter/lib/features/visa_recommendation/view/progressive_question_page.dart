import 'package:flutter/material.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_question_model/question_type.dart';
import 'package:meinvisa/features/visa_recommendation/widgets/date_picker.dart';

class ProgressiveQuestionPage extends StatefulWidget {
  final List<VisaQuestion> questions;
  final Map<String, dynamic> initialAnswers;
  final Future<void> Function(VisaQuestion question, dynamic answer) onNext;

  const ProgressiveQuestionPage({
    super.key,
    required this.questions,
    required this.initialAnswers,
    required this.onNext,
  });

  @override
  State<ProgressiveQuestionPage> createState() =>
      _ProgressiveQuestionPageState();
}

class _ProgressiveQuestionPageState extends State<ProgressiveQuestionPage> {
  late Map<String, dynamic> _answers;
  final List<VisaQuestion> _answered = [];
  VisaQuestion? _current;

  @override
  void initState() {
    super.initState();
    _answers = Map<String, dynamic>.from(widget.initialAnswers);
    _current = widget.questions.isNotEmpty ? widget.questions.first : null;
  }

  void _goToQuestion(VisaQuestion q) {
    setState(() {
      _current = q;
      _answered.removeWhere((x) => x.fieldKey == q.fieldKey);
    });
  }

  Future<void> _handleNext(dynamic value) async {
    if (_current == null) return;

    final q = _current!;
    _answers[q.fieldKey] = value;

    await widget.onNext(q, value);

    setState(() {
      _answered.add(q);
      widget.questions.remove(q);
      _current = widget.questions.isNotEmpty ? widget.questions.first : null;
    });
  }

  Widget _buildCollapsed(VisaQuestion q) {
    final answer = _answers[q.fieldKey]?.toString() ?? 'Not answered';
    return GestureDetector(
      onTap: () => _goToQuestion(q),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: ListTile(
          title: Text(
            q.question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(answer),
          trailing: const Icon(Icons.edit, color: Colors.blue),
        ),
      ),
    );
  }

  // Add this helper function in your state class
  int? _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust if birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  //TODO: Refactor input widgets into separate classes/files if they grow more complex
  Widget _buildInput(VisaQuestion q, dynamic currentValue) {
    DebugLogger().log(
      'Building input for ${q.fieldKey} of type ${q.questionType} with current value: $currentValue',
    );
    switch (q.questionType) {
      case QuestionType.select:
        return DropdownButtonFormField<String>(
          initialValue: currentValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Select an option',
          ),
          items: q.options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => _answers[q.fieldKey] = val),
        );
      case QuestionType.boolean:
        // Convert current boolean to string for dropdown
        String? initialValue = currentValue == null
            ? null
            : (currentValue == true ? 'yes' : 'no');

        return DropdownButtonFormField<String>(
          initialValue: initialValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Select an option',
          ),
          items: q.options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            // Convert "yes"/"no" string to boolean
            setState(() => _answers[q.fieldKey] = val == 'yes');
          },
        );
      case QuestionType.number:
        return TextFormField(
          initialValue: currentValue?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter a number',
          ),
          onChanged: (val) =>
              setState(() => _answers[q.fieldKey] = int.tryParse(val)),
        );
      case QuestionType.date:
        return ModernDatePicker(
          initialDate: currentValue is DateTime ? currentValue : null,
          labelText: q.fieldKey == 'age'
              ? 'Select your birthday'
              : 'Select date',
          hintText: 'DD/MM/YYYY',
          onDateChanged: (date) {
            setState(() {
              if (q.fieldKey == 'age' && date != null) {
                _answers['birthday'] = date;
                _answers['age'] = _calculateAge(date);
              } else {
                _answers[q.fieldKey] = date;
              }
            });
          },
        );
      case QuestionType.text:
      default:
        return TextFormField(
          initialValue: currentValue ?? '',
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your answer',
          ),
          onChanged: (val) => setState(() => _answers[q.fieldKey] = val),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visa Questionnaire')),
      body: _current == null
          ? const Center(child: Text('All questions completed.'))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Collapsed answered questions
                ..._answered.map(_buildCollapsed),

                // Active question
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Card(
                    key: ValueKey(_current!.fieldKey),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _current!.question,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_current!.purpose != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 16,
                              ),
                              child: Text(
                                _current!.purpose!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                          _buildInput(_current!, _answers[_current!.fieldKey]),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                _handleNext(_answers[_current!.fieldKey]),
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
