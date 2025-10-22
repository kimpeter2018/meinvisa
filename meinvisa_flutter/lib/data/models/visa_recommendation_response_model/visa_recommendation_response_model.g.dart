// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_recommendation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaRecommendationResponse _$VisaRecommendationResponseFromJson(
  Map<String, dynamic> json,
) => _VisaRecommendationResponse(
  nationality: json['nationality'] as String?,
  occupation: json['occupation'] as String?,
  educationLevel: json['education_level'] as String?,
  languageProficiency: json['language_proficiency'] as String?,
  countryOfResidence: json['country_of_residence'] as String?,
  targetCountry: json['target_country'] as String?,
  workExperienceYears: (json['work_experience_years'] as num?)?.toInt(),
  desiredVisaType: json['desired_visa_type'] as String?,
  hasJobOffer: json['has_job_offer'] as bool?,
  hasRelativesAbroad: json['has_relatives_abroad'] as bool?,
);

Map<String, dynamic> _$VisaRecommendationResponseToJson(
  _VisaRecommendationResponse instance,
) => <String, dynamic>{
  'nationality': instance.nationality,
  'occupation': instance.occupation,
  'education_level': instance.educationLevel,
  'language_proficiency': instance.languageProficiency,
  'country_of_residence': instance.countryOfResidence,
  'target_country': instance.targetCountry,
  'work_experience_years': instance.workExperienceYears,
  'desired_visa_type': instance.desiredVisaType,
  'has_job_offer': instance.hasJobOffer,
  'has_relatives_abroad': instance.hasRelativesAbroad,
};
