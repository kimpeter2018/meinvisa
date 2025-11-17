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

 VisaOption get recommended; List<VisaOption> get alternatives; List<String> get notes;
/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaRecommendationResponseCopyWith<VisaRecommendationResponse> get copyWith => _$VisaRecommendationResponseCopyWithImpl<VisaRecommendationResponse>(this as VisaRecommendationResponse, _$identity);

  /// Serializes this VisaRecommendationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaRecommendationResponse&&(identical(other.recommended, recommended) || other.recommended == recommended)&&const DeepCollectionEquality().equals(other.alternatives, alternatives)&&const DeepCollectionEquality().equals(other.notes, notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recommended,const DeepCollectionEquality().hash(alternatives),const DeepCollectionEquality().hash(notes));

@override
String toString() {
  return 'VisaRecommendationResponse(recommended: $recommended, alternatives: $alternatives, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $VisaRecommendationResponseCopyWith<$Res>  {
  factory $VisaRecommendationResponseCopyWith(VisaRecommendationResponse value, $Res Function(VisaRecommendationResponse) _then) = _$VisaRecommendationResponseCopyWithImpl;
@useResult
$Res call({
 VisaOption recommended, List<VisaOption> alternatives, List<String> notes
});


$VisaOptionCopyWith<$Res> get recommended;

}
/// @nodoc
class _$VisaRecommendationResponseCopyWithImpl<$Res>
    implements $VisaRecommendationResponseCopyWith<$Res> {
  _$VisaRecommendationResponseCopyWithImpl(this._self, this._then);

  final VisaRecommendationResponse _self;
  final $Res Function(VisaRecommendationResponse) _then;

/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recommended = null,Object? alternatives = null,Object? notes = null,}) {
  return _then(_self.copyWith(
recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as VisaOption,alternatives: null == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<VisaOption>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VisaOption recommended,  List<VisaOption> alternatives,  List<String> notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse() when $default != null:
return $default(_that.recommended,_that.alternatives,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VisaOption recommended,  List<VisaOption> alternatives,  List<String> notes)  $default,) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse():
return $default(_that.recommended,_that.alternatives,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VisaOption recommended,  List<VisaOption> alternatives,  List<String> notes)?  $default,) {final _that = this;
switch (_that) {
case _VisaRecommendationResponse() when $default != null:
return $default(_that.recommended,_that.alternatives,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaRecommendationResponse implements VisaRecommendationResponse {
  const _VisaRecommendationResponse({required this.recommended, final  List<VisaOption> alternatives = const [], final  List<String> notes = const []}): _alternatives = alternatives,_notes = notes;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaRecommendationResponse&&(identical(other.recommended, recommended) || other.recommended == recommended)&&const DeepCollectionEquality().equals(other._alternatives, _alternatives)&&const DeepCollectionEquality().equals(other._notes, _notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recommended,const DeepCollectionEquality().hash(_alternatives),const DeepCollectionEquality().hash(_notes));

@override
String toString() {
  return 'VisaRecommendationResponse(recommended: $recommended, alternatives: $alternatives, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$VisaRecommendationResponseCopyWith<$Res> implements $VisaRecommendationResponseCopyWith<$Res> {
  factory _$VisaRecommendationResponseCopyWith(_VisaRecommendationResponse value, $Res Function(_VisaRecommendationResponse) _then) = __$VisaRecommendationResponseCopyWithImpl;
@override @useResult
$Res call({
 VisaOption recommended, List<VisaOption> alternatives, List<String> notes
});


@override $VisaOptionCopyWith<$Res> get recommended;

}
/// @nodoc
class __$VisaRecommendationResponseCopyWithImpl<$Res>
    implements _$VisaRecommendationResponseCopyWith<$Res> {
  __$VisaRecommendationResponseCopyWithImpl(this._self, this._then);

  final _VisaRecommendationResponse _self;
  final $Res Function(_VisaRecommendationResponse) _then;

/// Create a copy of VisaRecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recommended = null,Object? alternatives = null,Object? notes = null,}) {
  return _then(_VisaRecommendationResponse(
recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as VisaOption,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<VisaOption>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>,
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
}
}


/// @nodoc
mixin _$VisaOption {

 String get code; String get name; String get summary; List<String> get requirements; List<String> get notes;
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
 String code, String name, String summary, List<String> requirements, List<String> notes
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
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? summary = null,Object? requirements = null,Object? notes = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  String summary,  List<String> requirements,  List<String> notes)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  String summary,  List<String> requirements,  List<String> notes)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  String summary,  List<String> requirements,  List<String> notes)?  $default,) {final _that = this;
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
  const _VisaOption({required this.code, required this.name, required this.summary, final  List<String> requirements = const [], final  List<String> notes = const []}): _requirements = requirements,_notes = notes;
  factory _VisaOption.fromJson(Map<String, dynamic> json) => _$VisaOptionFromJson(json);

@override final  String code;
@override final  String name;
@override final  String summary;
 final  List<String> _requirements;
@override@JsonKey() List<String> get requirements {
  if (_requirements is EqualUnmodifiableListView) return _requirements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requirements);
}

 final  List<String> _notes;
@override@JsonKey() List<String> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
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
 String code, String name, String summary, List<String> requirements, List<String> notes
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
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? summary = null,Object? requirements = null,Object? notes = null,}) {
  return _then(_VisaOption(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self._requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
