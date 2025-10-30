import 'package:freezed_annotation/freezed_annotation.dart';

part 'visa_question_path_model.freezed.dart';
part 'visa_question_path_model.g.dart';

@freezed
abstract class VisaQuestionPath with _$VisaQuestionPath {
  const factory VisaQuestionPath({
    required String id, // uuid in DB
    required String fromField,
    String? answerValue,
    @Default([]) List<String> nextCategories,
    @Default([]) List<String> nextQuestionKeys,
    required String? conditionType,
    String? description,
  }) = _VisaQuestionPath;

  factory VisaQuestionPath.fromJson(Map<String, dynamic> json) =>
      _$VisaQuestionPathFromJson(json);
}
