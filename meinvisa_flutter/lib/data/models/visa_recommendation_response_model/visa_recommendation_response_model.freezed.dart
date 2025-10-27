// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visa_recommendation_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisaRecommendationResponse {

 String? get nationality; String? get occupation; String? get educationLevel; String? get languageProficiency; String? get countryOfResidence; String? get targetCountry; int? get workExperienceYears; String? get desiredVisaType;// if user already has one in mind
 bool? get hasJobOffer; bool? get hasRelativesAbroad;
/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaRecommendationResponseCopyWith<VisaRecommendationResponse> get copyWith => _$VisaRecommendationResponseCopyWithImpl<VisaRecommendationResponse>(this as VisaRecommendationResponse, _$identity);

  /// Serializes this VisaRecommendationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaRecommendationResponse&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.languageProficiency, languageProficiency) || other.languageProficiency == languageProficiency)&&(identical(other.countryOfResidence, countryOfResidence) || other.countryOfResidence == countryOfResidence)&&(identical(other.targetCountry, targetCountry) || other.targetCountry == targetCountry)&&(identical(other.workExperienceYears, workExperienceYears) || other.workExperienceYears == workExperienceYears)&&(identical(other.desiredVisaType, desiredVisaType) || other.desiredVisaType == desiredVisaType)&&(identical(other.hasJobOffer, hasJobOffer) || other.hasJobOffer == hasJobOffer)&&(identical(other.hasRelativesAbroad, hasRelativesAbroad) || other.hasRelativesAbroad == hasRelativesAbroad));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nationality,occupation,educationLevel,languageProficiency,countryOfResidence,targetCountry,workExperienceYears,desiredVisaType,hasJobOffer,hasRelativesAbroad);

@override
String toString() {
  return 'VisaRecommendationResponse(nationality: $nationality, occupation: $occupation, educationLevel: $educationLevel, languageProficiency: $languageProficiency, countryOfResidence: $countryOfResidence, targetCountry: $targetCountry, workExperienceYears: $workExperienceYears, desiredVisaType: $desiredVisaType, hasJobOffer: $hasJobOffer, hasRelativesAbroad: $hasRelativesAbroad)';
}


}

/// @nodoc
abstract mixin class $VisaRecommendationResponseCopyWith<$Res>  {
  factory $VisaRecommendationResponseCopyWith(VisaRecommendationResponse value, $Res Function(VisaRecommendationResponse) _then) = _$VisaRecommendationResponseCopyWithImpl;
@useResult
$Res call({
 String? nationality, String? occupation, String? educationLevel, String? languageProficiency, String? countryOfResidence, String? targetCountry, int? workExperienceYears, String? desiredVisaType, bool? hasJobOffer, bool? hasRelativesAbroad
});




}
/// @nodoc
class _$VisaRecommendationResponseCopyWithImpl<$Res>
    implements $VisaRecommendationResponseCopyWith<$Res> {
  _$VisaRecommendationResponseCopyWithImpl(this._self, this._then);

  final VisaRecommendationResponse _self;
  final $Res Function(VisaRecommendationResponse) _then;

/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nationality = freezed,Object? occupation = freezed,Object? educationLevel = freezed,Object? languageProficiency = freezed,Object? countryOfResidence = freezed,Object? targetCountry = freezed,Object? workExperienceYears = freezed,Object? desiredVisaType = freezed,Object? hasJobOffer = freezed,Object? hasRelativesAbroad = freezed,}) {
  return _then(_self.copyWith(
nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,languageProficiency: freezed == languageProficiency ? _self.languageProficiency : languageProficiency // ignore: cast_nullable_to_non_nullable
as String?,countryOfResidence: freezed == countryOfResidence ? _self.countryOfResidence : countryOfResidence // ignore: cast_nullable_to_non_nullable
as String?,targetCountry: freezed == targetCountry ? _self.targetCountry : targetCountry // ignore: cast_nullable_to_non_nullable
as String?,workExperienceYears: freezed == workExperienceYears ? _self.workExperienceYears : workExperienceYears // ignore: cast_nullable_to_non_nullable
as int?,desiredVisaType: freezed == desiredVisaType ? _self.desiredVisaType : desiredVisaType // ignore: cast_nullable_to_non_nullable
as String?,hasJobOffer: freezed == hasJobOffer ? _self.hasJobOffer : hasJobOffer // ignore: cast_nullable_to_non_nullable
as bool?,hasRelativesAbroad: freezed == hasRelativesAbroad ? _self.hasRelativesAbroad : hasRelativesAbroad // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisaRecommendationResponse].
extension VisaRecommendationResponsePatterns on VisaRecommendationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisaRecommendationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisaRecommendationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisaRecommendationResponse value)  $default,){
final _that = this;
switch (_that) {
case _VisaRecommendationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisaRecommendationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _VisaRecommendationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? nationality,  String? occupation,  String? educationLevel,  String? languageProficiency,  String? countryOfResidence,  String? targetCountry,  int? workExperienceYears,  String? desiredVisaType,  bool? hasJobOffer,  bool? hasRelativesAbroad)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse() when $default != null:
return $default(_that.nationality,_that.occupation,_that.educationLevel,_that.languageProficiency,_that.countryOfResidence,_that.targetCountry,_that.workExperienceYears,_that.desiredVisaType,_that.hasJobOffer,_that.hasRelativesAbroad);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? nationality,  String? occupation,  String? educationLevel,  String? languageProficiency,  String? countryOfResidence,  String? targetCountry,  int? workExperienceYears,  String? desiredVisaType,  bool? hasJobOffer,  bool? hasRelativesAbroad)  $default,) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse():
return $default(_that.nationality,_that.occupation,_that.educationLevel,_that.languageProficiency,_that.countryOfResidence,_that.targetCountry,_that.workExperienceYears,_that.desiredVisaType,_that.hasJobOffer,_that.hasRelativesAbroad);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? nationality,  String? occupation,  String? educationLevel,  String? languageProficiency,  String? countryOfResidence,  String? targetCountry,  int? workExperienceYears,  String? desiredVisaType,  bool? hasJobOffer,  bool? hasRelativesAbroad)?  $default,) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse() when $default != null:
return $default(_that.nationality,_that.occupation,_that.educationLevel,_that.languageProficiency,_that.countryOfResidence,_that.targetCountry,_that.workExperienceYears,_that.desiredVisaType,_that.hasJobOffer,_that.hasRelativesAbroad);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaRecommendationResponse implements VisaRecommendationResponse {
  const _VisaRecommendationResponse({this.nationality, this.occupation, this.educationLevel, this.languageProficiency, this.countryOfResidence, this.targetCountry, this.workExperienceYears, this.desiredVisaType, this.hasJobOffer, this.hasRelativesAbroad});
  factory _VisaRecommendationResponse.fromJson(Map<String, dynamic> json) => _$VisaRecommendationResponseFromJson(json);

@override final  String? nationality;
@override final  String? occupation;
@override final  String? educationLevel;
@override final  String? languageProficiency;
@override final  String? countryOfResidence;
@override final  String? targetCountry;
@override final  int? workExperienceYears;
@override final  String? desiredVisaType;
// if user already has one in mind
@override final  bool? hasJobOffer;
@override final  bool? hasRelativesAbroad;

/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisaRecommendationResponseCopyWith<_VisaRecommendationResponse> get copyWith => __$VisaRecommendationResponseCopyWithImpl<_VisaRecommendationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisaRecommendationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaRecommendationResponse&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.languageProficiency, languageProficiency) || other.languageProficiency == languageProficiency)&&(identical(other.countryOfResidence, countryOfResidence) || other.countryOfResidence == countryOfResidence)&&(identical(other.targetCountry, targetCountry) || other.targetCountry == targetCountry)&&(identical(other.workExperienceYears, workExperienceYears) || other.workExperienceYears == workExperienceYears)&&(identical(other.desiredVisaType, desiredVisaType) || other.desiredVisaType == desiredVisaType)&&(identical(other.hasJobOffer, hasJobOffer) || other.hasJobOffer == hasJobOffer)&&(identical(other.hasRelativesAbroad, hasRelativesAbroad) || other.hasRelativesAbroad == hasRelativesAbroad));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nationality,occupation,educationLevel,languageProficiency,countryOfResidence,targetCountry,workExperienceYears,desiredVisaType,hasJobOffer,hasRelativesAbroad);

