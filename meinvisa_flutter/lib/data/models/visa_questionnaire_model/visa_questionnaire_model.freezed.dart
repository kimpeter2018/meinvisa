// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visa_questionnaire_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisaQuestionnaire {

@JsonKey(name: 'occupation_code') String get occupationCode;@JsonKey(name: 'nationality') String get nationality;@JsonKey(name: 'current_salary') double? get currentSalary;@JsonKey(name: 'has_recognition') bool? get hasRecognition;@JsonKey(name: 'age') int? get age;@JsonKey(name: 'location_applied_from') String? get countryOfResidence;
/// Create a copy of VisaQuestionnaire
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaQuestionnaireCopyWith<VisaQuestionnaire> get copyWith => _$VisaQuestionnaireCopyWithImpl<VisaQuestionnaire>(this as VisaQuestionnaire, _$identity);

  /// Serializes this VisaQuestionnaire to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaQuestionnaire&&(identical(other.occupationCode, occupationCode) || other.occupationCode == occupationCode)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.currentSalary, currentSalary) || other.currentSalary == currentSalary)&&(identical(other.hasRecognition, hasRecognition) || other.hasRecognition == hasRecognition)&&(identical(other.age, age) || other.age == age)&&(identical(other.countryOfResidence, countryOfResidence) || other.countryOfResidence == countryOfResidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,occupationCode,nationality,currentSalary,hasRecognition,age,countryOfResidence);

@override
String toString() {
  return 'VisaQuestionnaire(occupationCode: $occupationCode, nationality: $nationality, currentSalary: $currentSalary, hasRecognition: $hasRecognition, age: $age, countryOfResidence: $countryOfResidence)';
}


}

