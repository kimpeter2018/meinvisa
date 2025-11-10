import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meinvisa/data/models/visa_question_model/question_type.dart';

class QuestionTypeConverter implements JsonConverter<QuestionType, String> {
  const QuestionTypeConverter();

  @override
  QuestionType fromJson(String type) {
    switch (type) {
      case 'select':
      case 'dropdown':
        return QuestionType.select;
      case 'number':
        return QuestionType.number;
      case 'boolean':
        return QuestionType.boolean;
      case 'checkbox':
        return QuestionType.checkbox;
      case 'date':
        return QuestionType.date;
      case 'autocomplete':
        return QuestionType.autocomplete;
      case 'text':
      default:
        return QuestionType.text;
    }
  }

  @override
  String toJson(QuestionType type) => type.name;
}
