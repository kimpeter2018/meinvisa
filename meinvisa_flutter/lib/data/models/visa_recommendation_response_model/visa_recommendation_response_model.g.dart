// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_recommendation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaRecommendationResponse _$VisaRecommendationResponseFromJson(
  Map<String, dynamic> json,
) => _VisaRecommendationResponse(
  recommended: VisaOption.fromJson(json['recommended'] as Map<String, dynamic>),
  alternatives:
      (json['alternatives'] as List<dynamic>?)
          ?.map((e) => VisaOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notes:
      (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$VisaRecommendationResponseToJson(
  _VisaRecommendationResponse instance,
) => <String, dynamic>{
  'recommended': instance.recommended.toJson(),
  'alternatives': instance.alternatives.map((e) => e.toJson()).toList(),
  'notes': instance.notes,
};

_VisaOption _$VisaOptionFromJson(Map<String, dynamic> json) => _VisaOption(
  code: json['code'] as String,
  name: json['name'] as String,
  summary: json['summary'] as String,
  requirements:
      (json['requirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  notes:
      (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$VisaOptionToJson(_VisaOption instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'summary': instance.summary,
      'requirements': instance.requirements,
      'notes': instance.notes,
    };
