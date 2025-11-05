import 'package:flutter/material.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';
import 'package:meinvisa/data/models/visa_question_model/question_type.dart';
import 'package:meinvisa/features/visa_recommendation/widgets/date_picker.dart';

class ProgressiveQuestionPage extends StatefulWidget {
  final VisaQuestion? currentQuestion;
  final Map<String, dynamic> answers;
  final List<VisaQuestion> answeredQuestions;
  final int totalAnswered;
  final Future<void> Function(VisaQuestion question, dynamic answer) onNext;
  final VoidCallback? onComplete;
  final Function(VisaQuestion)? onEdit;

  const ProgressiveQuestionPage({
    super.key,
    required this.currentQuestion,
    required this.answers,
    required this.answeredQuestions,
    required this.totalAnswered,
    required this.onNext,
    this.onComplete,
    this.onEdit,
  });

  @override
  State<ProgressiveQuestionPage> createState() => _ProgressiveQuestionPageState();
}

class _ProgressiveQuestionPageState extends State<ProgressiveQuestionPage>
    with SingleTickerProviderStateMixin {
  bool _isSubmitting = false;
  dynamic _currentAnswer;
  final ScrollController _scrollController = ScrollController();

  // Track which question is being edited
  VisaQuestion? _editingQuestion;

  @override
  void initState() {
    super.initState();
    _initializeAnswer();
  }

  void _initializeAnswer() {
    final questionToShow = _editingQuestion ?? widget.currentQuestion;
    if (questionToShow != null) {
      _currentAnswer = widget.answers[questionToShow.fieldKey];
    }
  }

  @override
  void didUpdateWidget(ProgressiveQuestionPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset answer when question changes
    if (widget.currentQuestion != oldWidget.currentQuestion) {
      _editingQuestion = null; // Clear editing state
      _initializeAnswer();

      // Scroll to bottom to show new question
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    final questionToAnswer = _editingQuestion ?? widget.currentQuestion;

    if (questionToAnswer == null) return;

    if (_currentAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer the question'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // If birthday, also pass age along (but don't modify widget.answers)
      if (questionToAnswer.fieldKey == 'birthday') {
        final birthdayDate = _currentAnswer as DateTime;
        final age = _calculateAge(birthdayDate);

        DebugLogger().log('🎂 Submitting birthday: $birthdayDate with age: $age');

        // Pass both birthday and age in a single answer map
        await widget.onNext(questionToAnswer, {
          'birthday': birthdayDate.toIso8601String(), // Convert to string for JSON serialization
          'age': age,
        });
      } else {
        await widget.onNext(questionToAnswer, _currentAnswer);
      }

      setState(() {
        _currentAnswer = null;
        _isSubmitting = false;
        _editingQuestion = null; // Clear editing state after successful answer
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleEditQuestion(VisaQuestion q) {
    DebugLogger().log('👆 User tapped collapsed question: ${q.fieldKey}');

    setState(() {
      _editingQuestion = q;
      _currentAnswer = widget.answers[q.fieldKey];
    });

    // Notify parent to handle re-answer logic
    if (widget.onEdit != null) {
      widget.onEdit!(q);
    }

    // Scroll to show the question
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
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
    switch (q.questionType) {
      case QuestionType.select:
        return DropdownButtonFormField<String>(
          initialValue: _currentAnswer as String?,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
          ),
          hint: const Text('Select an option'),
          items: q.options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) => setState(() => _currentAnswer = val),
        );

      case QuestionType.boolean:
        return RadioGroup(
          onChanged: (val) => setState(() => _currentAnswer = val),
          groupValue: _currentAnswer as bool?,
          child: Column(
            children: [
              RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Colors.grey[50],
              ),
              const SizedBox(height: 8),
              RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Colors.grey[50],
              ),
            ],
          ),
        );

      case QuestionType.number:
        return TextFormField(
          initialValue: _currentAnswer?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
            hintText: 'Enter a number',
          ),
          onChanged: (val) => setState(() => _currentAnswer = int.tryParse(val)),
        );

      case QuestionType.date:
        return ModernDatePicker(
          initialDate: _currentAnswer is DateTime ? _currentAnswer : null,
          labelText: q.fieldKey == 'birthday' ? 'Select your birthday' : 'Select date',
          hintText: 'DD/MM/YYYY',
          onDateChanged: (date) {
            setState(() {
              _currentAnswer = date; // Just store the date, don't calculate age here
            });
          },
        );

      case QuestionType.text:
      default:
        return TextFormField(
          initialValue: _currentAnswer?.toString() ?? '',
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
            hintText: 'Your answer',
          ),
          maxLines: q.questionType == QuestionType.text ? 3 : 1,
          onChanged: (val) => setState(() => _currentAnswer = val),
        );
    }
  }

  String _formatAnswer(dynamic answer) {
    if (answer == null) return 'Not answered';
    if (answer is bool) return answer ? 'Yes' : 'No';
    if (answer is DateTime) {
      return '${answer.day}/${answer.month}/${answer.year}';
    }
    return answer.toString();
  }

  Widget _buildCollapsedQuestion(VisaQuestion q, int index) {
    final answer = widget.answers[q.fieldKey];
    final isBeingEdited = _editingQuestion?.fieldKey == q.fieldKey;

    // Don't show as collapsed if currently being edited
    if (isBeingEdited) {
      return const SizedBox.shrink();
    }

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: InkWell(
          onTap: () => _handleEditQuestion(q),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                  child: Icon(Icons.check, size: 18, color: Colors.green[700]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.question,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatAnswer(answer),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.edit, size: 18, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveQuestion(VisaQuestion q) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category badge
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    q.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Question text
              Text(
                q.question,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
              ),

              if (q.purpose != null && q.purpose!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  q.purpose!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
                ),
              ],

              const SizedBox(height: 24),

              // Input widget
              _buildInput(q),
              const SizedBox(height: 24),

              // Next button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleNext,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        _editingQuestion != null ? 'Update' : 'Next',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                child: Icon(Icons.check_circle, size: 48, color: Colors.green[600]),
              ),
              const SizedBox(height: 24),
              const Text(
                'All questions completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You\'ve answered ${widget.totalAnswered} questions',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: widget.onComplete,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Get Visa Recommendation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionToShow = _editingQuestion ?? widget.currentQuestion;
    final hasAnsweredQuestions = widget.answeredQuestions.isNotEmpty;
    final isComplete = questionToShow == null && hasAnsweredQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visa Questionnaire'),
        elevation: 0,
        actions: [
          if (widget.totalAnswered > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.totalAnswered} answered',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          // Answered questions (collapsed) - only show if not being edited
          ...widget.answeredQuestions.asMap().entries.map((entry) {
            return _buildCollapsedQuestion(entry.value, entry.key);
          }),

          // Active question or completion card
          if (isComplete)
            _buildCompletionCard()
          else if (questionToShow != null)
            _buildActiveQuestion(questionToShow),
        ],
      ),
    );
  }
}
