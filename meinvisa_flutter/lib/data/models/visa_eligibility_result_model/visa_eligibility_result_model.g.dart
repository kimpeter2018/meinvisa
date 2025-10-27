// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_eligibility_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaEligibilityResult _$VisaEligibilityResultFromJson(
  Map<String, dynamic> json,
) => _VisaEligibilityResult(
  eligibleVisas: (json['eligible_visas'] as List<dynamic>)
      .map((e) => EligibleVisa.fromJson(e as Map<String, dynamic>))
      .toList(),
  ineligibleReasons: (json['ineligible_reasons'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  confidence: json['confidence'] as String,
);

Map<String, dynamic> _$VisaEligibilityResultToJson(
  _VisaEligibilityResult instance,
) => <String, dynamic>{
  'eligible_visas': instance.eligibleVisas.map((e) => e.toJson()).toList(),
  'ineligible_reasons': instance.ineligibleReasons,
  'confidence': instance.confidence,
};

_EligibleVisa _$EligibleVisaFromJson(Map<String, dynamic> json) =>
    _EligibleVisa(
      visaType: json['visa_type'] as String,
      reason: json['reason'] as String,
      nextSteps: (json['next_steps'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EligibleVisaToJson(_EligibleVisa instance) =>
    <String, dynamic>{
      'visa_type': instance.visaType,
      'reason': instance.reason,
      'next_steps': instance.nextSteps,
    };
