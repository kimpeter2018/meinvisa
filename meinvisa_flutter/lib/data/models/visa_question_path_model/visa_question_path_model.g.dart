// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_question_path_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaQuestionPath _$VisaQuestionPathFromJson(Map<String, dynamic> json) =>
    _VisaQuestionPath(
      id: json['id'] as String,
      fromField: json['from_field'] as String,
      answerValue: json['answer_value'] as String?,
      nextCategories:
          (json['next_categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nextQuestionKeys:
          (json['next_question_keys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      conditionType: json['condition_type'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$VisaQuestionPathToJson(_VisaQuestionPath instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_field': instance.fromField,
      'answer_value': instance.answerValue,
      'next_categories': instance.nextCategories,
      'next_question_keys': instance.nextQuestionKeys,
      'condition_type': instance.conditionType,
      'description': instance.description,
    };
