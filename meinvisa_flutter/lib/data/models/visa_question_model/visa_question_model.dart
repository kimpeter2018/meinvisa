import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meinvisa/core/services/question_type_converter.dart';
import 'package:meinvisa/data/models/visa_question_model/question_type.dart';

part 'visa_question_model.freezed.dart';
part 'visa_question_model.g.dart';

@freezed
abstract class VisaQuestion with _$VisaQuestion {
  const factory VisaQuestion({
    required String uid, // Supabase-generated UUID
    required int id, // Optional sequential ID
    required String category, // e.g. 'universal', 'work:general'
    required String question,
    required String fieldKey,
    @QuestionTypeConverter() required QuestionType questionType,
    String? purpose,
    String? optionsSource,
    @Default([]) List<String> options,
    @Default(false) bool required,
    int? orderIndex,
  }) = _VisaQuestion;

  factory VisaQuestion.fromJson(Map<String, dynamic> json) =>
      _$VisaQuestionFromJson(json);
}
