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

 VisaOption get recommended; List<VisaOption> get alternatives; List<String> get notes; ApplicationMetadata? get applicationMetadata;
/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaRecommendationResponseCopyWith<VisaRecommendationResponse> get copyWith => _$VisaRecommendationResponseCopyWithImpl<VisaRecommendationResponse>(this as VisaRecommendationResponse, _$identity);

  /// Serializes this VisaRecommendationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaRecommendationResponse&&(identical(other.recommended, recommended) || other.recommended == recommended)&&const DeepCollectionEquality().equals(other.alternatives, alternatives)&&const DeepCollectionEquality().equals(other.notes, notes)&&(identical(other.applicationMetadata, applicationMetadata) || other.applicationMetadata == applicationMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recommended,const DeepCollectionEquality().hash(alternatives),const DeepCollectionEquality().hash(notes),applicationMetadata);

@override
String toString() {
  return 'VisaRecommendationResponse(recommended: $recommended, alternatives: $alternatives, notes: $notes, applicationMetadata: $applicationMetadata)';
}


}

/// @nodoc
abstract mixin class $VisaRecommendationResponseCopyWith<$Res>  {
  factory $VisaRecommendationResponseCopyWith(VisaRecommendationResponse value, $Res Function(VisaRecommendationResponse) _then) = _$VisaRecommendationResponseCopyWithImpl;
@useResult
$Res call({
 VisaOption recommended, List<VisaOption> alternatives, List<String> notes, ApplicationMetadata? applicationMetadata
});


$VisaOptionCopyWith<$Res> get recommended;$ApplicationMetadataCopyWith<$Res>? get applicationMetadata;

}
/// @nodoc
class _$VisaRecommendationResponseCopyWithImpl<$Res>
    implements $VisaRecommendationResponseCopyWith<$Res> {
  _$VisaRecommendationResponseCopyWithImpl(this._self, this._then);

  final VisaRecommendationResponse _self;
  final $Res Function(VisaRecommendationResponse) _then;

/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recommended = null,Object? alternatives = null,Object? notes = null,Object? applicationMetadata = freezed,}) {
  return _then(_self.copyWith(
recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as VisaOption,alternatives: null == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<VisaOption>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>,applicationMetadata: freezed == applicationMetadata ? _self.applicationMetadata : applicationMetadata // ignore: cast_nullable_to_non_nullable
as ApplicationMetadata?,
  ));
}
/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VisaOptionCopyWith<$Res> get recommended {
  
  return $VisaOptionCopyWith<$Res>(_self.recommended, (value) {
    return _then(_self.copyWith(recommended: value));
  });
}/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationMetadataCopyWith<$Res>? get applicationMetadata {
    if (_self.applicationMetadata == null) {
    return null;
  }

  return $ApplicationMetadataCopyWith<$Res>(_self.applicationMetadata!, (value) {
    return _then(_self.copyWith(applicationMetadata: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VisaOption recommended,  List<VisaOption> alternatives,  List<String> notes,  ApplicationMetadata? applicationMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse() when $default != null:
return $default(_that.recommended,_that.alternatives,_that.notes,_that.applicationMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VisaOption recommended,  List<VisaOption> alternatives,  List<String> notes,  ApplicationMetadata? applicationMetadata)  $default,) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse():
return $default(_that.recommended,_that.alternatives,_that.notes,_that.applicationMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VisaOption recommended,  List<VisaOption> alternatives,  List<String> notes,  ApplicationMetadata? applicationMetadata)?  $default,) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse() when $default != null:
return $default(_that.recommended,_that.alternatives,_that.notes,_that.applicationMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaRecommendationResponse implements VisaRecommendationResponse {
  const _VisaRecommendationResponse({required this.recommended, final  List<VisaOption> alternatives = const [], final  List<String> notes = const [], this.applicationMetadata}): _alternatives = alternatives,_notes = notes;
  factory _VisaRecommendationResponse.fromJson(Map<String, dynamic> json) => _$VisaRecommendationResponseFromJson(json);

@override final  VisaOption recommended;
 final  List<VisaOption> _alternatives;
@override@JsonKey() List<VisaOption> get alternatives {
  if (_alternatives is EqualUnmodifiableListView) return _alternatives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternatives);
}

 final  List<String> _notes;
@override@JsonKey() List<String> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

@override final  ApplicationMetadata? applicationMetadata;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaRecommendationResponse&&(identical(other.recommended, recommended) || other.recommended == recommended)&&const DeepCollectionEquality().equals(other._alternatives, _alternatives)&&const DeepCollectionEquality().equals(other._notes, _notes)&&(identical(other.applicationMetadata, applicationMetadata) || other.applicationMetadata == applicationMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recommended,const DeepCollectionEquality().hash(_alternatives),const DeepCollectionEquality().hash(_notes),applicationMetadata);

@override
String toString() {
  return 'VisaRecommendationResponse(recommended: $recommended, alternatives: $alternatives, notes: $notes, applicationMetadata: $applicationMetadata)';
}


}

/// @nodoc
abstract mixin class _$VisaRecommendationResponseCopyWith<$Res> implements $VisaRecommendationResponseCopyWith<$Res> {
  factory _$VisaRecommendationResponseCopyWith(_VisaRecommendationResponse value, $Res Function(_VisaRecommendationResponse) _then) = __$VisaRecommendationResponseCopyWithImpl;
@override @useResult
$Res call({
 VisaOption recommended, List<VisaOption> alternatives, List<String> notes, ApplicationMetadata? applicationMetadata
});


@override $VisaOptionCopyWith<$Res> get recommended;@override $ApplicationMetadataCopyWith<$Res>? get applicationMetadata;

}
/// @nodoc
class __$VisaRecommendationResponseCopyWithImpl<$Res>
    implements _$VisaRecommendationResponseCopyWith<$Res> {
  __$VisaRecommendationResponseCopyWithImpl(this._self, this._then);

  final _VisaRecommendationResponse _self;
  final $Res Function(_VisaRecommendationResponse) _then;

/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recommended = null,Object? alternatives = null,Object? notes = null,Object? applicationMetadata = freezed,}) {
  return _then(_VisaRecommendationResponse(
recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as VisaOption,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<VisaOption>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>,applicationMetadata: freezed == applicationMetadata ? _self.applicationMetadata : applicationMetadata // ignore: cast_nullable_to_non_nullable
as ApplicationMetadata?,
  ));
}

/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VisaOptionCopyWith<$Res> get recommended {
  
  return $VisaOptionCopyWith<$Res>(_self.recommended, (value) {
    return _then(_self.copyWith(recommended: value));
  });
}/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationMetadataCopyWith<$Res>? get applicationMetadata {
    if (_self.applicationMetadata == null) {
    return null;
  }

  return $ApplicationMetadataCopyWith<$Res>(_self.applicationMetadata!, (value) {
    return _then(_self.copyWith(applicationMetadata: value));
  });
}
}


/// @nodoc
mixin _$VisaOption {

 String get code; String get name; String get summary; List<String>? get requirements; List<String>? get notes;
/// Create a copy of VisaOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaOptionCopyWith<VisaOption> get copyWith => _$VisaOptionCopyWithImpl<VisaOption>(this as VisaOption, _$identity);

  /// Serializes this VisaOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaOption&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.requirements, requirements)&&const DeepCollectionEquality().equals(other.notes, notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,summary,const DeepCollectionEquality().hash(requirements),const DeepCollectionEquality().hash(notes));

@override
String toString() {
  return 'VisaOption(code: $code, name: $name, summary: $summary, requirements: $requirements, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $VisaOptionCopyWith<$Res>  {
  factory $VisaOptionCopyWith(VisaOption value, $Res Function(VisaOption) _then) = _$VisaOptionCopyWithImpl;
@useResult
$Res call({
 String code, String name, String summary, List<String>? requirements, List<String>? notes
});




}
/// @nodoc
class _$VisaOptionCopyWithImpl<$Res>
    implements $VisaOptionCopyWith<$Res> {
  _$VisaOptionCopyWithImpl(this._self, this._then);

  final VisaOption _self;
  final $Res Function(VisaOption) _then;

/// Create a copy of VisaOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? summary = null,Object? requirements = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,requirements: freezed == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisaOption].
extension VisaOptionPatterns on VisaOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisaOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisaOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisaOption value)  $default,){
final _that = this;
switch (_that) {
case _VisaOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisaOption value)?  $default,){
final _that = this;
switch (_that) {
case _VisaOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  String summary,  List<String>? requirements,  List<String>? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaOption() when $default != null:
return $default(_that.code,_that.name,_that.summary,_that.requirements,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  String summary,  List<String>? requirements,  List<String>? notes)  $default,) {final _that = this;
switch (_that) {
case _VisaOption():
return $default(_that.code,_that.name,_that.summary,_that.requirements,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  String summary,  List<String>? requirements,  List<String>? notes)?  $default,) {final _that = this;
switch (_that) {
case _VisaOption() when $default != null:
return $default(_that.code,_that.name,_that.summary,_that.requirements,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaOption implements VisaOption {
  const _VisaOption({required this.code, required this.name, required this.summary, final  List<String>? requirements, final  List<String>? notes}): _requirements = requirements,_notes = notes;
  factory _VisaOption.fromJson(Map<String, dynamic> json) => _$VisaOptionFromJson(json);

@override final  String code;
@override final  String name;
@override final  String summary;
 final  List<String>? _requirements;
@override List<String>? get requirements {
  final value = _requirements;
  if (value == null) return null;
  if (_requirements is EqualUnmodifiableListView) return _requirements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _notes;
@override List<String>? get notes {
  final value = _notes;
  if (value == null) return null;
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of VisaOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisaOptionCopyWith<_VisaOption> get copyWith => __$VisaOptionCopyWithImpl<_VisaOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisaOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaOption&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._requirements, _requirements)&&const DeepCollectionEquality().equals(other._notes, _notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,summary,const DeepCollectionEquality().hash(_requirements),const DeepCollectionEquality().hash(_notes));

@override
String toString() {
  return 'VisaOption(code: $code, name: $name, summary: $summary, requirements: $requirements, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$VisaOptionCopyWith<$Res> implements $VisaOptionCopyWith<$Res> {
  factory _$VisaOptionCopyWith(_VisaOption value, $Res Function(_VisaOption) _then) = __$VisaOptionCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, String summary, List<String>? requirements, List<String>? notes
});




}
/// @nodoc
class __$VisaOptionCopyWithImpl<$Res>
    implements _$VisaOptionCopyWith<$Res> {
  __$VisaOptionCopyWithImpl(this._self, this._then);

  final _VisaOption _self;
  final $Res Function(_VisaOption) _then;

/// Create a copy of VisaOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? summary = null,Object? requirements = freezed,Object? notes = freezed,}) {
  return _then(_VisaOption(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,requirements: freezed == requirements ? _self._requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>?,notes: freezed == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$ApplicationMetadata {

 List<CityPortal> get cityPortals; List<RequiredDocument> get requiredDocuments; List<ApplicationQuestion> get additionalQuestions; List<PreFilledField> get preFilledFields; String? get estimatedProcessingTime; String? get appointmentBookingUrl; List<String> get specialInstructions;
/// Create a copy of ApplicationMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationMetadataCopyWith<ApplicationMetadata> get copyWith => _$ApplicationMetadataCopyWithImpl<ApplicationMetadata>(this as ApplicationMetadata, _$identity);

  /// Serializes this ApplicationMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationMetadata&&const DeepCollectionEquality().equals(other.cityPortals, cityPortals)&&const DeepCollectionEquality().equals(other.requiredDocuments, requiredDocuments)&&const DeepCollectionEquality().equals(other.additionalQuestions, additionalQuestions)&&const DeepCollectionEquality().equals(other.preFilledFields, preFilledFields)&&(identical(other.estimatedProcessingTime, estimatedProcessingTime) || other.estimatedProcessingTime == estimatedProcessingTime)&&(identical(other.appointmentBookingUrl, appointmentBookingUrl) || other.appointmentBookingUrl == appointmentBookingUrl)&&const DeepCollectionEquality().equals(other.specialInstructions, specialInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cityPortals),const DeepCollectionEquality().hash(requiredDocuments),const DeepCollectionEquality().hash(additionalQuestions),const DeepCollectionEquality().hash(preFilledFields),estimatedProcessingTime,appointmentBookingUrl,const DeepCollectionEquality().hash(specialInstructions));

@override
String toString() {
  return 'ApplicationMetadata(cityPortals: $cityPortals, requiredDocuments: $requiredDocuments, additionalQuestions: $additionalQuestions, preFilledFields: $preFilledFields, estimatedProcessingTime: $estimatedProcessingTime, appointmentBookingUrl: $appointmentBookingUrl, specialInstructions: $specialInstructions)';
}


}

/// @nodoc
abstract mixin class $ApplicationMetadataCopyWith<$Res>  {
  factory $ApplicationMetadataCopyWith(ApplicationMetadata value, $Res Function(ApplicationMetadata) _then) = _$ApplicationMetadataCopyWithImpl;
@useResult
$Res call({
 List<CityPortal> cityPortals, List<RequiredDocument> requiredDocuments, List<ApplicationQuestion> additionalQuestions, List<PreFilledField> preFilledFields, String? estimatedProcessingTime, String? appointmentBookingUrl, List<String> specialInstructions
});




}
/// @nodoc
class _$ApplicationMetadataCopyWithImpl<$Res>
    implements $ApplicationMetadataCopyWith<$Res> {
  _$ApplicationMetadataCopyWithImpl(this._self, this._then);

  final ApplicationMetadata _self;
  final $Res Function(ApplicationMetadata) _then;

/// Create a copy of ApplicationMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cityPortals = null,Object? requiredDocuments = null,Object? additionalQuestions = null,Object? preFilledFields = null,Object? estimatedProcessingTime = freezed,Object? appointmentBookingUrl = freezed,Object? specialInstructions = null,}) {
  return _then(_self.copyWith(
cityPortals: null == cityPortals ? _self.cityPortals : cityPortals // ignore: cast_nullable_to_non_nullable
as List<CityPortal>,requiredDocuments: null == requiredDocuments ? _self.requiredDocuments : requiredDocuments // ignore: cast_nullable_to_non_nullable
as List<RequiredDocument>,additionalQuestions: null == additionalQuestions ? _self.additionalQuestions : additionalQuestions // ignore: cast_nullable_to_non_nullable
as List<ApplicationQuestion>,preFilledFields: null == preFilledFields ? _self.preFilledFields : preFilledFields // ignore: cast_nullable_to_non_nullable
as List<PreFilledField>,estimatedProcessingTime: freezed == estimatedProcessingTime ? _self.estimatedProcessingTime : estimatedProcessingTime // ignore: cast_nullable_to_non_nullable
as String?,appointmentBookingUrl: freezed == appointmentBookingUrl ? _self.appointmentBookingUrl : appointmentBookingUrl // ignore: cast_nullable_to_non_nullable
as String?,specialInstructions: null == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplicationMetadata].
extension ApplicationMetadataPatterns on ApplicationMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationMetadata value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CityPortal> cityPortals,  List<RequiredDocument> requiredDocuments,  List<ApplicationQuestion> additionalQuestions,  List<PreFilledField> preFilledFields,  String? estimatedProcessingTime,  String? appointmentBookingUrl,  List<String> specialInstructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationMetadata() when $default != null:
return $default(_that.cityPortals,_that.requiredDocuments,_that.additionalQuestions,_that.preFilledFields,_that.estimatedProcessingTime,_that.appointmentBookingUrl,_that.specialInstructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CityPortal> cityPortals,  List<RequiredDocument> requiredDocuments,  List<ApplicationQuestion> additionalQuestions,  List<PreFilledField> preFilledFields,  String? estimatedProcessingTime,  String? appointmentBookingUrl,  List<String> specialInstructions)  $default,) {final _that = this;
switch (_that) {
case _ApplicationMetadata():
return $default(_that.cityPortals,_that.requiredDocuments,_that.additionalQuestions,_that.preFilledFields,_that.estimatedProcessingTime,_that.appointmentBookingUrl,_that.specialInstructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CityPortal> cityPortals,  List<RequiredDocument> requiredDocuments,  List<ApplicationQuestion> additionalQuestions,  List<PreFilledField> preFilledFields,  String? estimatedProcessingTime,  String? appointmentBookingUrl,  List<String> specialInstructions)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationMetadata() when $default != null:
return $default(_that.cityPortals,_that.requiredDocuments,_that.additionalQuestions,_that.preFilledFields,_that.estimatedProcessingTime,_that.appointmentBookingUrl,_that.specialInstructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicationMetadata implements ApplicationMetadata {
  const _ApplicationMetadata({final  List<CityPortal> cityPortals = const [], final  List<RequiredDocument> requiredDocuments = const [], final  List<ApplicationQuestion> additionalQuestions = const [], final  List<PreFilledField> preFilledFields = const [], this.estimatedProcessingTime, this.appointmentBookingUrl, final  List<String> specialInstructions = const []}): _cityPortals = cityPortals,_requiredDocuments = requiredDocuments,_additionalQuestions = additionalQuestions,_preFilledFields = preFilledFields,_specialInstructions = specialInstructions;
  factory _ApplicationMetadata.fromJson(Map<String, dynamic> json) => _$ApplicationMetadataFromJson(json);

 final  List<CityPortal> _cityPortals;
@override@JsonKey() List<CityPortal> get cityPortals {
  if (_cityPortals is EqualUnmodifiableListView) return _cityPortals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cityPortals);
}

 final  List<RequiredDocument> _requiredDocuments;
@override@JsonKey() List<RequiredDocument> get requiredDocuments {
  if (_requiredDocuments is EqualUnmodifiableListView) return _requiredDocuments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiredDocuments);
}

 final  List<ApplicationQuestion> _additionalQuestions;
@override@JsonKey() List<ApplicationQuestion> get additionalQuestions {
  if (_additionalQuestions is EqualUnmodifiableListView) return _additionalQuestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_additionalQuestions);
}

 final  List<PreFilledField> _preFilledFields;
@override@JsonKey() List<PreFilledField> get preFilledFields {
  if (_preFilledFields is EqualUnmodifiableListView) return _preFilledFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preFilledFields);
}

@override final  String? estimatedProcessingTime;
@override final  String? appointmentBookingUrl;
 final  List<String> _specialInstructions;
@override@JsonKey() List<String> get specialInstructions {
  if (_specialInstructions is EqualUnmodifiableListView) return _specialInstructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialInstructions);
}


/// Create a copy of ApplicationMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationMetadataCopyWith<_ApplicationMetadata> get copyWith => __$ApplicationMetadataCopyWithImpl<_ApplicationMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationMetadata&&const DeepCollectionEquality().equals(other._cityPortals, _cityPortals)&&const DeepCollectionEquality().equals(other._requiredDocuments, _requiredDocuments)&&const DeepCollectionEquality().equals(other._additionalQuestions, _additionalQuestions)&&const DeepCollectionEquality().equals(other._preFilledFields, _preFilledFields)&&(identical(other.estimatedProcessingTime, estimatedProcessingTime) || other.estimatedProcessingTime == estimatedProcessingTime)&&(identical(other.appointmentBookingUrl, appointmentBookingUrl) || other.appointmentBookingUrl == appointmentBookingUrl)&&const DeepCollectionEquality().equals(other._specialInstructions, _specialInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cityPortals),const DeepCollectionEquality().hash(_requiredDocuments),const DeepCollectionEquality().hash(_additionalQuestions),const DeepCollectionEquality().hash(_preFilledFields),estimatedProcessingTime,appointmentBookingUrl,const DeepCollectionEquality().hash(_specialInstructions));

@override
String toString() {
  return 'ApplicationMetadata(cityPortals: $cityPortals, requiredDocuments: $requiredDocuments, additionalQuestions: $additionalQuestions, preFilledFields: $preFilledFields, estimatedProcessingTime: $estimatedProcessingTime, appointmentBookingUrl: $appointmentBookingUrl, specialInstructions: $specialInstructions)';
}


}

/// @nodoc
abstract mixin class _$ApplicationMetadataCopyWith<$Res> implements $ApplicationMetadataCopyWith<$Res> {
  factory _$ApplicationMetadataCopyWith(_ApplicationMetadata value, $Res Function(_ApplicationMetadata) _then) = __$ApplicationMetadataCopyWithImpl;
@override @useResult
$Res call({
 List<CityPortal> cityPortals, List<RequiredDocument> requiredDocuments, List<ApplicationQuestion> additionalQuestions, List<PreFilledField> preFilledFields, String? estimatedProcessingTime, String? appointmentBookingUrl, List<String> specialInstructions
});




}
/// @nodoc
class __$ApplicationMetadataCopyWithImpl<$Res>
    implements _$ApplicationMetadataCopyWith<$Res> {
  __$ApplicationMetadataCopyWithImpl(this._self, this._then);

  final _ApplicationMetadata _self;
  final $Res Function(_ApplicationMetadata) _then;

/// Create a copy of ApplicationMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cityPortals = null,Object? requiredDocuments = null,Object? additionalQuestions = null,Object? preFilledFields = null,Object? estimatedProcessingTime = freezed,Object? appointmentBookingUrl = freezed,Object? specialInstructions = null,}) {
  return _then(_ApplicationMetadata(
cityPortals: null == cityPortals ? _self._cityPortals : cityPortals // ignore: cast_nullable_to_non_nullable
as List<CityPortal>,requiredDocuments: null == requiredDocuments ? _self._requiredDocuments : requiredDocuments // ignore: cast_nullable_to_non_nullable
as List<RequiredDocument>,additionalQuestions: null == additionalQuestions ? _self._additionalQuestions : additionalQuestions // ignore: cast_nullable_to_non_nullable
as List<ApplicationQuestion>,preFilledFields: null == preFilledFields ? _self._preFilledFields : preFilledFields // ignore: cast_nullable_to_non_nullable
as List<PreFilledField>,estimatedProcessingTime: freezed == estimatedProcessingTime ? _self.estimatedProcessingTime : estimatedProcessingTime // ignore: cast_nullable_to_non_nullable
as String?,appointmentBookingUrl: freezed == appointmentBookingUrl ? _self.appointmentBookingUrl : appointmentBookingUrl // ignore: cast_nullable_to_non_nullable
as String?,specialInstructions: null == specialInstructions ? _self._specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$CityPortal {

 String get id; String get city; String? get state; String get portalUrl; bool get appointmentRequired; String? get appointmentBookingUrl; String? get contactEmail; String? get contactPhone; String? get address; String? get operatingHours; String? get specialInstructions; int? get averageWaitTimeDays;
/// Create a copy of CityPortal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityPortalCopyWith<CityPortal> get copyWith => _$CityPortalCopyWithImpl<CityPortal>(this as CityPortal, _$identity);

  /// Serializes this CityPortal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CityPortal&&(identical(other.id, id) || other.id == id)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.portalUrl, portalUrl) || other.portalUrl == portalUrl)&&(identical(other.appointmentRequired, appointmentRequired) || other.appointmentRequired == appointmentRequired)&&(identical(other.appointmentBookingUrl, appointmentBookingUrl) || other.appointmentBookingUrl == appointmentBookingUrl)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.address, address) || other.address == address)&&(identical(other.operatingHours, operatingHours) || other.operatingHours == operatingHours)&&(identical(other.specialInstructions, specialInstructions) || other.specialInstructions == specialInstructions)&&(identical(other.averageWaitTimeDays, averageWaitTimeDays) || other.averageWaitTimeDays == averageWaitTimeDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,city,state,portalUrl,appointmentRequired,appointmentBookingUrl,contactEmail,contactPhone,address,operatingHours,specialInstructions,averageWaitTimeDays);

@override
String toString() {
  return 'CityPortal(id: $id, city: $city, state: $state, portalUrl: $portalUrl, appointmentRequired: $appointmentRequired, appointmentBookingUrl: $appointmentBookingUrl, contactEmail: $contactEmail, contactPhone: $contactPhone, address: $address, operatingHours: $operatingHours, specialInstructions: $specialInstructions, averageWaitTimeDays: $averageWaitTimeDays)';
}


}

/// @nodoc
abstract mixin class $CityPortalCopyWith<$Res>  {
  factory $CityPortalCopyWith(CityPortal value, $Res Function(CityPortal) _then) = _$CityPortalCopyWithImpl;
@useResult
$Res call({
 String id, String city, String? state, String portalUrl, bool appointmentRequired, String? appointmentBookingUrl, String? contactEmail, String? contactPhone, String? address, String? operatingHours, String? specialInstructions, int? averageWaitTimeDays
});




}
/// @nodoc
class _$CityPortalCopyWithImpl<$Res>
    implements $CityPortalCopyWith<$Res> {
  _$CityPortalCopyWithImpl(this._self, this._then);

  final CityPortal _self;
  final $Res Function(CityPortal) _then;

/// Create a copy of CityPortal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? city = null,Object? state = freezed,Object? portalUrl = null,Object? appointmentRequired = null,Object? appointmentBookingUrl = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? address = freezed,Object? operatingHours = freezed,Object? specialInstructions = freezed,Object? averageWaitTimeDays = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,portalUrl: null == portalUrl ? _self.portalUrl : portalUrl // ignore: cast_nullable_to_non_nullable
as String,appointmentRequired: null == appointmentRequired ? _self.appointmentRequired : appointmentRequired // ignore: cast_nullable_to_non_nullable
as bool,appointmentBookingUrl: freezed == appointmentBookingUrl ? _self.appointmentBookingUrl : appointmentBookingUrl // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,operatingHours: freezed == operatingHours ? _self.operatingHours : operatingHours // ignore: cast_nullable_to_non_nullable
as String?,specialInstructions: freezed == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as String?,averageWaitTimeDays: freezed == averageWaitTimeDays ? _self.averageWaitTimeDays : averageWaitTimeDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CityPortal].
extension CityPortalPatterns on CityPortal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CityPortal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CityPortal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CityPortal value)  $default,){
final _that = this;
switch (_that) {
case _CityPortal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CityPortal value)?  $default,){
final _that = this;
switch (_that) {
case _CityPortal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String city,  String? state,  String portalUrl,  bool appointmentRequired,  String? appointmentBookingUrl,  String? contactEmail,  String? contactPhone,  String? address,  String? operatingHours,  String? specialInstructions,  int? averageWaitTimeDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CityPortal() when $default != null:
return $default(_that.id,_that.city,_that.state,_that.portalUrl,_that.appointmentRequired,_that.appointmentBookingUrl,_that.contactEmail,_that.contactPhone,_that.address,_that.operatingHours,_that.specialInstructions,_that.averageWaitTimeDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String city,  String? state,  String portalUrl,  bool appointmentRequired,  String? appointmentBookingUrl,  String? contactEmail,  String? contactPhone,  String? address,  String? operatingHours,  String? specialInstructions,  int? averageWaitTimeDays)  $default,) {final _that = this;
switch (_that) {
case _CityPortal():
return $default(_that.id,_that.city,_that.state,_that.portalUrl,_that.appointmentRequired,_that.appointmentBookingUrl,_that.contactEmail,_that.contactPhone,_that.address,_that.operatingHours,_that.specialInstructions,_that.averageWaitTimeDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String city,  String? state,  String portalUrl,  bool appointmentRequired,  String? appointmentBookingUrl,  String? contactEmail,  String? contactPhone,  String? address,  String? operatingHours,  String? specialInstructions,  int? averageWaitTimeDays)?  $default,) {final _that = this;
switch (_that) {
case _CityPortal() when $default != null:
return $default(_that.id,_that.city,_that.state,_that.portalUrl,_that.appointmentRequired,_that.appointmentBookingUrl,_that.contactEmail,_that.contactPhone,_that.address,_that.operatingHours,_that.specialInstructions,_that.averageWaitTimeDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CityPortal implements CityPortal {
  const _CityPortal({required this.id, required this.city, this.state, required this.portalUrl, required this.appointmentRequired, this.appointmentBookingUrl, this.contactEmail, this.contactPhone, this.address, this.operatingHours, this.specialInstructions, this.averageWaitTimeDays});
  factory _CityPortal.fromJson(Map<String, dynamic> json) => _$CityPortalFromJson(json);

@override final  String id;
@override final  String city;
@override final  String? state;
@override final  String portalUrl;
@override final  bool appointmentRequired;
@override final  String? appointmentBookingUrl;
@override final  String? contactEmail;
@override final  String? contactPhone;
@override final  String? address;
@override final  String? operatingHours;
@override final  String? specialInstructions;
@override final  int? averageWaitTimeDays;

/// Create a copy of CityPortal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityPortalCopyWith<_CityPortal> get copyWith => __$CityPortalCopyWithImpl<_CityPortal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityPortalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CityPortal&&(identical(other.id, id) || other.id == id)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.portalUrl, portalUrl) || other.portalUrl == portalUrl)&&(identical(other.appointmentRequired, appointmentRequired) || other.appointmentRequired == appointmentRequired)&&(identical(other.appointmentBookingUrl, appointmentBookingUrl) || other.appointmentBookingUrl == appointmentBookingUrl)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.address, address) || other.address == address)&&(identical(other.operatingHours, operatingHours) || other.operatingHours == operatingHours)&&(identical(other.specialInstructions, specialInstructions) || other.specialInstructions == specialInstructions)&&(identical(other.averageWaitTimeDays, averageWaitTimeDays) || other.averageWaitTimeDays == averageWaitTimeDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,city,state,portalUrl,appointmentRequired,appointmentBookingUrl,contactEmail,contactPhone,address,operatingHours,specialInstructions,averageWaitTimeDays);

@override
String toString() {
  return 'CityPortal(id: $id, city: $city, state: $state, portalUrl: $portalUrl, appointmentRequired: $appointmentRequired, appointmentBookingUrl: $appointmentBookingUrl, contactEmail: $contactEmail, contactPhone: $contactPhone, address: $address, operatingHours: $operatingHours, specialInstructions: $specialInstructions, averageWaitTimeDays: $averageWaitTimeDays)';
}


}

/// @nodoc
abstract mixin class _$CityPortalCopyWith<$Res> implements $CityPortalCopyWith<$Res> {
  factory _$CityPortalCopyWith(_CityPortal value, $Res Function(_CityPortal) _then) = __$CityPortalCopyWithImpl;
@override @useResult
$Res call({
 String id, String city, String? state, String portalUrl, bool appointmentRequired, String? appointmentBookingUrl, String? contactEmail, String? contactPhone, String? address, String? operatingHours, String? specialInstructions, int? averageWaitTimeDays
});




}
/// @nodoc
class __$CityPortalCopyWithImpl<$Res>
    implements _$CityPortalCopyWith<$Res> {
  __$CityPortalCopyWithImpl(this._self, this._then);

  final _CityPortal _self;
  final $Res Function(_CityPortal) _then;

/// Create a copy of CityPortal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? city = null,Object? state = freezed,Object? portalUrl = null,Object? appointmentRequired = null,Object? appointmentBookingUrl = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? address = freezed,Object? operatingHours = freezed,Object? specialInstructions = freezed,Object? averageWaitTimeDays = freezed,}) {
  return _then(_CityPortal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,portalUrl: null == portalUrl ? _self.portalUrl : portalUrl // ignore: cast_nullable_to_non_nullable
as String,appointmentRequired: null == appointmentRequired ? _self.appointmentRequired : appointmentRequired // ignore: cast_nullable_to_non_nullable
as bool,appointmentBookingUrl: freezed == appointmentBookingUrl ? _self.appointmentBookingUrl : appointmentBookingUrl // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,operatingHours: freezed == operatingHours ? _self.operatingHours : operatingHours // ignore: cast_nullable_to_non_nullable
as String?,specialInstructions: freezed == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as String?,averageWaitTimeDays: freezed == averageWaitTimeDays ? _self.averageWaitTimeDays : averageWaitTimeDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RequiredDocument {

 String get id; String get documentType; String get documentName; String? get description; bool get required; bool get canGenerate; String? get instructions; int get orderIndex; bool get uploaded;
/// Create a copy of RequiredDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequiredDocumentCopyWith<RequiredDocument> get copyWith => _$RequiredDocumentCopyWithImpl<RequiredDocument>(this as RequiredDocument, _$identity);

  /// Serializes this RequiredDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequiredDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.documentName, documentName) || other.documentName == documentName)&&(identical(other.description, description) || other.description == description)&&(identical(other.required, required) || other.required == required)&&(identical(other.canGenerate, canGenerate) || other.canGenerate == canGenerate)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.uploaded, uploaded) || other.uploaded == uploaded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,documentType,documentName,description,required,canGenerate,instructions,orderIndex,uploaded);

@override
String toString() {
  return 'RequiredDocument(id: $id, documentType: $documentType, documentName: $documentName, description: $description, required: $required, canGenerate: $canGenerate, instructions: $instructions, orderIndex: $orderIndex, uploaded: $uploaded)';
}


}

/// @nodoc
abstract mixin class $RequiredDocumentCopyWith<$Res>  {
  factory $RequiredDocumentCopyWith(RequiredDocument value, $Res Function(RequiredDocument) _then) = _$RequiredDocumentCopyWithImpl;
@useResult
$Res call({
 String id, String documentType, String documentName, String? description, bool required, bool canGenerate, String? instructions, int orderIndex, bool uploaded
});




}
/// @nodoc
class _$RequiredDocumentCopyWithImpl<$Res>
    implements $RequiredDocumentCopyWith<$Res> {
  _$RequiredDocumentCopyWithImpl(this._self, this._then);

  final RequiredDocument _self;
  final $Res Function(RequiredDocument) _then;

/// Create a copy of RequiredDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? documentType = null,Object? documentName = null,Object? description = freezed,Object? required = null,Object? canGenerate = null,Object? instructions = freezed,Object? orderIndex = null,Object? uploaded = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,documentName: null == documentName ? _self.documentName : documentName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,canGenerate: null == canGenerate ? _self.canGenerate : canGenerate // ignore: cast_nullable_to_non_nullable
as bool,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,uploaded: null == uploaded ? _self.uploaded : uploaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RequiredDocument].
extension RequiredDocumentPatterns on RequiredDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequiredDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequiredDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequiredDocument value)  $default,){
final _that = this;
switch (_that) {
case _RequiredDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequiredDocument value)?  $default,){
final _that = this;
switch (_that) {
case _RequiredDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String documentType,  String documentName,  String? description,  bool required,  bool canGenerate,  String? instructions,  int orderIndex,  bool uploaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequiredDocument() when $default != null:
return $default(_that.id,_that.documentType,_that.documentName,_that.description,_that.required,_that.canGenerate,_that.instructions,_that.orderIndex,_that.uploaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String documentType,  String documentName,  String? description,  bool required,  bool canGenerate,  String? instructions,  int orderIndex,  bool uploaded)  $default,) {final _that = this;
switch (_that) {
case _RequiredDocument():
return $default(_that.id,_that.documentType,_that.documentName,_that.description,_that.required,_that.canGenerate,_that.instructions,_that.orderIndex,_that.uploaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String documentType,  String documentName,  String? description,  bool required,  bool canGenerate,  String? instructions,  int orderIndex,  bool uploaded)?  $default,) {final _that = this;
switch (_that) {
case _RequiredDocument() when $default != null:
return $default(_that.id,_that.documentType,_that.documentName,_that.description,_that.required,_that.canGenerate,_that.instructions,_that.orderIndex,_that.uploaded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequiredDocument implements RequiredDocument {
  const _RequiredDocument({required this.id, required this.documentType, required this.documentName, this.description, required this.required, required this.canGenerate, this.instructions, required this.orderIndex, this.uploaded = false});
  factory _RequiredDocument.fromJson(Map<String, dynamic> json) => _$RequiredDocumentFromJson(json);

@override final  String id;
@override final  String documentType;
@override final  String documentName;
@override final  String? description;
@override final  bool required;
@override final  bool canGenerate;
@override final  String? instructions;
@override final  int orderIndex;
@override@JsonKey() final  bool uploaded;

/// Create a copy of RequiredDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequiredDocumentCopyWith<_RequiredDocument> get copyWith => __$RequiredDocumentCopyWithImpl<_RequiredDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequiredDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequiredDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.documentName, documentName) || other.documentName == documentName)&&(identical(other.description, description) || other.description == description)&&(identical(other.required, required) || other.required == required)&&(identical(other.canGenerate, canGenerate) || other.canGenerate == canGenerate)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.uploaded, uploaded) || other.uploaded == uploaded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,documentType,documentName,description,required,canGenerate,instructions,orderIndex,uploaded);

@override
String toString() {
  return 'RequiredDocument(id: $id, documentType: $documentType, documentName: $documentName, description: $description, required: $required, canGenerate: $canGenerate, instructions: $instructions, orderIndex: $orderIndex, uploaded: $uploaded)';
}


}

/// @nodoc
abstract mixin class _$RequiredDocumentCopyWith<$Res> implements $RequiredDocumentCopyWith<$Res> {
  factory _$RequiredDocumentCopyWith(_RequiredDocument value, $Res Function(_RequiredDocument) _then) = __$RequiredDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String documentType, String documentName, String? description, bool required, bool canGenerate, String? instructions, int orderIndex, bool uploaded
});




}
/// @nodoc
class __$RequiredDocumentCopyWithImpl<$Res>
    implements _$RequiredDocumentCopyWith<$Res> {
  __$RequiredDocumentCopyWithImpl(this._self, this._then);

  final _RequiredDocument _self;
  final $Res Function(_RequiredDocument) _then;

/// Create a copy of RequiredDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? documentType = null,Object? documentName = null,Object? description = freezed,Object? required = null,Object? canGenerate = null,Object? instructions = freezed,Object? orderIndex = null,Object? uploaded = null,}) {
  return _then(_RequiredDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,documentName: null == documentName ? _self.documentName : documentName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,canGenerate: null == canGenerate ? _self.canGenerate : canGenerate // ignore: cast_nullable_to_non_nullable
as bool,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,uploaded: null == uploaded ? _self.uploaded : uploaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ApplicationQuestion {

 String get id; String get fieldKey; String get question; String get questionType; bool get required; List<String>? get options; Map<String, dynamic>? get validationRules; String? get helpText; String? get placeholder; String get section; int get orderIndex;
/// Create a copy of ApplicationQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationQuestionCopyWith<ApplicationQuestion> get copyWith => _$ApplicationQuestionCopyWithImpl<ApplicationQuestion>(this as ApplicationQuestion, _$identity);

  /// Serializes this ApplicationQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.fieldKey, fieldKey) || other.fieldKey == fieldKey)&&(identical(other.question, question) || other.question == question)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.validationRules, validationRules)&&(identical(other.helpText, helpText) || other.helpText == helpText)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.section, section) || other.section == section)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fieldKey,question,questionType,required,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(validationRules),helpText,placeholder,section,orderIndex);

@override
String toString() {
  return 'ApplicationQuestion(id: $id, fieldKey: $fieldKey, question: $question, questionType: $questionType, required: $required, options: $options, validationRules: $validationRules, helpText: $helpText, placeholder: $placeholder, section: $section, orderIndex: $orderIndex)';
}


}

/// @nodoc
abstract mixin class $ApplicationQuestionCopyWith<$Res>  {
  factory $ApplicationQuestionCopyWith(ApplicationQuestion value, $Res Function(ApplicationQuestion) _then) = _$ApplicationQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String fieldKey, String question, String questionType, bool required, List<String>? options, Map<String, dynamic>? validationRules, String? helpText, String? placeholder, String section, int orderIndex
});




}
/// @nodoc
class _$ApplicationQuestionCopyWithImpl<$Res>
    implements $ApplicationQuestionCopyWith<$Res> {
  _$ApplicationQuestionCopyWithImpl(this._self, this._then);

  final ApplicationQuestion _self;
  final $Res Function(ApplicationQuestion) _then;

/// Create a copy of ApplicationQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fieldKey = null,Object? question = null,Object? questionType = null,Object? required = null,Object? options = freezed,Object? validationRules = freezed,Object? helpText = freezed,Object? placeholder = freezed,Object? section = null,Object? orderIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fieldKey: null == fieldKey ? _self.fieldKey : fieldKey // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,questionType: null == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,validationRules: freezed == validationRules ? _self.validationRules : validationRules // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,helpText: freezed == helpText ? _self.helpText : helpText // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplicationQuestion].
extension ApplicationQuestionPatterns on ApplicationQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationQuestion value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fieldKey,  String question,  String questionType,  bool required,  List<String>? options,  Map<String, dynamic>? validationRules,  String? helpText,  String? placeholder,  String section,  int orderIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationQuestion() when $default != null:
return $default(_that.id,_that.fieldKey,_that.question,_that.questionType,_that.required,_that.options,_that.validationRules,_that.helpText,_that.placeholder,_that.section,_that.orderIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fieldKey,  String question,  String questionType,  bool required,  List<String>? options,  Map<String, dynamic>? validationRules,  String? helpText,  String? placeholder,  String section,  int orderIndex)  $default,) {final _that = this;
switch (_that) {
case _ApplicationQuestion():
return $default(_that.id,_that.fieldKey,_that.question,_that.questionType,_that.required,_that.options,_that.validationRules,_that.helpText,_that.placeholder,_that.section,_that.orderIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fieldKey,  String question,  String questionType,  bool required,  List<String>? options,  Map<String, dynamic>? validationRules,  String? helpText,  String? placeholder,  String section,  int orderIndex)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationQuestion() when $default != null:
return $default(_that.id,_that.fieldKey,_that.question,_that.questionType,_that.required,_that.options,_that.validationRules,_that.helpText,_that.placeholder,_that.section,_that.orderIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicationQuestion implements ApplicationQuestion {
  const _ApplicationQuestion({required this.id, required this.fieldKey, required this.question, required this.questionType, required this.required, final  List<String>? options, final  Map<String, dynamic>? validationRules, this.helpText, this.placeholder, required this.section, required this.orderIndex}): _options = options,_validationRules = validationRules;
  factory _ApplicationQuestion.fromJson(Map<String, dynamic> json) => _$ApplicationQuestionFromJson(json);

@override final  String id;
@override final  String fieldKey;
@override final  String question;
@override final  String questionType;
@override final  bool required;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _validationRules;
@override Map<String, dynamic>? get validationRules {
  final value = _validationRules;
  if (value == null) return null;
  if (_validationRules is EqualUnmodifiableMapView) return _validationRules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? helpText;
@override final  String? placeholder;
@override final  String section;
@override final  int orderIndex;

/// Create a copy of ApplicationQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationQuestionCopyWith<_ApplicationQuestion> get copyWith => __$ApplicationQuestionCopyWithImpl<_ApplicationQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.fieldKey, fieldKey) || other.fieldKey == fieldKey)&&(identical(other.question, question) || other.question == question)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._validationRules, _validationRules)&&(identical(other.helpText, helpText) || other.helpText == helpText)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.section, section) || other.section == section)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fieldKey,question,questionType,required,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_validationRules),helpText,placeholder,section,orderIndex);

@override
String toString() {
  return 'ApplicationQuestion(id: $id, fieldKey: $fieldKey, question: $question, questionType: $questionType, required: $required, options: $options, validationRules: $validationRules, helpText: $helpText, placeholder: $placeholder, section: $section, orderIndex: $orderIndex)';
}


}

/// @nodoc
abstract mixin class _$ApplicationQuestionCopyWith<$Res> implements $ApplicationQuestionCopyWith<$Res> {
  factory _$ApplicationQuestionCopyWith(_ApplicationQuestion value, $Res Function(_ApplicationQuestion) _then) = __$ApplicationQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String fieldKey, String question, String questionType, bool required, List<String>? options, Map<String, dynamic>? validationRules, String? helpText, String? placeholder, String section, int orderIndex
});




}
/// @nodoc
class __$ApplicationQuestionCopyWithImpl<$Res>
    implements _$ApplicationQuestionCopyWith<$Res> {
  __$ApplicationQuestionCopyWithImpl(this._self, this._then);

  final _ApplicationQuestion _self;
  final $Res Function(_ApplicationQuestion) _then;

/// Create a copy of ApplicationQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fieldKey = null,Object? question = null,Object? questionType = null,Object? required = null,Object? options = freezed,Object? validationRules = freezed,Object? helpText = freezed,Object? placeholder = freezed,Object? section = null,Object? orderIndex = null,}) {
  return _then(_ApplicationQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fieldKey: null == fieldKey ? _self.fieldKey : fieldKey // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,questionType: null == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,validationRules: freezed == validationRules ? _self._validationRules : validationRules // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,helpText: freezed == helpText ? _self.helpText : helpText // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PreFilledField {

 String get formFieldKey; String get formFieldLabel; String? get formSection; String get sourceFieldKey; dynamic get value; String get confidence; bool get requiresVerification;
/// Create a copy of PreFilledField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreFilledFieldCopyWith<PreFilledField> get copyWith => _$PreFilledFieldCopyWithImpl<PreFilledField>(this as PreFilledField, _$identity);

  /// Serializes this PreFilledField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreFilledField&&(identical(other.formFieldKey, formFieldKey) || other.formFieldKey == formFieldKey)&&(identical(other.formFieldLabel, formFieldLabel) || other.formFieldLabel == formFieldLabel)&&(identical(other.formSection, formSection) || other.formSection == formSection)&&(identical(other.sourceFieldKey, sourceFieldKey) || other.sourceFieldKey == sourceFieldKey)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.requiresVerification, requiresVerification) || other.requiresVerification == requiresVerification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formFieldKey,formFieldLabel,formSection,sourceFieldKey,const DeepCollectionEquality().hash(value),confidence,requiresVerification);

@override
String toString() {
  return 'PreFilledField(formFieldKey: $formFieldKey, formFieldLabel: $formFieldLabel, formSection: $formSection, sourceFieldKey: $sourceFieldKey, value: $value, confidence: $confidence, requiresVerification: $requiresVerification)';
}


}

/// @nodoc
abstract mixin class $PreFilledFieldCopyWith<$Res>  {
  factory $PreFilledFieldCopyWith(PreFilledField value, $Res Function(PreFilledField) _then) = _$PreFilledFieldCopyWithImpl;
@useResult
$Res call({
 String formFieldKey, String formFieldLabel, String? formSection, String sourceFieldKey, dynamic value, String confidence, bool requiresVerification
});




}
/// @nodoc
class _$PreFilledFieldCopyWithImpl<$Res>
    implements $PreFilledFieldCopyWith<$Res> {
  _$PreFilledFieldCopyWithImpl(this._self, this._then);

  final PreFilledField _self;
  final $Res Function(PreFilledField) _then;

/// Create a copy of PreFilledField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formFieldKey = null,Object? formFieldLabel = null,Object? formSection = freezed,Object? sourceFieldKey = null,Object? value = freezed,Object? confidence = null,Object? requiresVerification = null,}) {
  return _then(_self.copyWith(
formFieldKey: null == formFieldKey ? _self.formFieldKey : formFieldKey // ignore: cast_nullable_to_non_nullable
as String,formFieldLabel: null == formFieldLabel ? _self.formFieldLabel : formFieldLabel // ignore: cast_nullable_to_non_nullable
as String,formSection: freezed == formSection ? _self.formSection : formSection // ignore: cast_nullable_to_non_nullable
as String?,sourceFieldKey: null == sourceFieldKey ? _self.sourceFieldKey : sourceFieldKey // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,requiresVerification: null == requiresVerification ? _self.requiresVerification : requiresVerification // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PreFilledField].
extension PreFilledFieldPatterns on PreFilledField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreFilledField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreFilledField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreFilledField value)  $default,){
final _that = this;
switch (_that) {
case _PreFilledField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreFilledField value)?  $default,){
final _that = this;
switch (_that) {
case _PreFilledField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formFieldKey,  String formFieldLabel,  String? formSection,  String sourceFieldKey,  dynamic value,  String confidence,  bool requiresVerification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreFilledField() when $default != null:
return $default(_that.formFieldKey,_that.formFieldLabel,_that.formSection,_that.sourceFieldKey,_that.value,_that.confidence,_that.requiresVerification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formFieldKey,  String formFieldLabel,  String? formSection,  String sourceFieldKey,  dynamic value,  String confidence,  bool requiresVerification)  $default,) {final _that = this;
switch (_that) {
case _PreFilledField():
return $default(_that.formFieldKey,_that.formFieldLabel,_that.formSection,_that.sourceFieldKey,_that.value,_that.confidence,_that.requiresVerification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formFieldKey,  String formFieldLabel,  String? formSection,  String sourceFieldKey,  dynamic value,  String confidence,  bool requiresVerification)?  $default,) {final _that = this;
switch (_that) {
case _PreFilledField() when $default != null:
return $default(_that.formFieldKey,_that.formFieldLabel,_that.formSection,_that.sourceFieldKey,_that.value,_that.confidence,_that.requiresVerification);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreFilledField implements PreFilledField {
  const _PreFilledField({required this.formFieldKey, required this.formFieldLabel, this.formSection, required this.sourceFieldKey, required this.value, required this.confidence, required this.requiresVerification});
  factory _PreFilledField.fromJson(Map<String, dynamic> json) => _$PreFilledFieldFromJson(json);

@override final  String formFieldKey;
@override final  String formFieldLabel;
@override final  String? formSection;
@override final  String sourceFieldKey;
@override final  dynamic value;
@override final  String confidence;
@override final  bool requiresVerification;

/// Create a copy of PreFilledField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreFilledFieldCopyWith<_PreFilledField> get copyWith => __$PreFilledFieldCopyWithImpl<_PreFilledField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreFilledFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreFilledField&&(identical(other.formFieldKey, formFieldKey) || other.formFieldKey == formFieldKey)&&(identical(other.formFieldLabel, formFieldLabel) || other.formFieldLabel == formFieldLabel)&&(identical(other.formSection, formSection) || other.formSection == formSection)&&(identical(other.sourceFieldKey, sourceFieldKey) || other.sourceFieldKey == sourceFieldKey)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.requiresVerification, requiresVerification) || other.requiresVerification == requiresVerification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formFieldKey,formFieldLabel,formSection,sourceFieldKey,const DeepCollectionEquality().hash(value),confidence,requiresVerification);

@override
String toString() {
  return 'PreFilledField(formFieldKey: $formFieldKey, formFieldLabel: $formFieldLabel, formSection: $formSection, sourceFieldKey: $sourceFieldKey, value: $value, confidence: $confidence, requiresVerification: $requiresVerification)';
}


}

/// @nodoc
abstract mixin class _$PreFilledFieldCopyWith<$Res> implements $PreFilledFieldCopyWith<$Res> {
  factory _$PreFilledFieldCopyWith(_PreFilledField value, $Res Function(_PreFilledField) _then) = __$PreFilledFieldCopyWithImpl;
@override @useResult
$Res call({
 String formFieldKey, String formFieldLabel, String? formSection, String sourceFieldKey, dynamic value, String confidence, bool requiresVerification
});




}
/// @nodoc
class __$PreFilledFieldCopyWithImpl<$Res>
    implements _$PreFilledFieldCopyWith<$Res> {
  __$PreFilledFieldCopyWithImpl(this._self, this._then);

  final _PreFilledField _self;
  final $Res Function(_PreFilledField) _then;

/// Create a copy of PreFilledField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formFieldKey = null,Object? formFieldLabel = null,Object? formSection = freezed,Object? sourceFieldKey = null,Object? value = freezed,Object? confidence = null,Object? requiresVerification = null,}) {
  return _then(_PreFilledField(
formFieldKey: null == formFieldKey ? _self.formFieldKey : formFieldKey // ignore: cast_nullable_to_non_nullable
as String,formFieldLabel: null == formFieldLabel ? _self.formFieldLabel : formFieldLabel // ignore: cast_nullable_to_non_nullable
as String,formSection: freezed == formSection ? _self.formSection : formSection // ignore: cast_nullable_to_non_nullable
as String?,sourceFieldKey: null == sourceFieldKey ? _self.sourceFieldKey : sourceFieldKey // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,requiresVerification: null == requiresVerification ? _self.requiresVerification : requiresVerification // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
