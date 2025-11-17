import 'package:freezed_annotation/freezed_annotation.dart';

enum QuestionType {
  @JsonValue('select')
  select,
  @JsonValue('number')
  number,
  @JsonValue('boolean')
  boolean,
  @JsonValue('checkbox')
  checkbox,
  @JsonValue('date')
  date,
  @JsonValue('text')
  text,
  @JsonValue('autocomplete')
  autocomplete,
}
