import 'package:freezed_annotation/freezed_annotation.dart';

part 'visa_questionnaire_model.freezed.dart';
part 'visa_questionnaire_model.g.dart';

@freezed
abstract class VisaQuestionnaire with _$VisaQuestionnaire {
  const factory VisaQuestionnaire({
    // Work
    bool? jobOffer,
    bool? shortageField,
    String? occupation,
    int? workExperienceYears,
    bool? isEmployed,
    bool? regulatedInGermany,

    // Travel
    bool? familyInGermany,
    bool? schengenVisa,
    bool? visaRefusalHistory,
    bool? visitedGermany,

    // Purpose
    String? purposeOfStay,
    String? intendedDuration,
    bool? hasAccommodation,
    bool? hasSufficientFunds,

    // Personal
    String? birthDate,
    String? gender,
    String? maritalStatus,
    String? citizenshipCountry,
    String? secondCitizenship,
    String? residenceCountry,

    // Financial
    double? monthlyIncome,
    bool? financialProof,
    bool? sponsored,

    // Education
    bool? universityAdmission,
    String? educationLevel,
    bool? studyInGermany,
    String? fieldOfStudy,
  }) = _VisaQuestionnaire;

  factory VisaQuestionnaire.fromJson(Map<String, dynamic> json) =>
      _$VisaQuestionnaireFromJson(json);
}
