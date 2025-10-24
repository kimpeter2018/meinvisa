import 'package:freezed_annotation/freezed_annotation.dart';

part 'visa_question_model.freezed.dart';
part 'visa_question_model.g.dart';

@freezed
abstract class VisaQuestion with _$VisaQuestion {
  const factory VisaQuestion({
    required String id,
    required String category,
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'field_key') required String fieldKey,
    @JsonKey(name: 'question_type') required String questionType,
    @JsonKey(name: 'options_source') String? optionsSource,
    @JsonKey(name: 'required') bool? isRequired,
    @JsonKey(name: 'order_index') int? orderIndex,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _VisaQuestion;

  factory VisaQuestion.fromJson(Map<String, dynamic> json) =>
      _$VisaQuestionFromJson(json);
}
