import 'package:freezed_annotation/freezed_annotation.dart';

part 'visa_recommendation_response_model.freezed.dart';
part 'visa_recommendation_response_model.g.dart';

@freezed
abstract class VisaRecommendationResponse with _$VisaRecommendationResponse {
  const factory VisaRecommendationResponse({
    required VisaOption recommended,
    @Default([]) List<VisaOption> alternatives,
    @Default([]) List<String> notes,
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
    @Default([]) List<String> requirements,
    @Default([]) List<String> notes,
  }) = _VisaOption;

  factory VisaOption.fromJson(Map<String, dynamic> json) => _$VisaOptionFromJson(json);
}
