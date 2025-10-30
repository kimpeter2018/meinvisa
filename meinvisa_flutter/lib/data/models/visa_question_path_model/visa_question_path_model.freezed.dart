// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visa_question_path_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisaQuestionPath {

 String get id;// uuid in DB
 String get fromField; String? get answerValue; List<String> get nextCategories; List<String> get nextQuestionKeys; String? get conditionType; String? get description;
/// Create a copy of VisaQuestionPath
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaQuestionPathCopyWith<VisaQuestionPath> get copyWith => _$VisaQuestionPathCopyWithImpl<VisaQuestionPath>(this as VisaQuestionPath, _$identity);

  /// Serializes this VisaQuestionPath to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaQuestionPath&&(identical(other.id, id) || other.id == id)&&(identical(other.fromField, fromField) || other.fromField == fromField)&&(identical(other.answerValue, answerValue) || other.answerValue == answerValue)&&const DeepCollectionEquality().equals(other.nextCategories, nextCategories)&&const DeepCollectionEquality().equals(other.nextQuestionKeys, nextQuestionKeys)&&(identical(other.conditionType, conditionType) || other.conditionType == conditionType)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromField,answerValue,const DeepCollectionEquality().hash(nextCategories),const DeepCollectionEquality().hash(nextQuestionKeys),conditionType,description);

@override
String toString() {
  return 'VisaQuestionPath(id: $id, fromField: $fromField, answerValue: $answerValue, nextCategories: $nextCategories, nextQuestionKeys: $nextQuestionKeys, conditionType: $conditionType, description: $description)';
}


}