/// @nodoc
abstract mixin class $VisaQuestionnaireCopyWith<$Res>  {
  factory $VisaQuestionnaireCopyWith(VisaQuestionnaire value, $Res Function(VisaQuestionnaire) _then) = _$VisaQuestionnaireCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'occupation_code') String occupationCode,@JsonKey(name: 'nationality') String nationality,@JsonKey(name: 'current_salary') double? currentSalary,@JsonKey(name: 'has_recognition') bool? hasRecognition,@JsonKey(name: 'age') int? age,@JsonKey(name: 'location_applied_from') String? countryOfResidence
});




}
/// @nodoc
class _$VisaQuestionnaireCopyWithImpl<$Res>
    implements $VisaQuestionnaireCopyWith<$Res> {
  _$VisaQuestionnaireCopyWithImpl(this._self, this._then);

  final VisaQuestionnaire _self;
  final $Res Function(VisaQuestionnaire) _then;

/// Create a copy of VisaQuestionnaire
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? occupationCode = null,Object? nationality = null,Object? currentSalary = freezed,Object? hasRecognition = freezed,Object? age = freezed,Object? countryOfResidence = freezed,}) {
  return _then(_self.copyWith(
occupationCode: null == occupationCode ? _self.occupationCode : occupationCode // ignore: cast_nullable_to_non_nullable
as String,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,currentSalary: freezed == currentSalary ? _self.currentSalary : currentSalary // ignore: cast_nullable_to_non_nullable
as double?,hasRecognition: freezed == hasRecognition ? _self.hasRecognition : hasRecognition // ignore: cast_nullable_to_non_nullable
as bool?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,countryOfResidence: freezed == countryOfResidence ? _self.countryOfResidence : countryOfResidence // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisaQuestionnaire].
extension VisaQuestionnairePatterns on VisaQuestionnaire {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisaQuestionnaire value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisaQuestionnaire() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisaQuestionnaire value)  $default,){
final _that = this;
switch (_that) {
case _VisaQuestionnaire():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisaQuestionnaire value)?  $default,){
final _that = this;
switch (_that) {
case _VisaQuestionnaire() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'occupation_code')  String occupationCode, @JsonKey(name: 'nationality')  String nationality, @JsonKey(name: 'current_salary')  double? currentSalary, @JsonKey(name: 'has_recognition')  bool? hasRecognition, @JsonKey(name: 'age')  int? age, @JsonKey(name: 'location_applied_from')  String? countryOfResidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaQuestionnaire() when $default != null:
return $default(_that.occupationCode,_that.nationality,_that.currentSalary,_that.hasRecognition,_that.age,_that.countryOfResidence);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'occupation_code')  String occupationCode, @JsonKey(name: 'nationality')  String nationality, @JsonKey(name: 'current_salary')  double? currentSalary, @JsonKey(name: 'has_recognition')  bool? hasRecognition, @JsonKey(name: 'age')  int? age, @JsonKey(name: 'location_applied_from')  String? countryOfResidence)  $default,) {final _that = this;
switch (_that) {
case _VisaQuestionnaire():
return $default(_that.occupationCode,_that.nationality,_that.currentSalary,_that.hasRecognition,_that.age,_that.countryOfResidence);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'occupation_code')  String occupationCode, @JsonKey(name: 'nationality')  String nationality, @JsonKey(name: 'current_salary')  double? currentSalary, @JsonKey(name: 'has_recognition')  bool? hasRecognition, @JsonKey(name: 'age')  int? age, @JsonKey(name: 'location_applied_from')  String? countryOfResidence)?  $default,) {final _that = this;
switch (_that) {
case _VisaQuestionnaire() when $default != null:
return $default(_that.occupationCode,_that.nationality,_that.currentSalary,_that.hasRecognition,_that.age,_that.countryOfResidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaQuestionnaire implements VisaQuestionnaire {
  const _VisaQuestionnaire({@JsonKey(name: 'occupation_code') required this.occupationCode, @JsonKey(name: 'nationality') required this.nationality, @JsonKey(name: 'current_salary') this.currentSalary, @JsonKey(name: 'has_recognition') this.hasRecognition, @JsonKey(name: 'age') this.age, @JsonKey(name: 'location_applied_from') this.countryOfResidence});
  factory _VisaQuestionnaire.fromJson(Map<String, dynamic> json) => _$VisaQuestionnaireFromJson(json);

@override@JsonKey(name: 'occupation_code') final  String occupationCode;
@override@JsonKey(name: 'nationality') final  String nationality;
@override@JsonKey(name: 'current_salary') final  double? currentSalary;
@override@JsonKey(name: 'has_recognition') final  bool? hasRecognition;
@override@JsonKey(name: 'age') final  int? age;
@override@JsonKey(name: 'location_applied_from') final  String? countryOfResidence;

/// Create a copy of VisaQuestionnaire
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisaQuestionnaireCopyWith<_VisaQuestionnaire> get copyWith => __$VisaQuestionnaireCopyWithImpl<_VisaQuestionnaire>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisaQuestionnaireToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaQuestionnaire&&(identical(other.occupationCode, occupationCode) || other.occupationCode == occupationCode)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.currentSalary, currentSalary) || other.currentSalary == currentSalary)&&(identical(other.hasRecognition, hasRecognition) || other.hasRecognition == hasRecognition)&&(identical(other.age, age) || other.age == age)&&(identical(other.countryOfResidence, countryOfResidence) || other.countryOfResidence == countryOfResidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,occupationCode,nationality,currentSalary,hasRecognition,age,countryOfResidence);

@override
String toString() {
  return 'VisaQuestionnaire(occupationCode: $occupationCode, nationality: $nationality, currentSalary: $currentSalary, hasRecognition: $hasRecognition, age: $age, countryOfResidence: $countryOfResidence)';
}


}

/// @nodoc
abstract mixin class _$VisaQuestionnaireCopyWith<$Res> implements $VisaQuestionnaireCopyWith<$Res> {
  factory _$VisaQuestionnaireCopyWith(_VisaQuestionnaire value, $Res Function(_VisaQuestionnaire) _then) = __$VisaQuestionnaireCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'occupation_code') String occupationCode,@JsonKey(name: 'nationality') String nationality,@JsonKey(name: 'current_salary') double? currentSalary,@JsonKey(name: 'has_recognition') bool? hasRecognition,@JsonKey(name: 'age') int? age,@JsonKey(name: 'location_applied_from') String? countryOfResidence
});




}
/// @nodoc
class __$VisaQuestionnaireCopyWithImpl<$Res>
    implements _$VisaQuestionnaireCopyWith<$Res> {
  __$VisaQuestionnaireCopyWithImpl(this._self, this._then);

  final _VisaQuestionnaire _self;
  final $Res Function(_VisaQuestionnaire) _then;

/// Create a copy of VisaQuestionnaire
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? occupationCode = null,Object? nationality = null,Object? currentSalary = freezed,Object? hasRecognition = freezed,Object? age = freezed,Object? countryOfResidence = freezed,}) {
  return _then(_VisaQuestionnaire(
occupationCode: null == occupationCode ? _self.occupationCode : occupationCode // ignore: cast_nullable_to_non_nullable
as String,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,currentSalary: freezed == currentSalary ? _self.currentSalary : currentSalary // ignore: cast_nullable_to_non_nullable
as double?,hasRecognition: freezed == hasRecognition ? _self.hasRecognition : hasRecognition // ignore: cast_nullable_to_non_nullable
as bool?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,countryOfResidence: freezed == countryOfResidence ? _self.countryOfResidence : countryOfResidence // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
