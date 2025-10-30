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
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _answers = Map<String, dynamic>.from(widget.initialAnswers ?? {});
  }

  VisaQuestion? get _currentQuestion {
    if (_currentIndex >= widget.questions.length) return null;
    return widget.questions[_currentIndex];
  }

  bool get _currentAnswered {
    final q = _currentQuestion;
    if (q == null) return false;
    final ans = _answers[q.fieldKey];
    if (!q.required) return true;
    if (ans == null) return false;
    if (ans is String && ans.isEmpty) return false;
    if (ans is List && ans.isEmpty) return false;
    return true;
  }

  Future<void> _handleNext(dynamic answer) async {
    final q = _currentQuestion;
    if (q == null) return;

    // Use fieldKey instead of id (String key)
    _answers[q.fieldKey] = answer;

    // For now, no nextConditions in model — simple sequential flow
    _currentIndex++;

    if (_currentIndex >= widget.questions.length) {
      setState(() => _completed = true);
    } else {
      setState(() {});
    }
  }

  void _handleBack() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return _buildSummaryScreen();
    }

    final q = _currentQuestion;
    if (q == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final progress = (_currentIndex + 1) / widget.questions.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: Theme.of(context).colorScheme.primary,
              minHeight: 6,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 8),

          // Animated question container
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Card(
                key: ValueKey(q.id),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (q.purpose != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          q.purpose!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _buildInput(q),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentIndex > 0)
                TextButton.icon(
                  onPressed: _handleBack,
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  label: const Text('Back'),
                ),
              ElevatedButton.icon(
                onPressed: _currentAnswered
                    ? () => _handleNext(_answers[q.fieldKey])
                    : null,
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInput(VisaQuestion q) {
    switch (q.questionType) {
      case QuestionType.select:
        return DropdownButtonFormField<String>(
          initialValue: _answers[q.fieldKey],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Select an option',
          ),
          items: q.options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => _answers[q.fieldKey] = val),
        );
      case QuestionType.text:
      default:
        return TextFormField(
          initialValue: _answers[q.fieldKey] ?? '',
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your answer',
          ),
          onChanged: (val) => setState(() => _answers[q.fieldKey] = val),
        );
    }
  }

  Widget _buildSummaryScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: _answers.entries
                  .map(
                    (entry) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          entry.key.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry.value.toString()),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async => await widget.onNext(_answers),
            icon: const Icon(Icons.send),
            label: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
