import 'package:flutter/material.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_question_model/question_type.dart';

class ProgressiveQuestionPage extends StatefulWidget {
  final List<VisaQuestion> questions;
  final Map<String, dynamic>? initialAnswers;
  final Future<void> Function(Map<String, dynamic> answers) onNext;

  const ProgressiveQuestionPage({
    super.key,
    required this.questions,
    required this.onNext,
    this.initialAnswers,
  });

  @override
  State<ProgressiveQuestionPage> createState() =>
      _ProgressiveQuestionPageState();
}

class _ProgressiveQuestionPageState extends State<ProgressiveQuestionPage> {
  late Map<String, dynamic> _answers;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _answers = Map<String, dynamic>.from(widget.initialAnswers ?? {});
  }

  VisaQuestion get _currentQuestion => widget.questions[_currentIndex];

  bool get _currentAnswered {
    final ans = _answers[_currentQuestion.id];
    if (!_currentQuestion.required) return true;
    if (ans == null) return false;
    if (ans is String && ans.isEmpty) return false;
    if (ans is List && ans.isEmpty) return false;
    return true;
  }

  void _handleNext(dynamic answer) {
    _answers[_currentQuestion.id] = answer;

    // Dynamic branching
    if (_currentQuestion.nextConditions.containsKey(answer)) {
      final nextId = _currentQuestion.nextConditions[answer]!;
      final nextIndex = widget.questions.indexWhere((q) => q.id == nextId);
      if (nextIndex != -1) {
        _currentIndex = nextIndex;
      } else {
        _currentIndex++;
      }
    } else {
      _currentIndex++;
    }

    if (_currentIndex >= widget.questions.length) {
      widget.onNext(_answers);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _currentQuestion;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.questionText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInput(q),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _currentAnswered
                ? () => _handleNext(_answers[q.id])
                : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(VisaQuestion q) {
    switch (q.questionType) {
      case QuestionType.select:
        return DropdownButtonFormField<String>(
          value: _answers[q.id],
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: q.options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => _answers[q.id] = val),
        );
      case QuestionType.text:
      default:
        return TextFormField(
          initialValue: _answers[q.id] ?? '',
          decoration: const InputDecoration(border: OutlineInputBorder()),
          onChanged: (val) => setState(() => _answers[q.id] = val),
        );
    }
  }
}
