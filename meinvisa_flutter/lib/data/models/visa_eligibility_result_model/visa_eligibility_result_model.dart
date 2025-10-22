// lib/data/models/visa_eligibility_result_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'visa_eligibility_result_model.freezed.dart';
part 'visa_eligibility_result_model.g.dart';

@freezed
abstract class VisaEligibilityResult with _$VisaEligibilityResult {
  const factory VisaEligibilityResult({
    @JsonKey(name: 'eligible_visas') required List<EligibleVisa> eligibleVisas,

    @JsonKey(name: 'ineligible_reasons')
    required List<String> ineligibleReasons,

    required String confidence,
  }) = _VisaEligibilityResult;

  factory VisaEligibilityResult.fromJson(Map<String, dynamic> json) =>
      _$VisaEligibilityResultFromJson(json);
}

@freezed
abstract class EligibleVisa with _$EligibleVisa {
  const factory EligibleVisa({
    @JsonKey(name: 'visa_type') required String visaType,
    required String reason,
    @JsonKey(name: 'next_steps') List<String>? nextSteps,
  }) = _EligibleVisa;

  factory EligibleVisa.fromJson(Map<String, dynamic> json) =>
      _$EligibleVisaFromJson(json);
}
