// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visa_eligibility_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisaEligibilityResult {

@JsonKey(name: 'eligible_visas') List<EligibleVisa> get eligibleVisas;@JsonKey(name: 'ineligible_reasons') List<String> get ineligibleReasons; String get confidence;
/// Create a copy of VisaEligibilityResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaEligibilityResultCopyWith<VisaEligibilityResult> get copyWith => _$VisaEligibilityResultCopyWithImpl<VisaEligibilityResult>(this as VisaEligibilityResult, _$identity);

  /// Serializes this VisaEligibilityResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaEligibilityResult&&const DeepCollectionEquality().equals(other.eligibleVisas, eligibleVisas)&&const DeepCollectionEquality().equals(other.ineligibleReasons, ineligibleReasons)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(eligibleVisas),const DeepCollectionEquality().hash(ineligibleReasons),confidence);

@override
String toString() {
  return 'VisaEligibilityResult(eligibleVisas: $eligibleVisas, ineligibleReasons: $ineligibleReasons, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $VisaEligibilityResultCopyWith<$Res>  {
  factory $VisaEligibilityResultCopyWith(VisaEligibilityResult value, $Res Function(VisaEligibilityResult) _then) = _$VisaEligibilityResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'eligible_visas') List<EligibleVisa> eligibleVisas,@JsonKey(name: 'ineligible_reasons') List<String> ineligibleReasons, String confidence
});




}
/// @nodoc
class _$VisaEligibilityResultCopyWithImpl<$Res>
    implements $VisaEligibilityResultCopyWith<$Res> {
  _$VisaEligibilityResultCopyWithImpl(this._self, this._then);

  final VisaEligibilityResult _self;
  final $Res Function(VisaEligibilityResult) _then;

/// Create a copy of VisaEligibilityResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eligibleVisas = null,Object? ineligibleReasons = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
eligibleVisas: null == eligibleVisas ? _self.eligibleVisas : eligibleVisas // ignore: cast_nullable_to_non_nullable
as List<EligibleVisa>,ineligibleReasons: null == ineligibleReasons ? _self.ineligibleReasons : ineligibleReasons // ignore: cast_nullable_to_non_nullable
as List<String>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VisaEligibilityResult].
extension VisaEligibilityResultPatterns on VisaEligibilityResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisaEligibilityResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisaEligibilityResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisaEligibilityResult value)  $default,){
final _that = this;
switch (_that) {
case _VisaEligibilityResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisaEligibilityResult value)?  $default,){
final _that = this;
switch (_that) {
case _VisaEligibilityResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'eligible_visas')  List<EligibleVisa> eligibleVisas, @JsonKey(name: 'ineligible_reasons')  List<String> ineligibleReasons,  String confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaEligibilityResult() when $default != null:
return $default(_that.eligibleVisas,_that.ineligibleReasons,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'eligible_visas')  List<EligibleVisa> eligibleVisas, @JsonKey(name: 'ineligible_reasons')  List<String> ineligibleReasons,  String confidence)  $default,) {final _that = this;
switch (_that) {
case _VisaEligibilityResult():
return $default(_that.eligibleVisas,_that.ineligibleReasons,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'eligible_visas')  List<EligibleVisa> eligibleVisas, @JsonKey(name: 'ineligible_reasons')  List<String> ineligibleReasons,  String confidence)?  $default,) {final _that = this;
switch (_that) {
case _VisaEligibilityResult() when $default != null:
return $default(_that.eligibleVisas,_that.ineligibleReasons,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaEligibilityResult implements VisaEligibilityResult {
  const _VisaEligibilityResult({@JsonKey(name: 'eligible_visas') required final  List<EligibleVisa> eligibleVisas, @JsonKey(name: 'ineligible_reasons') required final  List<String> ineligibleReasons, required this.confidence}): _eligibleVisas = eligibleVisas,_ineligibleReasons = ineligibleReasons;
  factory _VisaEligibilityResult.fromJson(Map<String, dynamic> json) => _$VisaEligibilityResultFromJson(json);

 final  List<EligibleVisa> _eligibleVisas;
@override@JsonKey(name: 'eligible_visas') List<EligibleVisa> get eligibleVisas {
  if (_eligibleVisas is EqualUnmodifiableListView) return _eligibleVisas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eligibleVisas);
}

 final  List<String> _ineligibleReasons;
@override@JsonKey(name: 'ineligible_reasons') List<String> get ineligibleReasons {
  if (_ineligibleReasons is EqualUnmodifiableListView) return _ineligibleReasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ineligibleReasons);
}

@override final  String confidence;

/// Create a copy of VisaEligibilityResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisaEligibilityResultCopyWith<_VisaEligibilityResult> get copyWith => __$VisaEligibilityResultCopyWithImpl<_VisaEligibilityResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisaEligibilityResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaEligibilityResult&&const DeepCollectionEquality().equals(other._eligibleVisas, _eligibleVisas)&&const DeepCollectionEquality().equals(other._ineligibleReasons, _ineligibleReasons)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_eligibleVisas),const DeepCollectionEquality().hash(_ineligibleReasons),confidence);

@override
String toString() {
  return 'VisaEligibilityResult(eligibleVisas: $eligibleVisas, ineligibleReasons: $ineligibleReasons, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$VisaEligibilityResultCopyWith<$Res> implements $VisaEligibilityResultCopyWith<$Res> {
  factory _$VisaEligibilityResultCopyWith(_VisaEligibilityResult value, $Res Function(_VisaEligibilityResult) _then) = __$VisaEligibilityResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'eligible_visas') List<EligibleVisa> eligibleVisas,@JsonKey(name: 'ineligible_reasons') List<String> ineligibleReasons, String confidence
});




}
/// @nodoc
class __$VisaEligibilityResultCopyWithImpl<$Res>
    implements _$VisaEligibilityResultCopyWith<$Res> {
  __$VisaEligibilityResultCopyWithImpl(this._self, this._then);

  final _VisaEligibilityResult _self;
  final $Res Function(_VisaEligibilityResult) _then;

/// Create a copy of VisaEligibilityResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eligibleVisas = null,Object? ineligibleReasons = null,Object? confidence = null,}) {
  return _then(_VisaEligibilityResult(
eligibleVisas: null == eligibleVisas ? _self._eligibleVisas : eligibleVisas // ignore: cast_nullable_to_non_nullable
as List<EligibleVisa>,ineligibleReasons: null == ineligibleReasons ? _self._ineligibleReasons : ineligibleReasons // ignore: cast_nullable_to_non_nullable
as List<String>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$EligibleVisa {

@JsonKey(name: 'visa_type') String get visaType; String get reason;@JsonKey(name: 'next_steps') List<String>? get nextSteps;
/// Create a copy of EligibleVisa
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EligibleVisaCopyWith<EligibleVisa> get copyWith => _$EligibleVisaCopyWithImpl<EligibleVisa>(this as EligibleVisa, _$identity);

  /// Serializes this EligibleVisa to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EligibleVisa&&(identical(other.visaType, visaType) || other.visaType == visaType)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.nextSteps, nextSteps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,visaType,reason,const DeepCollectionEquality().hash(nextSteps));

@override
String toString() {
  return 'EligibleVisa(visaType: $visaType, reason: $reason, nextSteps: $nextSteps)';
}


}

/// @nodoc
abstract mixin class $EligibleVisaCopyWith<$Res>  {
  factory $EligibleVisaCopyWith(EligibleVisa value, $Res Function(EligibleVisa) _then) = _$EligibleVisaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'visa_type') String visaType, String reason,@JsonKey(name: 'next_steps') List<String>? nextSteps
});




}
/// @nodoc
class _$EligibleVisaCopyWithImpl<$Res>
    implements $EligibleVisaCopyWith<$Res> {
  _$EligibleVisaCopyWithImpl(this._self, this._then);

  final EligibleVisa _self;
  final $Res Function(EligibleVisa) _then;

/// Create a copy of EligibleVisa
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? visaType = null,Object? reason = null,Object? nextSteps = freezed,}) {
  return _then(_self.copyWith(
visaType: null == visaType ? _self.visaType : visaType // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,nextSteps: freezed == nextSteps ? _self.nextSteps : nextSteps // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [EligibleVisa].
extension EligibleVisaPatterns on EligibleVisa {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EligibleVisa value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EligibleVisa() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EligibleVisa value)  $default,){
final _that = this;
switch (_that) {
case _EligibleVisa():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EligibleVisa value)?  $default,){
final _that = this;
switch (_that) {
case _EligibleVisa() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'visa_type')  String visaType,  String reason, @JsonKey(name: 'next_steps')  List<String>? nextSteps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EligibleVisa() when $default != null:
return $default(_that.visaType,_that.reason,_that.nextSteps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'visa_type')  String visaType,  String reason, @JsonKey(name: 'next_steps')  List<String>? nextSteps)  $default,) {final _that = this;
switch (_that) {
case _EligibleVisa():
return $default(_that.visaType,_that.reason,_that.nextSteps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'visa_type')  String visaType,  String reason, @JsonKey(name: 'next_steps')  List<String>? nextSteps)?  $default,) {final _that = this;
switch (_that) {
case _EligibleVisa() when $default != null:
return $default(_that.visaType,_that.reason,_that.nextSteps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EligibleVisa implements EligibleVisa {
  const _EligibleVisa({@JsonKey(name: 'visa_type') required this.visaType, required this.reason, @JsonKey(name: 'next_steps') final  List<String>? nextSteps}): _nextSteps = nextSteps;
  factory _EligibleVisa.fromJson(Map<String, dynamic> json) => _$EligibleVisaFromJson(json);

@override@JsonKey(name: 'visa_type') final  String visaType;
@override final  String reason;
 final  List<String>? _nextSteps;
@override@JsonKey(name: 'next_steps') List<String>? get nextSteps {
  final value = _nextSteps;
  if (value == null) return null;
  if (_nextSteps is EqualUnmodifiableListView) return _nextSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of EligibleVisa
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EligibleVisaCopyWith<_EligibleVisa> get copyWith => __$EligibleVisaCopyWithImpl<_EligibleVisa>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EligibleVisaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EligibleVisa&&(identical(other.visaType, visaType) || other.visaType == visaType)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other._nextSteps, _nextSteps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,visaType,reason,const DeepCollectionEquality().hash(_nextSteps));

@override
String toString() {
  return 'EligibleVisa(visaType: $visaType, reason: $reason, nextSteps: $nextSteps)';
}


}

/// @nodoc
abstract mixin class _$EligibleVisaCopyWith<$Res> implements $EligibleVisaCopyWith<$Res> {
  factory _$EligibleVisaCopyWith(_EligibleVisa value, $Res Function(_EligibleVisa) _then) = __$EligibleVisaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'visa_type') String visaType, String reason,@JsonKey(name: 'next_steps') List<String>? nextSteps
});




}
/// @nodoc
class __$EligibleVisaCopyWithImpl<$Res>
    implements _$EligibleVisaCopyWith<$Res> {
  __$EligibleVisaCopyWithImpl(this._self, this._then);

  final _EligibleVisa _self;
  final $Res Function(_EligibleVisa) _then;

/// Create a copy of EligibleVisa
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? visaType = null,Object? reason = null,Object? nextSteps = freezed,}) {
  return _then(_EligibleVisa(
visaType: null == visaType ? _self.visaType : visaType // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,nextSteps: freezed == nextSteps ? _self._nextSteps : nextSteps // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
