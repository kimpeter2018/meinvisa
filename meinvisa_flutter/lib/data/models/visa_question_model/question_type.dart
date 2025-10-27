import 'package:freezed_annotation/freezed_annotation.dart';

enum QuestionType {
  @JsonValue('select')
  select,

  @JsonValue('dropdown')
  dropdown,

  @JsonValue('number')
  number,

  @JsonValue('checkbox')
  checkbox,

  @JsonValue('date')
  date,

  @JsonValue('text')
  text,
}
