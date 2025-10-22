// lib/data/models/visa_questionnaire_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'visa_questionnaire_model.freezed.dart';
part 'visa_questionnaire_model.g.dart';

@freezed
abstract class VisaQuestionnaire with _$VisaQuestionnaire {
  const factory VisaQuestionnaire({
    @JsonKey(name: 'occupation_code') required String occupationCode,
    @JsonKey(name: 'nationality') required String nationality,
    @JsonKey(name: 'current_salary') double? currentSalary,
    @JsonKey(name: 'has_recognition') bool? hasRecognition,
    @JsonKey(name: 'age') int? age,
    @JsonKey(name: 'location_applied_from') String? countryOfResidence,
  }) = _VisaQuestionnaire;

  factory VisaQuestionnaire.fromJson(Map<String, dynamic> json) =>
      _$VisaQuestionnaireFromJson(json);
}
