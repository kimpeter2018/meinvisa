import 'package:flutter/material.dart';
import 'package:meinvisa/data/models/visa_question_model/visa_question_model.dart';

class DynamicQuestionPage extends StatelessWidget {
  final List<VisaQuestion> questions;
  final Function(String id, dynamic value) onAnswer;

  const DynamicQuestionPage({
    super.key,
    required this.questions,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _buildQuestionField(question),
        );
      },
    );
  }

  Widget _buildQuestionField(VisaQuestion q) {
    switch (q.inputType) {
      case 'dropdown':
        return _buildDropdown(q);
      case 'number':
        return _buildNumberField(q);
      case 'checkbox':
        return _buildCheckbox(q);
      case 'date':
        return _buildDatePicker(q);
      default:
        return _buildTextField(q);
    }
  }

  Widget _buildDropdown(VisaQuestion q) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: q.questionText,
        border: const OutlineInputBorder(),
      ),
      items: q.options
          ?.map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
          .toList(),
      onChanged: (val) => onAnswer(q.id, val),
    );
  }

  Widget _buildNumberField(VisaQuestion q) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: q.questionText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (val) => onAnswer(q.id, int.tryParse(val)),
    );
  }

  Widget _buildCheckbox(VisaQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q.questionText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        ...?q.options?.map(
          (opt) => CheckboxListTile(
            title: Text(opt),
            value: false, // optional: can store state via provider if needed
            onChanged: (checked) => onAnswer(q.id, opt),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(VisaQuestion q) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: q.questionText,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: navigatorKey.currentContext!,
          initialDate: now,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onAnswer(q.id, picked.toIso8601String());
        }
      },
    );
  }

  Widget _buildTextField(VisaQuestion q) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: q.questionText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (val) => onAnswer(q.id, val),
    );
  }
}

// optional global key for datepicker context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
