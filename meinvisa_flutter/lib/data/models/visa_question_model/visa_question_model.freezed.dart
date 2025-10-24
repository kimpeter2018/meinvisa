// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visa_question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisaQuestion {

 String get id; String get category;@JsonKey(name: 'question_text') String get questionText;@JsonKey(name: 'field_key') String get fieldKey;@JsonKey(name: 'question_type') String get questionType;@JsonKey(name: 'options_source') String? get optionsSource;@JsonKey(name: 'required') bool? get isRequired;@JsonKey(name: 'order_index') int? get orderIndex;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of VisaQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaQuestionCopyWith<VisaQuestion> get copyWith => _$VisaQuestionCopyWithImpl<VisaQuestion>(this as VisaQuestion, _$identity);

  /// Serializes this VisaQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.fieldKey, fieldKey) || other.fieldKey == fieldKey)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.optionsSource, optionsSource) || other.optionsSource == optionsSource)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,questionText,fieldKey,questionType,optionsSource,isRequired,orderIndex,createdAt,updatedAt);

@override
String toString() {
  return 'VisaQuestion(id: $id, category: $category, questionText: $questionText, fieldKey: $fieldKey, questionType: $questionType, optionsSource: $optionsSource, isRequired: $isRequired, orderIndex: $orderIndex, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VisaQuestionCopyWith<$Res>  {
  factory $VisaQuestionCopyWith(VisaQuestion value, $Res Function(VisaQuestion) _then) = _$VisaQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String category,@JsonKey(name: 'question_text') String questionText,@JsonKey(name: 'field_key') String fieldKey,@JsonKey(name: 'question_type') String questionType,@JsonKey(name: 'options_source') String? optionsSource,@JsonKey(name: 'required') bool? isRequired,@JsonKey(name: 'order_index') int? orderIndex,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$VisaQuestionCopyWithImpl<$Res>
    implements $VisaQuestionCopyWith<$Res> {
  _$VisaQuestionCopyWithImpl(this._self, this._then);

  final VisaQuestion _self;
  final $Res Function(VisaQuestion) _then;

/// Create a copy of VisaQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? questionText = null,Object? fieldKey = null,Object? questionType = null,Object? optionsSource = freezed,Object? isRequired = freezed,Object? orderIndex = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,fieldKey: null == fieldKey ? _self.fieldKey : fieldKey // ignore: cast_nullable_to_non_nullable
as String,questionType: null == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as String,optionsSource: freezed == optionsSource ? _self.optionsSource : optionsSource // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,orderIndex: freezed == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisaQuestion].
extension VisaQuestionPatterns on VisaQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisaQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisaQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisaQuestion value)  $default,){
final _that = this;
switch (_that) {
case _VisaQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisaQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _VisaQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'field_key')  String fieldKey, @JsonKey(name: 'question_type')  String questionType, @JsonKey(name: 'options_source')  String? optionsSource, @JsonKey(name: 'required')  bool? isRequired, @JsonKey(name: 'order_index')  int? orderIndex, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaQuestion() when $default != null:
return $default(_that.id,_that.category,_that.questionText,_that.fieldKey,_that.questionType,_that.optionsSource,_that.isRequired,_that.orderIndex,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'field_key')  String fieldKey, @JsonKey(name: 'question_type')  String questionType, @JsonKey(name: 'options_source')  String? optionsSource, @JsonKey(name: 'required')  bool? isRequired, @JsonKey(name: 'order_index')  int? orderIndex, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _VisaQuestion():
return $default(_that.id,_that.category,_that.questionText,_that.fieldKey,_that.questionType,_that.optionsSource,_that.isRequired,_that.orderIndex,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'field_key')  String fieldKey, @JsonKey(name: 'question_type')  String questionType, @JsonKey(name: 'options_source')  String? optionsSource, @JsonKey(name: 'required')  bool? isRequired, @JsonKey(name: 'order_index')  int? orderIndex, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _VisaQuestion() when $default != null:
return $default(_that.id,_that.category,_that.questionText,_that.fieldKey,_that.questionType,_that.optionsSource,_that.isRequired,_that.orderIndex,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaQuestion implements VisaQuestion {
  const _VisaQuestion({required this.id, required this.category, @JsonKey(name: 'question_text') required this.questionText, @JsonKey(name: 'field_key') required this.fieldKey, @JsonKey(name: 'question_type') required this.questionType, @JsonKey(name: 'options_source') this.optionsSource, @JsonKey(name: 'required') this.isRequired, @JsonKey(name: 'order_index') this.orderIndex, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _VisaQuestion.fromJson(Map<String, dynamic> json) => _$VisaQuestionFromJson(json);

@override final  String id;
@override final  String category;
@override@JsonKey(name: 'question_text') final  String questionText;
@override@JsonKey(name: 'field_key') final  String fieldKey;
@override@JsonKey(name: 'question_type') final  String questionType;
@override@JsonKey(name: 'options_source') final  String? optionsSource;
@override@JsonKey(name: 'required') final  bool? isRequired;
@override@JsonKey(name: 'order_index') final  int? orderIndex;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of VisaQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisaQuestionCopyWith<_VisaQuestion> get copyWith => __$VisaQuestionCopyWithImpl<_VisaQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisaQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.fieldKey, fieldKey) || other.fieldKey == fieldKey)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.optionsSource, optionsSource) || other.optionsSource == optionsSource)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,questionText,fieldKey,questionType,optionsSource,isRequired,orderIndex,createdAt,updatedAt);

@override
String toString() {
  return 'VisaQuestion(id: $id, category: $category, questionText: $questionText, fieldKey: $fieldKey, questionType: $questionType, optionsSource: $optionsSource, isRequired: $isRequired, orderIndex: $orderIndex, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VisaQuestionCopyWith<$Res> implements $VisaQuestionCopyWith<$Res> {
  factory _$VisaQuestionCopyWith(_VisaQuestion value, $Res Function(_VisaQuestion) _then) = __$VisaQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String category,@JsonKey(name: 'question_text') String questionText,@JsonKey(name: 'field_key') String fieldKey,@JsonKey(name: 'question_type') String questionType,@JsonKey(name: 'options_source') String? optionsSource,@JsonKey(name: 'required') bool? isRequired,@JsonKey(name: 'order_index') int? orderIndex,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$VisaQuestionCopyWithImpl<$Res>
    implements _$VisaQuestionCopyWith<$Res> {
  __$VisaQuestionCopyWithImpl(this._self, this._then);

  final _VisaQuestion _self;
  final $Res Function(_VisaQuestion) _then;

/// Create a copy of VisaQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? questionText = null,Object? fieldKey = null,Object? questionType = null,Object? optionsSource = freezed,Object? isRequired = freezed,Object? orderIndex = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_VisaQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,fieldKey: null == fieldKey ? _self.fieldKey : fieldKey // ignore: cast_nullable_to_non_nullable
as String,questionType: null == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as String,optionsSource: freezed == optionsSource ? _self.optionsSource : optionsSource // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,orderIndex: freezed == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
