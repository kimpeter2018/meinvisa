// lib/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart (UPDATE)

import 'package:freezed_annotation/freezed_annotation.dart';

part 'visa_recommendation_response_model.freezed.dart';
part 'visa_recommendation_response_model.g.dart';

@freezed
abstract class VisaRecommendationResponse with _$VisaRecommendationResponse {
  const factory VisaRecommendationResponse({
    required VisaOption recommended,
    @Default([]) List<VisaOption> alternatives,
    @Default([]) List<String> notes,
    ApplicationMetadata? applicationMetadata,
  }) = _VisaRecommendationResponse;

  factory VisaRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$VisaRecommendationResponseFromJson(json);
}

@freezed
abstract class VisaOption with _$VisaOption {
  const factory VisaOption({
    required String code,
    required String name,
    required String summary,
    List<String>? requirements,
    List<String>? notes,
  }) = _VisaOption;

  factory VisaOption.fromJson(Map<String, dynamic> json) => _$VisaOptionFromJson(json);
}

@freezed
abstract class ApplicationMetadata with _$ApplicationMetadata {
  const factory ApplicationMetadata({
    @Default([]) List<CityPortal> cityPortals,
    @Default([]) List<RequiredDocument> requiredDocuments,
    @Default([]) List<ApplicationQuestion> additionalQuestions,
    @Default([]) List<PreFilledField> preFilledFields,
    String? estimatedProcessingTime,
    String? appointmentBookingUrl,
    @Default([]) List<String> specialInstructions,
  }) = _ApplicationMetadata;

  factory ApplicationMetadata.fromJson(Map<String, dynamic> json) =>
      _$ApplicationMetadataFromJson(json);
}

@freezed
abstract class CityPortal with _$CityPortal {
  const factory CityPortal({
    required String id,
    required String city,
    String? state,
    required String portalUrl,
    required bool appointmentRequired,
    String? appointmentBookingUrl,
    String? contactEmail,
    String? contactPhone,
    String? address,
    String? operatingHours,
    String? specialInstructions,
    int? averageWaitTimeDays,
  }) = _CityPortal;

  factory CityPortal.fromJson(Map<String, dynamic> json) => _$CityPortalFromJson(json);
}

@freezed
abstract class RequiredDocument with _$RequiredDocument {
  const factory RequiredDocument({
    required String id,
    required String documentType,
    required String documentName,
    String? description,
    required bool required,
    required bool canGenerate,
    String? instructions,
    required int orderIndex,
    @Default(false) bool uploaded,
  }) = _RequiredDocument;

  factory RequiredDocument.fromJson(Map<String, dynamic> json) => _$RequiredDocumentFromJson(json);
}

@freezed
abstract class ApplicationQuestion with _$ApplicationQuestion {
  const factory ApplicationQuestion({
    required String id,
    required String fieldKey,
    required String question,
    required String questionType,
    required bool required,
    List<String>? options,
    Map<String, dynamic>? validationRules,
    String? helpText,
    String? placeholder,
    required String section,
    required int orderIndex,
  }) = _ApplicationQuestion;

  factory ApplicationQuestion.fromJson(Map<String, dynamic> json) =>
      _$ApplicationQuestionFromJson(json);
}

@freezed
abstract class PreFilledField with _$PreFilledField {
  const factory PreFilledField({
    required String formFieldKey,
    required String formFieldLabel,
    String? formSection,
    required String sourceFieldKey,
    required dynamic value,
    required String confidence,
    required bool requiresVerification,
  }) = _PreFilledField;

  factory PreFilledField.fromJson(Map<String, dynamic> json) => _$PreFilledFieldFromJson(json);
}
