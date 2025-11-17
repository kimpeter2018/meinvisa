// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaQuestion _$VisaQuestionFromJson(Map<String, dynamic> json) =>
    _VisaQuestion(
      uid: json['uid'] as String,
      category: json['category'] as String,
      question: json['question'] as String,
      fieldKey: json['field_key'] as String,
      questionType: const QuestionTypeConverter().fromJson(
        json['question_type'] as String,
      ),
      purpose: json['purpose'] as String?,
      optionsSource: json['options_source'] as String?,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      orderIndex: (json['order_index'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VisaQuestionToJson(
  _VisaQuestion instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'category': instance.category,
  'question': instance.question,
  'field_key': instance.fieldKey,
  'question_type': const QuestionTypeConverter().toJson(instance.questionType),
  'purpose': instance.purpose,
  'options_source': instance.optionsSource,
  'options': instance.options,
  'required': instance.required,
  'order_index': instance.orderIndex,
};
