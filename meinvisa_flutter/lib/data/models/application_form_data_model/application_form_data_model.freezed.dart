// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_form_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplicationFormData {

 Map<String, dynamic> get preFilledData; Map<String, dynamic> get additionalData; Map<String, dynamic> get editedData; Map<String, bool> get fieldVerified;
/// Create a copy of ApplicationFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationFormDataCopyWith<ApplicationFormData> get copyWith => _$ApplicationFormDataCopyWithImpl<ApplicationFormData>(this as ApplicationFormData, _$identity);

  /// Serializes this ApplicationFormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationFormData&&const DeepCollectionEquality().equals(other.preFilledData, preFilledData)&&const DeepCollectionEquality().equals(other.additionalData, additionalData)&&const DeepCollectionEquality().equals(other.editedData, editedData)&&const DeepCollectionEquality().equals(other.fieldVerified, fieldVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(preFilledData),const DeepCollectionEquality().hash(additionalData),const DeepCollectionEquality().hash(editedData),const DeepCollectionEquality().hash(fieldVerified));

@override
String toString() {
  return 'ApplicationFormData(preFilledData: $preFilledData, additionalData: $additionalData, editedData: $editedData, fieldVerified: $fieldVerified)';
}


}

/// @nodoc
abstract mixin class $ApplicationFormDataCopyWith<$Res>  {
  factory $ApplicationFormDataCopyWith(ApplicationFormData value, $Res Function(ApplicationFormData) _then) = _$ApplicationFormDataCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> preFilledData, Map<String, dynamic> additionalData, Map<String, dynamic> editedData, Map<String, bool> fieldVerified
});




}
/// @nodoc
class _$ApplicationFormDataCopyWithImpl<$Res>
    implements $ApplicationFormDataCopyWith<$Res> {
  _$ApplicationFormDataCopyWithImpl(this._self, this._then);

  final ApplicationFormData _self;
  final $Res Function(ApplicationFormData) _then;

/// Create a copy of ApplicationFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preFilledData = null,Object? additionalData = null,Object? editedData = null,Object? fieldVerified = null,}) {
  return _then(_self.copyWith(
preFilledData: null == preFilledData ? _self.preFilledData : preFilledData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,additionalData: null == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,editedData: null == editedData ? _self.editedData : editedData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,fieldVerified: null == fieldVerified ? _self.fieldVerified : fieldVerified // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplicationFormData].
extension ApplicationFormDataPatterns on ApplicationFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationFormData value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationFormData value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationFormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> preFilledData,  Map<String, dynamic> additionalData,  Map<String, dynamic> editedData,  Map<String, bool> fieldVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationFormData() when $default != null:
return $default(_that.preFilledData,_that.additionalData,_that.editedData,_that.fieldVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> preFilledData,  Map<String, dynamic> additionalData,  Map<String, dynamic> editedData,  Map<String, bool> fieldVerified)  $default,) {final _that = this;
switch (_that) {
case _ApplicationFormData():
return $default(_that.preFilledData,_that.additionalData,_that.editedData,_that.fieldVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> preFilledData,  Map<String, dynamic> additionalData,  Map<String, dynamic> editedData,  Map<String, bool> fieldVerified)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationFormData() when $default != null:
return $default(_that.preFilledData,_that.additionalData,_that.editedData,_that.fieldVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicationFormData implements ApplicationFormData {
  const _ApplicationFormData({final  Map<String, dynamic> preFilledData = const {}, final  Map<String, dynamic> additionalData = const {}, final  Map<String, dynamic> editedData = const {}, final  Map<String, bool> fieldVerified = const {}}): _preFilledData = preFilledData,_additionalData = additionalData,_editedData = editedData,_fieldVerified = fieldVerified;
  factory _ApplicationFormData.fromJson(Map<String, dynamic> json) => _$ApplicationFormDataFromJson(json);

 final  Map<String, dynamic> _preFilledData;
@override@JsonKey() Map<String, dynamic> get preFilledData {
  if (_preFilledData is EqualUnmodifiableMapView) return _preFilledData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preFilledData);
}

 final  Map<String, dynamic> _additionalData;
@override@JsonKey() Map<String, dynamic> get additionalData {
  if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_additionalData);
}

 final  Map<String, dynamic> _editedData;
@override@JsonKey() Map<String, dynamic> get editedData {
  if (_editedData is EqualUnmodifiableMapView) return _editedData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_editedData);
}

 final  Map<String, bool> _fieldVerified;
@override@JsonKey() Map<String, bool> get fieldVerified {
  if (_fieldVerified is EqualUnmodifiableMapView) return _fieldVerified;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fieldVerified);
}


/// Create a copy of ApplicationFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationFormDataCopyWith<_ApplicationFormData> get copyWith => __$ApplicationFormDataCopyWithImpl<_ApplicationFormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationFormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationFormData&&const DeepCollectionEquality().equals(other._preFilledData, _preFilledData)&&const DeepCollectionEquality().equals(other._additionalData, _additionalData)&&const DeepCollectionEquality().equals(other._editedData, _editedData)&&const DeepCollectionEquality().equals(other._fieldVerified, _fieldVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_preFilledData),const DeepCollectionEquality().hash(_additionalData),const DeepCollectionEquality().hash(_editedData),const DeepCollectionEquality().hash(_fieldVerified));

@override
String toString() {
  return 'ApplicationFormData(preFilledData: $preFilledData, additionalData: $additionalData, editedData: $editedData, fieldVerified: $fieldVerified)';
}


}

/// @nodoc
abstract mixin class _$ApplicationFormDataCopyWith<$Res> implements $ApplicationFormDataCopyWith<$Res> {
  factory _$ApplicationFormDataCopyWith(_ApplicationFormData value, $Res Function(_ApplicationFormData) _then) = __$ApplicationFormDataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> preFilledData, Map<String, dynamic> additionalData, Map<String, dynamic> editedData, Map<String, bool> fieldVerified
});




}
/// @nodoc
class __$ApplicationFormDataCopyWithImpl<$Res>
    implements _$ApplicationFormDataCopyWith<$Res> {
  __$ApplicationFormDataCopyWithImpl(this._self, this._then);

  final _ApplicationFormData _self;
  final $Res Function(_ApplicationFormData) _then;

/// Create a copy of ApplicationFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preFilledData = null,Object? additionalData = null,Object? editedData = null,Object? fieldVerified = null,}) {
  return _then(_ApplicationFormData(
preFilledData: null == preFilledData ? _self._preFilledData : preFilledData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,additionalData: null == additionalData ? _self._additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,editedData: null == editedData ? _self._editedData : editedData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,fieldVerified: null == fieldVerified ? _self._fieldVerified : fieldVerified // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

// dart format on
