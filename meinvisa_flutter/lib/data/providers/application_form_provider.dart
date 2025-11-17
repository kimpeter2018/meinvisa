import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/application_form_data_model/application_form_data_model.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';

final applicationFormProvider = StateNotifierProvider.autoDispose
    .family<ApplicationFormNotifier, ApplicationFormData, VisaRecommendationResponse>(
      (ref, recommendation) => ApplicationFormNotifier(recommendation),
    );

class ApplicationFormNotifier extends StateNotifier<ApplicationFormData> {
  final VisaRecommendationResponse recommendation;

  ApplicationFormNotifier(this.recommendation) : super(const ApplicationFormData()) {
    _initializePreFilledData();
  }

  void _initializePreFilledData() {
    final metadata = recommendation.applicationMetadata;
    if (metadata == null) return;

    final preFilledMap = <String, dynamic>{};
    for (final field in metadata.preFilledFields) {
      preFilledMap[field.formFieldKey] = field.value;
    }

    state = state.copyWith(preFilledData: preFilledMap);
  }

  /// Update a field value
  void updateField(String fieldKey, dynamic value) {
    state = state.copyWith(editedData: {...state.editedData, fieldKey: value});
  }

  /// Mark a field as verified
  void verifyField(String fieldKey) {
    state = state.copyWith(fieldVerified: {...state.fieldVerified, fieldKey: true});
  }

  /// Update additional question answer
  void updateAdditionalAnswer(String fieldKey, dynamic value) {
    state = state.copyWith(additionalData: {...state.additionalData, fieldKey: value});
  }

  /// Get current value for a field
  dynamic getFieldValue(String fieldKey) {
    return state.getValue(fieldKey);
  }

  /// Check if field is verified
  bool isFieldVerified(String fieldKey) {
    return state.isVerified(fieldKey);
  }

  /// Get completion percentage
  double getCompletionPercentage() {
    final metadata = recommendation.applicationMetadata;
    if (metadata == null) return 0.0;

    return state.getCompletionPercentage(metadata.preFilledFields, metadata.additionalQuestions);
  }

  /// Check if form is complete
  bool isFormComplete() {
    final metadata = recommendation.applicationMetadata;
    if (metadata == null) return false;

    return state.isComplete(metadata.preFilledFields, metadata.additionalQuestions);
  }

  /// Get all unverified fields
  List<String> getUnverifiedFields() {
    final metadata = recommendation.applicationMetadata;
    if (metadata == null) return [];

    return state.getUnverifiedFields(metadata.preFilledFields);
  }

  /// Reset form
  void reset() {
    state = const ApplicationFormData();
    _initializePreFilledData();
  }
}
