// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_questionnaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaQuestionnaire _$VisaQuestionnaireFromJson(Map<String, dynamic> json) =>
    _VisaQuestionnaire(
      occupationCode: json['occupation_code'] as String,
      nationality: json['nationality'] as String,
      currentSalary: (json['current_salary'] as num?)?.toDouble(),
      hasRecognition: json['has_recognition'] as bool?,
      age: (json['age'] as num?)?.toInt(),
      countryOfResidence: json['location_applied_from'] as String?,
    );

Map<String, dynamic> _$VisaQuestionnaireToJson(_VisaQuestionnaire instance) =>
    <String, dynamic>{
      'occupation_code': instance.occupationCode,
      'nationality': instance.nationality,
      'current_salary': instance.currentSalary,
      'has_recognition': instance.hasRecognition,
      'age': instance.age,
      'location_applied_from': instance.countryOfResidence,
    };
