// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaQuestion _$VisaQuestionFromJson(Map<String, dynamic> json) =>
    _VisaQuestion(
      id: json['id'] as String,
      category: json['category'] as String,
      questionText: json['question_text'] as String,
      fieldKey: json['field_key'] as String,
      questionType: json['question_type'] as String,
      optionsSource: json['options_source'] as String?,
      isRequired: json['required'] as bool?,
      orderIndex: (json['order_index'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$VisaQuestionToJson(_VisaQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'question_text': instance.questionText,
      'field_key': instance.fieldKey,
      'question_type': instance.questionType,
      'options_source': instance.optionsSource,
      'required': instance.isRequired,
      'order_index': instance.orderIndex,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
