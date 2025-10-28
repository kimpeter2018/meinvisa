import 'package:flutter/material.dart';
import 'package:meinvisa/data/models/visa_question_model/question_type.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';

class DynamicQuestionPage extends StatefulWidget {
  final List<VisaQuestion> questions;
  final Map<String, dynamic>? initialAnswers;
  final Future<void> Function(Map<String, dynamic> answers) onNext;

  const DynamicQuestionPage({
    super.key,
    required this.questions,
    required this.onNext,
    this.initialAnswers,
  });

  @override
  State<DynamicQuestionPage> createState() => _DynamicQuestionPageState();
}

class _DynamicQuestionPageState extends State<DynamicQuestionPage> {
  late Map<String, dynamic> _answers;
  late Map<String, GlobalKey> _questionKeys; // for scrolling
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _answers = Map<String, dynamic>.from(widget.initialAnswers ?? {});
    _questionKeys = {for (var q in widget.questions) q.id: GlobalKey()};
  }

  bool _allRequiredAnswered() {
    return widget.questions.every((q) {
      if (!q.required) return true;
      final ans = _answers[q.id];
      return ans != null &&
          (!((ans is String && ans.isEmpty) || (ans is List && ans.isEmpty)));
    });
  }

  void _checkAndProceed() {
    final missing = widget.questions
        .where(
          (q) =>
              q.required &&
              (_answers[q.id] == null ||
                  (_answers[q.id] is String && _answers[q.id].isEmpty) ||
                  (_answers[q.id] is List && (_answers[q.id] as List).isEmpty)),
        )
        .toList();

    if (missing.isNotEmpty) {
      final firstKey = _questionKeys[missing.first.id];
      if (firstKey != null) {
        Scrollable.ensureVisible(
          firstKey.currentContext!,
          duration: const Duration(milliseconds: 300),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please answer required questions: ${missing.map((q) => q.questionText).join(', ')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onNext(_answers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              final question = widget.questions[index];
              final isMissing =
                  question.required &&
                  (_answers[question.id] == null ||
                      (_answers[question.id] is String &&
                          _answers[question.id].isEmpty) ||
                      (_answers[question.id] is List &&
                          (_answers[question.id] as List).isEmpty));

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  key: _questionKeys[question.id],
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isMissing ? Colors.red : Colors.transparent,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: _buildQuestionInput(question),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _allRequiredAnswered() ? _checkAndProceed : null,
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionInput(VisaQuestion q) {
    switch (q.questionType) {
      case QuestionType.select:
        return _buildDropdown(q);
      case QuestionType.number:
        return _buildNumberField(q);
      case QuestionType.checkbox:
        return _buildCheckbox(q);
      case QuestionType.date:
        return _buildDatePicker(q);
      case QuestionType.text:
      default:
        return _buildTextField(q);
    }
  }

  Widget _buildDropdown(VisaQuestion q) {
    return DropdownButtonFormField<String>(
      initialValue: _answers[q.id],
      decoration: InputDecoration(
        labelText: q.questionText,
        border: const OutlineInputBorder(),
      ),
      items: q.options
          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
          .toList(),
      onChanged: (val) => setState(() => _answers[q.id] = val),
    );
  }

  Widget _buildNumberField(VisaQuestion q) {
    final controller = TextEditingController(
      text: _answers[q.id]?.toString() ?? '',
    );
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: q.questionText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (val) => setState(() => _answers[q.id] = int.tryParse(val)),
    );
  }

  Widget _buildCheckbox(VisaQuestion q) {
    final selected = Set<String>.from(_answers[q.id] ?? []);
    return StatefulBuilder(
      builder: (context, setStateCheckbox) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            q.questionText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          ...q.options.map(
            (opt) => CheckboxListTile(
              title: Text(opt),
              value: selected.contains(opt),
              onChanged: (checked) {
                setStateCheckbox(() {
                  if (checked == true) {
                    selected.add(opt);
                  } else {
                    selected.remove(opt);
                  }
                  setState(() {
                    _answers[q.id] = selected.toList();
                  });
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(VisaQuestion q) {
    final controller = TextEditingController(
      text: _answers[q.id]?.toString().split('T').first ?? '',
    );
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: q.questionText,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: _answers[q.id] != null
              ? DateTime.tryParse(_answers[q.id]) ?? now
              : now,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          controller.text = picked.toIso8601String().split('T').first;
          setState(() => _answers[q.id] = picked.toIso8601String());
        }
      },
    );
  }

  Widget _buildTextField(VisaQuestion q) {
    final controller = TextEditingController(text: _answers[q.id] ?? '');
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: q.questionText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (val) => setState(() => _answers[q.id] = val),
    );
  }
}
