// // lib/data/models/visa_recommendation_response_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'visa_recommendation_response_model.freezed.dart';
// part 'visa_recommendation_response_model.g.dart';

// @freezed
// abstract class VisaRecommendationResponse with _$VisaRecommendationResponse {
//   const factory VisaRecommendationResponse({
//     String? nationality,
//     String? occupation,
//     String? educationLevel,
//     String? languageProficiency,
//     String? countryOfResidence,
//     String? targetCountry,
//     int? workExperienceYears,
//     String? desiredVisaType, // if user already has one in mind
//     bool? hasJobOffer,
//     bool? hasRelativesAbroad,
//   }) = _VisaRecommendationResponse;

//   factory VisaRecommendationResponse.fromJson(Map<String, dynamic> json) =>
//       _$VisaRecommendationResponseFromJson(json);
// }
