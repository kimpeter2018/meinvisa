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

 String get id; String get questionText;@QuestionTypeConverter() QuestionType get questionType; String get category; String? get optionsSource; List<String> get options; String? get parentCondition;
/// Create a copy of VisaQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaQuestionCopyWith<VisaQuestion> get copyWith => _$VisaQuestionCopyWithImpl<VisaQuestion>(this as VisaQuestion, _$identity);

  /// Serializes this VisaQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.category, category) || other.category == category)&&(identical(other.optionsSource, optionsSource) || other.optionsSource == optionsSource)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.parentCondition, parentCondition) || other.parentCondition == parentCondition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionText,questionType,category,optionsSource,const DeepCollectionEquality().hash(options),parentCondition);

@override
String toString() {
  return 'VisaQuestion(id: $id, questionText: $questionText, questionType: $questionType, category: $category, optionsSource: $optionsSource, options: $options, parentCondition: $parentCondition)';
}


}

/// @nodoc
abstract mixin class $VisaQuestionCopyWith<$Res>  {
  factory $VisaQuestionCopyWith(VisaQuestion value, $Res Function(VisaQuestion) _then) = _$VisaQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String questionText,@QuestionTypeConverter() QuestionType questionType, String category, String? optionsSource, List<String> options, String? parentCondition
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? questionText = null,Object? questionType = null,Object? category = null,Object? optionsSource = freezed,Object? options = null,Object? parentCondition = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,questionType: null == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as QuestionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,optionsSource: freezed == optionsSource ? _self.optionsSource : optionsSource // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,parentCondition: freezed == parentCondition ? _self.parentCondition : parentCondition // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String questionText, @QuestionTypeConverter()  QuestionType questionType,  String category,  String? optionsSource,  List<String> options,  String? parentCondition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaQuestion() when $default != null:
return $default(_that.id,_that.questionText,_that.questionType,_that.category,_that.optionsSource,_that.options,_that.parentCondition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String questionText, @QuestionTypeConverter()  QuestionType questionType,  String category,  String? optionsSource,  List<String> options,  String? parentCondition)  $default,) {final _that = this;
switch (_that) {
case _VisaQuestion():
return $default(_that.id,_that.questionText,_that.questionType,_that.category,_that.optionsSource,_that.options,_that.parentCondition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String questionText, @QuestionTypeConverter()  QuestionType questionType,  String category,  String? optionsSource,  List<String> options,  String? parentCondition)?  $default,) {final _that = this;
switch (_that) {
case _VisaQuestion() when $default != null:
return $default(_that.id,_that.questionText,_that.questionType,_that.category,_that.optionsSource,_that.options,_that.parentCondition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaQuestion implements VisaQuestion {
  const _VisaQuestion({required this.id, required this.questionText, @QuestionTypeConverter() required this.questionType, required this.category, this.optionsSource, final  List<String> options = const [], this.parentCondition}): _options = options;
  factory _VisaQuestion.fromJson(Map<String, dynamic> json) => _$VisaQuestionFromJson(json);

@override final  String id;
@override final  String questionText;
@override@QuestionTypeConverter() final  QuestionType questionType;
@override final  String category;
@override final  String? optionsSource;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  String? parentCondition;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.category, category) || other.category == category)&&(identical(other.optionsSource, optionsSource) || other.optionsSource == optionsSource)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.parentCondition, parentCondition) || other.parentCondition == parentCondition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionText,questionType,category,optionsSource,const DeepCollectionEquality().hash(_options),parentCondition);

@override
String toString() {
  return 'VisaQuestion(id: $id, questionText: $questionText, questionType: $questionType, category: $category, optionsSource: $optionsSource, options: $options, parentCondition: $parentCondition)';
}


}

/// @nodoc
abstract mixin class _$VisaQuestionCopyWith<$Res> implements $VisaQuestionCopyWith<$Res> {
  factory _$VisaQuestionCopyWith(_VisaQuestion value, $Res Function(_VisaQuestion) _then) = __$VisaQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String questionText,@QuestionTypeConverter() QuestionType questionType, String category, String? optionsSource, List<String> options, String? parentCondition
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? questionText = null,Object? questionType = null,Object? category = null,Object? optionsSource = freezed,Object? options = null,Object? parentCondition = freezed,}) {
  return _then(_VisaQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,questionType: null == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as QuestionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,optionsSource: freezed == optionsSource ? _self.optionsSource : optionsSource // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,parentCondition: freezed == parentCondition ? _self.parentCondition : parentCondition // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
