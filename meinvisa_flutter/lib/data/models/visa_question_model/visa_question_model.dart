import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meinvisa/core/services/question_type_converter.dart';
import 'package:meinvisa/data/models/visa_question_model/question_type.dart';

part 'visa_question_model.freezed.dart';
part 'visa_question_model.g.dart';

@freezed
abstract class VisaQuestion with _$VisaQuestion {
  const factory VisaQuestion({
    required String id,
    required String questionText,
    @QuestionTypeConverter() required QuestionType questionType,
    required String category,
    String? optionsSource,
    @Default([]) List<String> options,
    @Default(false) bool required,
    String? parentCondition,
    @Default({})
    Map<String, String> nextConditions, // answerValue -> nextQuestionId
  }) = _VisaQuestion;

  factory VisaQuestion.fromJson(Map<String, dynamic> json) =>
      _$VisaQuestionFromJson(json);
}
