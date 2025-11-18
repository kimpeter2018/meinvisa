import 'package:flutter/material.dart';
import 'package:meinvisa/data/models/application_form_data_model/application_form_data_model.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';

class AdditionalQuestionsSection extends StatelessWidget {
  final List<ApplicationQuestion> questions;
  final ApplicationFormData formData;
  final Function(String fieldKey, dynamic value) onAnswerChanged;

  const AdditionalQuestionsSection({
    super.key,
    required this.questions,
    required this.formData,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Group questions by section
    final groupedQuestions = <String, List<ApplicationQuestion>>{};
    for (final question in questions) {
      groupedQuestions.putIfAbsent(question.section, () => []).add(question);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.help_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Please answer the following ${questions.length} questions to complete your application.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            // Sections
            ...groupedQuestions.entries.map(
              (entry) => _buildSection(context, entry.key, entry.value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String sectionName,
    List<ApplicationQuestion> sectionQuestions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 16),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatSectionName(sectionName),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),

        // Questions in this section
        ...sectionQuestions.map(
          (question) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildQuestionField(context, question),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionField(BuildContext context, ApplicationQuestion question) {
    final currentValue = formData.getValue(question.fieldKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question label
        Row(
          children: [
            Expanded(
              child: Text(
                question.question,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            if (question.required)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  'Required',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ),
          ],
        ),

        // Help text
        if (question.helpText != null) ...[
          const SizedBox(height: 4),
          Text(question.helpText!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],

        const SizedBox(height: 8),

        // Input field based on question type
        _buildInputField(context, question, currentValue),
      ],
    );
  }

  Widget _buildInputField(
    BuildContext context,
    ApplicationQuestion question,
    dynamic currentValue,
  ) {
    switch (question.questionType) {
      case 'text':
      case 'email':
      case 'phone':
        return TextFormField(
          initialValue: currentValue?.toString(),
          decoration: InputDecoration(
            hintText: question.placeholder,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          keyboardType: question.questionType == 'email'
              ? TextInputType.emailAddress
              : question.questionType == 'phone'
              ? TextInputType.phone
              : TextInputType.text,
          onChanged: (value) => onAnswerChanged(question.fieldKey, value),
        );

      case 'textarea':
        return TextFormField(
          initialValue: currentValue?.toString(),
          decoration: InputDecoration(
            hintText: question.placeholder,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(12),
          ),
          maxLines: 4,
          onChanged: (value) => onAnswerChanged(question.fieldKey, value),
        );

      case 'number':
        return TextFormField(
          initialValue: currentValue?.toString(),
          decoration: InputDecoration(
            hintText: question.placeholder,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final numValue = int.tryParse(value);
            onAnswerChanged(question.fieldKey, numValue ?? value);
          },
        );

      case 'date':
        return InkWell(
          onTap: () => _selectDate(context, question, currentValue),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  currentValue != null ? _formatDate(currentValue.toString()) : 'Select date',
                  style: TextStyle(color: currentValue != null ? Colors.black : Colors.grey[600]),
                ),
              ],
            ),
          ),
        );

      case 'select':
        return DropdownButtonFormField<String>(
          initialValue: currentValue?.toString(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          hint: Text(question.placeholder ?? 'Select an option'),
          items: (question.options ?? []).map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) => onAnswerChanged(question.fieldKey, value),
        );

      case 'boolean':
        return Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue: currentValue as bool?,
                onChanged: (value) => onAnswerChanged(question.fieldKey, value),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: currentValue,
                onChanged: (value) => onAnswerChanged(question.fieldKey, value),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        );

      default:
        return TextFormField(
          initialValue: currentValue?.toString(),
          decoration: InputDecoration(
            hintText: question.placeholder,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) => onAnswerChanged(question.fieldKey, value),
        );
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    ApplicationQuestion question,
    dynamic currentValue,
  ) async {
    final now = DateTime.now();
    DateTime? initialDate;

    if (currentValue != null) {
      try {
        initialDate = DateTime.parse(currentValue.toString());
      } catch (e) {
        initialDate = now;
      }
    } else {
      initialDate = now;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onAnswerChanged(question.fieldKey, picked.toIso8601String().split('T')[0]);
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatSectionName(String section) {
    return section.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
