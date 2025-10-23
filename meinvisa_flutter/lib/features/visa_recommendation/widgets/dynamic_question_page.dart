// lib/features/visa_questions/dynamic_question_page.dart
import 'package:flutter/material.dart';
import 'package:meinvisa/data/models/question_model/question_model.dart';

class DynamicQuestionPage extends StatelessWidget {
  final List<Question> questions;
  final Function(String id, dynamic value) onAnswer;

  const DynamicQuestionPage({
    super.key,
    required this.questions,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];

        switch (q.type) {
          case 'dropdown':
            return _buildDropdown(q);
          case 'number':
            return _buildNumberField(q);
          default:
            return _buildTextField(q);
        }
      },
    );
  }

  Widget _buildDropdown(Question q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: q.questionText),
        items: q.options!
            .map(
              (option) => DropdownMenuItem(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: (val) => onAnswer(q.id, val),
      ),
    );
  }

  Widget _buildNumberField(Question q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: q.questionText),
        onChanged: (val) => onAnswer(q.id, int.tryParse(val)),
      ),
    );
  }

  Widget _buildTextField(Question q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        decoration: InputDecoration(labelText: q.questionText),
        onChanged: (val) => onAnswer(q.id, val),
      ),
    );
  }
}