/// @nodoc
abstract mixin class $VisaQuestionPathCopyWith<$Res>  {
  factory $VisaQuestionPathCopyWith(VisaQuestionPath value, $Res Function(VisaQuestionPath) _then) = _$VisaQuestionPathCopyWithImpl;
@useResult
$Res call({
 String id, String fromField, String? answerValue, List<String> nextCategories, List<String> nextQuestionKeys, String? conditionType, String? description
});




}
/// @nodoc
class _$VisaQuestionPathCopyWithImpl<$Res>
    implements $VisaQuestionPathCopyWith<$Res> {
  _$VisaQuestionPathCopyWithImpl(this._self, this._then);

  final VisaQuestionPath _self;
  final $Res Function(VisaQuestionPath) _then;

/// Create a copy of VisaQuestionPath
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromField = null,Object? answerValue = freezed,Object? nextCategories = null,Object? nextQuestionKeys = null,Object? conditionType = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromField: null == fromField ? _self.fromField : fromField // ignore: cast_nullable_to_non_nullable
as String,answerValue: freezed == answerValue ? _self.answerValue : answerValue // ignore: cast_nullable_to_non_nullable
as String?,nextCategories: null == nextCategories ? _self.nextCategories : nextCategories // ignore: cast_nullable_to_non_nullable
as List<String>,nextQuestionKeys: null == nextQuestionKeys ? _self.nextQuestionKeys : nextQuestionKeys // ignore: cast_nullable_to_non_nullable
as List<String>,conditionType: freezed == conditionType ? _self.conditionType : conditionType // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisaQuestionPath].
extension VisaQuestionPathPatterns on VisaQuestionPath {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisaQuestionPath value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisaQuestionPath() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisaQuestionPath value)  $default,){
final _that = this;
switch (_that) {
case _VisaQuestionPath():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisaQuestionPath value)?  $default,){
final _that = this;
switch (_that) {
case _VisaQuestionPath() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fromField,  String? answerValue,  List<String> nextCategories,  List<String> nextQuestionKeys,  String? conditionType,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaQuestionPath() when $default != null:
return $default(_that.id,_that.fromField,_that.answerValue,_that.nextCategories,_that.nextQuestionKeys,_that.conditionType,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fromField,  String? answerValue,  List<String> nextCategories,  List<String> nextQuestionKeys,  String? conditionType,  String? description)  $default,) {final _that = this;
switch (_that) {
case _VisaQuestionPath():
return $default(_that.id,_that.fromField,_that.answerValue,_that.nextCategories,_that.nextQuestionKeys,_that.conditionType,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fromField,  String? answerValue,  List<String> nextCategories,  List<String> nextQuestionKeys,  String? conditionType,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _VisaQuestionPath() when $default != null:
return $default(_that.id,_that.fromField,_that.answerValue,_that.nextCategories,_that.nextQuestionKeys,_that.conditionType,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaQuestionPath implements VisaQuestionPath {
  const _VisaQuestionPath({required this.id, required this.fromField, this.answerValue, final  List<String> nextCategories = const [], final  List<String> nextQuestionKeys = const [], required this.conditionType, this.description}): _nextCategories = nextCategories,_nextQuestionKeys = nextQuestionKeys;
  factory _VisaQuestionPath.fromJson(Map<String, dynamic> json) => _$VisaQuestionPathFromJson(json);

@override final  String id;
// uuid in DB
@override final  String fromField;
@override final  String? answerValue;
 final  List<String> _nextCategories;
@override@JsonKey() List<String> get nextCategories {
  if (_nextCategories is EqualUnmodifiableListView) return _nextCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nextCategories);
}

 final  List<String> _nextQuestionKeys;
@override@JsonKey() List<String> get nextQuestionKeys {
  if (_nextQuestionKeys is EqualUnmodifiableListView) return _nextQuestionKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nextQuestionKeys);
}

@override final  String? conditionType;
@override final  String? description;

/// Create a copy of VisaQuestionPath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisaQuestionPathCopyWith<_VisaQuestionPath> get copyWith => __$VisaQuestionPathCopyWithImpl<_VisaQuestionPath>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisaQuestionPathToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaQuestionPath&&(identical(other.id, id) || other.id == id)&&(identical(other.fromField, fromField) || other.fromField == fromField)&&(identical(other.answerValue, answerValue) || other.answerValue == answerValue)&&const DeepCollectionEquality().equals(other._nextCategories, _nextCategories)&&const DeepCollectionEquality().equals(other._nextQuestionKeys, _nextQuestionKeys)&&(identical(other.conditionType, conditionType) || other.conditionType == conditionType)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromField,answerValue,const DeepCollectionEquality().hash(_nextCategories),const DeepCollectionEquality().hash(_nextQuestionKeys),conditionType,description);

@override
String toString() {
  return 'VisaQuestionPath(id: $id, fromField: $fromField, answerValue: $answerValue, nextCategories: $nextCategories, nextQuestionKeys: $nextQuestionKeys, conditionType: $conditionType, description: $description)';
}


}

/// @nodoc
abstract mixin class _$VisaQuestionPathCopyWith<$Res> implements $VisaQuestionPathCopyWith<$Res> {
  factory _$VisaQuestionPathCopyWith(_VisaQuestionPath value, $Res Function(_VisaQuestionPath) _then) = __$VisaQuestionPathCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromField, String? answerValue, List<String> nextCategories, List<String> nextQuestionKeys, String? conditionType, String? description
});




}
/// @nodoc
class __$VisaQuestionPathCopyWithImpl<$Res>
    implements _$VisaQuestionPathCopyWith<$Res> {
  __$VisaQuestionPathCopyWithImpl(this._self, this._then);

  final _VisaQuestionPath _self;
  final $Res Function(_VisaQuestionPath) _then;

/// Create a copy of VisaQuestionPath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromField = null,Object? answerValue = freezed,Object? nextCategories = null,Object? nextQuestionKeys = null,Object? conditionType = freezed,Object? description = freezed,}) {
  return _then(_VisaQuestionPath(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromField: null == fromField ? _self.fromField : fromField // ignore: cast_nullable_to_non_nullable
as String,answerValue: freezed == answerValue ? _self.answerValue : answerValue // ignore: cast_nullable_to_non_nullable
as String?,nextCategories: null == nextCategories ? _self._nextCategories : nextCategories // ignore: cast_nullable_to_non_nullable
as List<String>,nextQuestionKeys: null == nextQuestionKeys ? _self._nextQuestionKeys : nextQuestionKeys // ignore: cast_nullable_to_non_nullable
as List<String>,conditionType: freezed == conditionType ? _self.conditionType : conditionType // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
