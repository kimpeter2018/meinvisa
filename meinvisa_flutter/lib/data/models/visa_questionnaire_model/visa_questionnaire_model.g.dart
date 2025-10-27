// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_questionnaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaQuestionnaire _$VisaQuestionnaireFromJson(Map<String, dynamic> json) =>
    _VisaQuestionnaire(
      jobOffer: json['job_offer'] as bool?,
      shortageField: json['shortage_field'] as bool?,
      occupation: json['occupation'] as String?,
      workExperienceYears: (json['work_experience_years'] as num?)?.toInt(),
      isEmployed: json['is_employed'] as bool?,
      regulatedInGermany: json['regulated_in_germany'] as bool?,
      familyInGermany: json['family_in_germany'] as bool?,
      schengenVisa: json['schengen_visa'] as bool?,
      visaRefusalHistory: json['visa_refusal_history'] as bool?,
      visitedGermany: json['visited_germany'] as bool?,
      purposeOfStay: json['purpose_of_stay'] as String?,
      intendedDuration: json['intended_duration'] as String?,
      hasAccommodation: json['has_accommodation'] as bool?,
      hasSufficientFunds: json['has_sufficient_funds'] as bool?,
      birthDate: json['birth_date'] as String?,
      gender: json['gender'] as String?,
      maritalStatus: json['marital_status'] as String?,
      citizenshipCountry: json['citizenship_country'] as String?,
      secondCitizenship: json['second_citizenship'] as String?,
      residenceCountry: json['residence_country'] as String?,
      monthlyIncome: (json['monthly_income'] as num?)?.toDouble(),
      financialProof: json['financial_proof'] as bool?,
      sponsored: json['sponsored'] as bool?,
      universityAdmission: json['university_admission'] as bool?,
      educationLevel: json['education_level'] as String?,
      studyInGermany: json['study_in_germany'] as bool?,
      fieldOfStudy: json['field_of_study'] as String?,
    );

Map<String, dynamic> _$VisaQuestionnaireToJson(_VisaQuestionnaire instance) =>
    <String, dynamic>{
      'job_offer': instance.jobOffer,
      'shortage_field': instance.shortageField,
      'occupation': instance.occupation,
      'work_experience_years': instance.workExperienceYears,
      'is_employed': instance.isEmployed,
      'regulated_in_germany': instance.regulatedInGermany,
      'family_in_germany': instance.familyInGermany,
      'schengen_visa': instance.schengenVisa,
      'visa_refusal_history': instance.visaRefusalHistory,
      'visited_germany': instance.visitedGermany,
      'purpose_of_stay': instance.purposeOfStay,
      'intended_duration': instance.intendedDuration,
      'has_accommodation': instance.hasAccommodation,
      'has_sufficient_funds': instance.hasSufficientFunds,
      'birth_date': instance.birthDate,
      'gender': instance.gender,
      'marital_status': instance.maritalStatus,
      'citizenship_country': instance.citizenshipCountry,
      'second_citizenship': instance.secondCitizenship,
      'residence_country': instance.residenceCountry,
      'monthly_income': instance.monthlyIncome,
      'financial_proof': instance.financialProof,
      'sponsored': instance.sponsored,
      'university_admission': instance.universityAdmission,
      'education_level': instance.educationLevel,
      'study_in_germany': instance.studyInGermany,
      'field_of_study': instance.fieldOfStudy,
    };
