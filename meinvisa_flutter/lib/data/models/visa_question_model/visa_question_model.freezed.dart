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

 String get uid;// Supabase-generated UUID
 int get id;// Optional sequential ID
 String get category;// e.g. 'universal', 'work:general'
 String get question; String get fieldKey;@QuestionTypeConverter() QuestionType get questionType; String? get purpose; String? get optionsSource; List<String> get options; bool get required; int? get orderIndex;
/// Create a copy of VisaQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaQuestionCopyWith<VisaQuestion> get copyWith => _$VisaQuestionCopyWithImpl<VisaQuestion>(this as VisaQuestion, _$identity);

  /// Serializes this VisaQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaQuestion&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.question, question) || other.question == question)&&(identical(other.fieldKey, fieldKey) || other.fieldKey == fieldKey)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.optionsSource, optionsSource) || other.optionsSource == optionsSource)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.required, required) || other.required == required)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,id,category,question,fieldKey,questionType,purpose,optionsSource,const DeepCollectionEquality().hash(options),required,orderIndex);

@override
String toString() {
  return 'VisaQuestion(uid: $uid, id: $id, category: $category, question: $question, fieldKey: $fieldKey, questionType: $questionType, purpose: $purpose, optionsSource: $optionsSource, options: $options, required: $required, orderIndex: $orderIndex)';
}


}

/// @nodoc
abstract mixin class $VisaQuestionCopyWith<$Res>  {
  factory $VisaQuestionCopyWith(VisaQuestion value, $Res Function(VisaQuestion) _then) = _$VisaQuestionCopyWithImpl;
@useResult
$Res call({
 String uid, int id, String category, String question, String fieldKey,@QuestionTypeConverter() QuestionType questionType, String? purpose, String? optionsSource, List<String> options, bool required, int? orderIndex
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
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? id = null,Object? category = null,Object? question = null,Object? fieldKey = null,Object? questionType = null,Object? purpose = freezed,Object? optionsSource = freezed,Object? options = null,Object? required = null,Object? orderIndex = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,fieldKey: null == fieldKey ? _self.fieldKey : fieldKey // ignore: cast_nullable_to_non_nullable
as String,questionType: null == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as QuestionType,purpose: freezed == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String?,optionsSource: freezed == optionsSource ? _self.optionsSource : optionsSource // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,orderIndex: freezed == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  int id,  String category,  String question,  String fieldKey, @QuestionTypeConverter()  QuestionType questionType,  String? purpose,  String? optionsSource,  List<String> options,  bool required,  int? orderIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaQuestion() when $default != null:
return $default(_that.uid,_that.id,_that.category,_that.question,_that.fieldKey,_that.questionType,_that.purpose,_that.optionsSource,_that.options,_that.required,_that.orderIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  int id,  String category,  String question,  String fieldKey, @QuestionTypeConverter()  QuestionType questionType,  String? purpose,  String? optionsSource,  List<String> options,  bool required,  int? orderIndex)  $default,) {final _that = this;
switch (_that) {
case _VisaQuestion():
return $default(_that.uid,_that.id,_that.category,_that.question,_that.fieldKey,_that.questionType,_that.purpose,_that.optionsSource,_that.options,_that.required,_that.orderIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  int id,  String category,  String question,  String fieldKey, @QuestionTypeConverter()  QuestionType questionType,  String? purpose,  String? optionsSource,  List<String> options,  bool required,  int? orderIndex)?  $default,) {final _that = this;
switch (_that) {
case _VisaQuestion() when $default != null:
return $default(_that.uid,_that.id,_that.category,_that.question,_that.fieldKey,_that.questionType,_that.purpose,_that.optionsSource,_that.options,_that.required,_that.orderIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaQuestion implements VisaQuestion {
  const _VisaQuestion({required this.uid, required this.id, required this.category, required this.question, required this.fieldKey, @QuestionTypeConverter() required this.questionType, this.purpose, this.optionsSource, final  List<String> options = const [], this.required = false, this.orderIndex}): _options = options;
  factory _VisaQuestion.fromJson(Map<String, dynamic> json) => _$VisaQuestionFromJson(json);

@override final  String uid;
// Supabase-generated UUID
@override final  int id;
// Optional sequential ID
@override final  String category;
// e.g. 'universal', 'work:general'
@override final  String question;
@override final  String fieldKey;
@override@QuestionTypeConverter() final  QuestionType questionType;
@override final  String? purpose;
@override final  String? optionsSource;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey() final  bool required;
@override final  int? orderIndex;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaQuestion&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.question, question) || other.question == question)&&(identical(other.fieldKey, fieldKey) || other.fieldKey == fieldKey)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.optionsSource, optionsSource) || other.optionsSource == optionsSource)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.required, required) || other.required == required)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,id,category,question,fieldKey,questionType,purpose,optionsSource,const DeepCollectionEquality().hash(_options),required,orderIndex);

@override
String toString() {
  return 'VisaQuestion(uid: $uid, id: $id, category: $category, question: $question, fieldKey: $fieldKey, questionType: $questionType, purpose: $purpose, optionsSource: $optionsSource, options: $options, required: $required, orderIndex: $orderIndex)';
}


}

/// @nodoc
abstract mixin class _$VisaQuestionCopyWith<$Res> implements $VisaQuestionCopyWith<$Res> {
  factory _$VisaQuestionCopyWith(_VisaQuestion value, $Res Function(_VisaQuestion) _then) = __$VisaQuestionCopyWithImpl;
@override @useResult
$Res call({
 String uid, int id, String category, String question, String fieldKey,@QuestionTypeConverter() QuestionType questionType, String? purpose, String? optionsSource, List<String> options, bool required, int? orderIndex
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
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? id = null,Object? category = null,Object? question = null,Object? fieldKey = null,Object? questionType = null,Object? purpose = freezed,Object? optionsSource = freezed,Object? options = null,Object? required = null,Object? orderIndex = freezed,}) {
  return _then(_VisaQuestion(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,fieldKey: null == fieldKey ? _self.fieldKey : fieldKey // ignore: cast_nullable_to_non_nullable
as String,questionType: null == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as QuestionType,purpose: freezed == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String?,optionsSource: freezed == optionsSource ? _self.optionsSource : optionsSource // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,orderIndex: freezed == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
