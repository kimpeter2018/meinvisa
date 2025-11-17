// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaQuestion _$VisaQuestionFromJson(Map json) => $checkedCreate(
  '_VisaQuestion',
  json,
  ($checkedConvert) {
    final val = _VisaQuestion(
      uid: $checkedConvert('uid', (v) => v as String),
      category: $checkedConvert('category', (v) => v as String),
      question: $checkedConvert('question', (v) => v as String),
      fieldKey: $checkedConvert('field_key', (v) => v as String),
      questionType: $checkedConvert(
        'question_type',
        (v) => const QuestionTypeConverter().fromJson(v as String),
      ),
      purpose: $checkedConvert('purpose', (v) => v as String?),
      optionsSource: $checkedConvert('options_source', (v) => v as String?),
      options: $checkedConvert(
        'options',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      required: $checkedConvert('required', (v) => v as bool? ?? false),
      orderIndex: $checkedConvert('order_index', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'fieldKey': 'field_key',
    'questionType': 'question_type',
    'optionsSource': 'options_source',
    'orderIndex': 'order_index',
  },
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