@override
String toString() {
  return 'VisaRecommendationResponse(nationality: $nationality, occupation: $occupation, educationLevel: $educationLevel, languageProficiency: $languageProficiency, countryOfResidence: $countryOfResidence, targetCountry: $targetCountry, workExperienceYears: $workExperienceYears, desiredVisaType: $desiredVisaType, hasJobOffer: $hasJobOffer, hasRelativesAbroad: $hasRelativesAbroad)';
}


}

/// @nodoc
abstract mixin class _$VisaRecommendationResponseCopyWith<$Res> implements $VisaRecommendationResponseCopyWith<$Res> {
  factory _$VisaRecommendationResponseCopyWith(_VisaRecommendationResponse value, $Res Function(_VisaRecommendationResponse) _then) = __$VisaRecommendationResponseCopyWithImpl;
@override @useResult
$Res call({
 String? nationality, String? occupation, String? educationLevel, String? languageProficiency, String? countryOfResidence, String? targetCountry, int? workExperienceYears, String? desiredVisaType, bool? hasJobOffer, bool? hasRelativesAbroad
});




}
/// @nodoc
class __$VisaRecommendationResponseCopyWithImpl<$Res>
    implements _$VisaRecommendationResponseCopyWith<$Res> {
  __$VisaRecommendationResponseCopyWithImpl(this._self, this._then);

  final _VisaRecommendationResponse _self;
  final $Res Function(_VisaRecommendationResponse) _then;

/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nationality = freezed,Object? occupation = freezed,Object? educationLevel = freezed,Object? languageProficiency = freezed,Object? countryOfResidence = freezed,Object? targetCountry = freezed,Object? workExperienceYears = freezed,Object? desiredVisaType = freezed,Object? hasJobOffer = freezed,Object? hasRelativesAbroad = freezed,}) {
  return _then(_VisaRecommendationResponse(
nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,languageProficiency: freezed == languageProficiency ? _self.languageProficiency : languageProficiency // ignore: cast_nullable_to_non_nullable
as String?,countryOfResidence: freezed == countryOfResidence ? _self.countryOfResidence : countryOfResidence // ignore: cast_nullable_to_non_nullable
as String?,targetCountry: freezed == targetCountry ? _self.targetCountry : targetCountry // ignore: cast_nullable_to_non_nullable
as String?,workExperienceYears: freezed == workExperienceYears ? _self.workExperienceYears : workExperienceYears // ignore: cast_nullable_to_non_nullable
as int?,desiredVisaType: freezed == desiredVisaType ? _self.desiredVisaType : desiredVisaType // ignore: cast_nullable_to_non_nullable
as String?,hasJobOffer: freezed == hasJobOffer ? _self.hasJobOffer : hasJobOffer // ignore: cast_nullable_to_non_nullable
as bool?,hasRelativesAbroad: freezed == hasRelativesAbroad ? _self.hasRelativesAbroad : hasRelativesAbroad // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
