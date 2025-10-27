// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaQuestion _$VisaQuestionFromJson(Map<String, dynamic> json) =>
    _VisaQuestion(
      id: json['id'] as String,
      questionText: json['question_text'] as String,
      questionType: const QuestionTypeConverter().fromJson(
        json['question_type'] as String,
      ),
      category: json['category'] as String,
      optionsSource: json['options_source'] as String?,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parentCondition: json['parent_condition'] as String?,
    );

Map<String, dynamic> _$VisaQuestionToJson(
  _VisaQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'question_text': instance.questionText,
  'question_type': const QuestionTypeConverter().toJson(instance.questionType),
  'category': instance.category,
  'options_source': instance.optionsSource,
  'options': instance.options,
  'parent_condition': instance.parentCondition,
};
