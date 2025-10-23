// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  id: json['id'] as String,
  category: json['category'] as String,
  questionText: json['question_text'] as String,
  type: json['type'] as String,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'question_text': instance.questionText,
  'type': instance.type,
  'options': instance.options,
};
