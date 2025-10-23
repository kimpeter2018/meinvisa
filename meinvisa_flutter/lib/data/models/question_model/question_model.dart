// lib/data/models/question_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
abstract class Question with _$Question {
  const factory Question({
    required String id,
    required String category,
    required String questionText,
    required String type, // "text", "dropdown", "number", etc.
    List<String>? options, // for dropdowns
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
