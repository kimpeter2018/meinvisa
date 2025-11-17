import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';

part 'application_form_data_model.freezed.dart';
part 'application_form_data_model.g.dart';

@freezed
abstract class ApplicationFormData with _$ApplicationFormData {
  const factory ApplicationFormData({
    @Default({}) Map<String, dynamic> preFilledData,
    @Default({}) Map<String, dynamic> additionalData,
    @Default({}) Map<String, dynamic> editedData,
    @Default({}) Map<String, bool> fieldVerified,
  }) = _ApplicationFormData;

  factory ApplicationFormData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFormDataFromJson(json);
}

extension ApplicationFormDataX on ApplicationFormData {
  /// Get the final value for a field (edited > additional > pre-filled)
  dynamic getValue(String fieldKey) {
    return editedData[fieldKey] ?? additionalData[fieldKey] ?? preFilledData[fieldKey];
  }

  /// Check if a field has been verified by user
  bool isVerified(String fieldKey) {
    return fieldVerified[fieldKey] ?? false;
  }

  /// Get all fields that require verification but haven't been verified
  List<String> getUnverifiedFields(List<PreFilledField> preFilledFields) {
    return preFilledFields
        .where((field) => field.requiresVerification && !isVerified(field.formFieldKey))
        .map((field) => field.formFieldKey)
        .toList();
  }

  /// Check if form is complete
  bool isComplete(
    List<PreFilledField> preFilledFields,
    List<ApplicationQuestion> additionalQuestions,
  ) {
    // All verification fields must be verified
    final unverified = getUnverifiedFields(preFilledFields);
    if (unverified.isNotEmpty) return false;

    // All required additional questions must be answered
    for (final question in additionalQuestions) {
      if (question.required) {
        final value = getValue(question.fieldKey);
        if (value == null || value.toString().isEmpty) {
          return false;
        }
      }
    }

    return true;
  }

  /// Get completion percentage
  double getCompletionPercentage(
    List<PreFilledField> preFilledFields,
    List<ApplicationQuestion> additionalQuestions,
  ) {
    final totalFields =
        preFilledFields.length + additionalQuestions.where((q) => q.required).length;
    if (totalFields == 0) return 100.0;

    final verifiedCount = preFilledFields
        .where((f) => !f.requiresVerification || isVerified(f.formFieldKey))
        .length;

    final answeredCount = additionalQuestions.where((q) => q.required).where((q) {
      final value = getValue(q.fieldKey);
      return value != null && value.toString().isNotEmpty;
    }).length;

    return ((verifiedCount + answeredCount) / totalFields) * 100;
  }
}
