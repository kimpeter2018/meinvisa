// lib/features/visa_recommendation/view/progressive_question_page.dart
import 'package:flutter/material.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_question_model/question_type.dart';
import 'package:meinvisa/features/visa_recommendation/widgets/date_picker.dart';

/// ============================================
/// OPTIMIZED PROGRESSIVE QUESTION UI
/// ============================================
///
/// Features:
/// 1. Shows one question at a time
/// 2. Collapses answered questions with edit capability
/// 3. Dynamic question loading (no pre-fetching)
/// 4. Progress indicator
/// 5. Smooth animations
///
class ProgressiveQuestionPage extends StatefulWidget {
  final VisaQuestion? currentQuestion;
  final Map<String, dynamic> answers;
  final int totalAnswered;
  final Future<void> Function(VisaQuestion question, dynamic answer) onNext;
  final VoidCallback? onComplete;

  const ProgressiveQuestionPage({
    super.key,
    required this.currentQuestion,
    required this.answers,
    required this.totalAnswered,
    required this.onNext,
    this.onComplete,
  });

  @override
  State<ProgressiveQuestionPage> createState() =>
      _ProgressiveQuestionPageState();
}

class _ProgressiveQuestionPageState extends State<ProgressiveQuestionPage> {
  bool _isSubmitting = false;
  dynamic _currentAnswer;

  @override
  void initState() {
    super.initState();
    // Pre-fill answer if question was previously answered
    if (widget.currentQuestion != null) {
      _currentAnswer = widget.answers[widget.currentQuestion!.fieldKey];
    }
  }

  @override
  void didUpdateWidget(ProgressiveQuestionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update answer when question changes
    if (widget.currentQuestion != null &&
        widget.currentQuestion != oldWidget.currentQuestion) {
      _currentAnswer = widget.answers[widget.currentQuestion!.fieldKey];
    }
  }

  Future<void> _handleNext() async {
    if (widget.currentQuestion == null) return;
    if (_currentAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer the question')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onNext(widget.currentQuestion!, _currentAnswer);

      // Clear answer for next question
      setState(() {
        _currentAnswer = null;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  int? _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Widget _buildInput(VisaQuestion q) {
    DebugLogger().log(
      'Building input for ${q.fieldKey} of type ${q.questionType}',
    );

    switch (q.questionType) {
      case QuestionType.select:
        return DropdownButtonFormField<String>(
          initialValue: _currentAnswer as String?,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Select an option',
            helperText: q.purpose,
            helperMaxLines: 2,
          ),
          items: q.options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => _currentAnswer = val),
        );

      case QuestionType.boolean:
        String? initialValue = _currentAnswer == null
            ? null
            : (_currentAnswer == true ? 'yes' : 'no');

        return DropdownButtonFormField<String>(
          initialValue: initialValue,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Select an option',
            helperText: q.purpose,
            helperMaxLines: 2,
          ),
          items: const [
            DropdownMenuItem(value: 'yes', child: Text('Yes')),
            DropdownMenuItem(value: 'no', child: Text('No')),
          ],
          onChanged: (val) {
            setState(() => _currentAnswer = val == 'yes');
          },
        );

      case QuestionType.number:
        return TextFormField(
          initialValue: _currentAnswer?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Enter a number',
            helperText: q.purpose,
            helperMaxLines: 2,
          ),
          onChanged: (val) =>
              setState(() => _currentAnswer = int.tryParse(val)),
        );

      case QuestionType.date:
        return ModernDatePicker(
          initialDate: _currentAnswer is DateTime ? _currentAnswer : null,
          labelText: q.fieldKey == 'age'
              ? 'Select your birthday'
              : 'Select date',
          hintText: 'DD/MM/YYYY',
          onDateChanged: (date) {
            setState(() {
              if (q.fieldKey == 'age' && date != null) {
                _currentAnswer = date;
                // Also store calculated age
                widget.answers['age'] = _calculateAge(date);
              } else {
                _currentAnswer = date;
              }
            });
          },
        );

      case QuestionType.text:
      default:
        return TextFormField(
          initialValue: _currentAnswer?.toString() ?? '',
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Your answer',
            helperText: q.purpose,
            helperMaxLines: 2,
          ),
          maxLines: q.questionType == QuestionType.text ? 3 : 1,
          onChanged: (val) => setState(() => _currentAnswer = val),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.currentQuestion;

    // Show completion screen if no more questions
    if (currentQuestion == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'All questions completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onComplete,
              child: const Text('Get Visa Recommendation'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visa Questionnaire'),
        actions: [
          // Progress indicator
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${widget.totalAnswered} answered',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: widget.totalAnswered > 0
                  ? widget.totalAnswered / (widget.totalAnswered + 1)
                  : 0,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 24),

            // Current question card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question text
                    Text(
                      currentQuestion.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Category badge
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(
                          currentQuestion.category,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blue[100],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input widget
                    _buildInput(currentQuestion),
                    const SizedBox(height: 24),

                    // Next button
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleNext,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Next', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
