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

// Universal
 String? get purpose; String? get nationality; bool? get hasPermit; bool? get hasFamily; String? get germanLevel; String? get englishLevel;@DateTimeConverter() DateTime? get birthday; int? get age;// Work: General
 bool? get hasJobOffer; String? get profession; int? get experienceYears; bool? get hasDegree; String? get degreeField; String? get degreeOrigin; bool? get hasVocational; int? get salary; String? get employmentStatus; bool? get isSelfEmployed; bool? get hasAnerkennung;// Work: IT
 bool? get isItField; bool? get itExperience;// Work: Driver
 bool? get hasLicense; int? get drivingYears;// Work: Artist
 bool? get hasPerformance; int? get performanceCount;// Work: Teacher
 bool? get isLanguageTeacher;// Work: Sports
 bool? get isAthlete;// Work: Esports
 bool? get isEsports;// Education: General
 String? get eduLevel; String? get studyField; bool? get admitted;@DateTimeConverter() DateTime? get programStart; bool? get proofFunds;// Education: Language Course
 bool? get isLanguageCourse; bool? get fulltimeGerman;// Education: Ausbildung
 bool? get isAusbildung;// Education: Nursing
 bool? get isNursing;// Education: Internship
 bool? get internshipRelated; bool? get internshipType;// Research: General
 bool? get hasHostAgreement; bool? get researchFunded;// Personal: General
 bool? get hasFamilyInGermany; String? get personalRoute; bool? get hasHostContract;// Startup: General
 bool? get isStartup; String? get businessSector; bool? get hasFunding;// Meta
 String? get applyLocation; String? get currentResidence; bool? get hasInsurance; bool? get hasAccommodation;
/// Create a copy of VisaQuestionnaire
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisaQuestionnaireCopyWith<VisaQuestionnaire> get copyWith => _$VisaQuestionnaireCopyWithImpl<VisaQuestionnaire>(this as VisaQuestionnaire, _$identity);

  /// Serializes this VisaQuestionnaire to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisaQuestionnaire&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.hasPermit, hasPermit) || other.hasPermit == hasPermit)&&(identical(other.hasFamily, hasFamily) || other.hasFamily == hasFamily)&&(identical(other.germanLevel, germanLevel) || other.germanLevel == germanLevel)&&(identical(other.englishLevel, englishLevel) || other.englishLevel == englishLevel)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.age, age) || other.age == age)&&(identical(other.hasJobOffer, hasJobOffer) || other.hasJobOffer == hasJobOffer)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.hasDegree, hasDegree) || other.hasDegree == hasDegree)&&(identical(other.degreeField, degreeField) || other.degreeField == degreeField)&&(identical(other.degreeOrigin, degreeOrigin) || other.degreeOrigin == degreeOrigin)&&(identical(other.hasVocational, hasVocational) || other.hasVocational == hasVocational)&&(identical(other.salary, salary) || other.salary == salary)&&(identical(other.employmentStatus, employmentStatus) || other.employmentStatus == employmentStatus)&&(identical(other.isSelfEmployed, isSelfEmployed) || other.isSelfEmployed == isSelfEmployed)&&(identical(other.hasAnerkennung, hasAnerkennung) || other.hasAnerkennung == hasAnerkennung)&&(identical(other.isItField, isItField) || other.isItField == isItField)&&(identical(other.itExperience, itExperience) || other.itExperience == itExperience)&&(identical(other.hasLicense, hasLicense) || other.hasLicense == hasLicense)&&(identical(other.drivingYears, drivingYears) || other.drivingYears == drivingYears)&&(identical(other.hasPerformance, hasPerformance) || other.hasPerformance == hasPerformance)&&(identical(other.performanceCount, performanceCount) || other.performanceCount == performanceCount)&&(identical(other.isLanguageTeacher, isLanguageTeacher) || other.isLanguageTeacher == isLanguageTeacher)&&(identical(other.isAthlete, isAthlete) || other.isAthlete == isAthlete)&&(identical(other.isEsports, isEsports) || other.isEsports == isEsports)&&(identical(other.eduLevel, eduLevel) || other.eduLevel == eduLevel)&&(identical(other.studyField, studyField) || other.studyField == studyField)&&(identical(other.admitted, admitted) || other.admitted == admitted)&&(identical(other.programStart, programStart) || other.programStart == programStart)&&(identical(other.proofFunds, proofFunds) || other.proofFunds == proofFunds)&&(identical(other.isLanguageCourse, isLanguageCourse) || other.isLanguageCourse == isLanguageCourse)&&(identical(other.fulltimeGerman, fulltimeGerman) || other.fulltimeGerman == fulltimeGerman)&&(identical(other.isAusbildung, isAusbildung) || other.isAusbildung == isAusbildung)&&(identical(other.isNursing, isNursing) || other.isNursing == isNursing)&&(identical(other.internshipRelated, internshipRelated) || other.internshipRelated == internshipRelated)&&(identical(other.internshipType, internshipType) || other.internshipType == internshipType)&&(identical(other.hasHostAgreement, hasHostAgreement) || other.hasHostAgreement == hasHostAgreement)&&(identical(other.researchFunded, researchFunded) || other.researchFunded == researchFunded)&&(identical(other.hasFamilyInGermany, hasFamilyInGermany) || other.hasFamilyInGermany == hasFamilyInGermany)&&(identical(other.personalRoute, personalRoute) || other.personalRoute == personalRoute)&&(identical(other.hasHostContract, hasHostContract) || other.hasHostContract == hasHostContract)&&(identical(other.isStartup, isStartup) || other.isStartup == isStartup)&&(identical(other.businessSector, businessSector) || other.businessSector == businessSector)&&(identical(other.hasFunding, hasFunding) || other.hasFunding == hasFunding)&&(identical(other.applyLocation, applyLocation) || other.applyLocation == applyLocation)&&(identical(other.currentResidence, currentResidence) || other.currentResidence == currentResidence)&&(identical(other.hasInsurance, hasInsurance) || other.hasInsurance == hasInsurance)&&(identical(other.hasAccommodation, hasAccommodation) || other.hasAccommodation == hasAccommodation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,purpose,nationality,hasPermit,hasFamily,germanLevel,englishLevel,birthday,age,hasJobOffer,profession,experienceYears,hasDegree,degreeField,degreeOrigin,hasVocational,salary,employmentStatus,isSelfEmployed,hasAnerkennung,isItField,itExperience,hasLicense,drivingYears,hasPerformance,performanceCount,isLanguageTeacher,isAthlete,isEsports,eduLevel,studyField,admitted,programStart,proofFunds,isLanguageCourse,fulltimeGerman,isAusbildung,isNursing,internshipRelated,internshipType,hasHostAgreement,researchFunded,hasFamilyInGermany,personalRoute,hasHostContract,isStartup,businessSector,hasFunding,applyLocation,currentResidence,hasInsurance,hasAccommodation]);

@override
String toString() {
  return 'VisaQuestionnaire(purpose: $purpose, nationality: $nationality, hasPermit: $hasPermit, hasFamily: $hasFamily, germanLevel: $germanLevel, englishLevel: $englishLevel, birthday: $birthday, age: $age, hasJobOffer: $hasJobOffer, profession: $profession, experienceYears: $experienceYears, hasDegree: $hasDegree, degreeField: $degreeField, degreeOrigin: $degreeOrigin, hasVocational: $hasVocational, salary: $salary, employmentStatus: $employmentStatus, isSelfEmployed: $isSelfEmployed, hasAnerkennung: $hasAnerkennung, isItField: $isItField, itExperience: $itExperience, hasLicense: $hasLicense, drivingYears: $drivingYears, hasPerformance: $hasPerformance, performanceCount: $performanceCount, isLanguageTeacher: $isLanguageTeacher, isAthlete: $isAthlete, isEsports: $isEsports, eduLevel: $eduLevel, studyField: $studyField, admitted: $admitted, programStart: $programStart, proofFunds: $proofFunds, isLanguageCourse: $isLanguageCourse, fulltimeGerman: $fulltimeGerman, isAusbildung: $isAusbildung, isNursing: $isNursing, internshipRelated: $internshipRelated, internshipType: $internshipType, hasHostAgreement: $hasHostAgreement, researchFunded: $researchFunded, hasFamilyInGermany: $hasFamilyInGermany, personalRoute: $personalRoute, hasHostContract: $hasHostContract, isStartup: $isStartup, businessSector: $businessSector, hasFunding: $hasFunding, applyLocation: $applyLocation, currentResidence: $currentResidence, hasInsurance: $hasInsurance, hasAccommodation: $hasAccommodation)';
}


}

/// @nodoc
abstract mixin class $VisaQuestionnaireCopyWith<$Res>  {
  factory $VisaQuestionnaireCopyWith(VisaQuestionnaire value, $Res Function(VisaQuestionnaire) _then) = _$VisaQuestionnaireCopyWithImpl;
@useResult
$Res call({
 String? purpose, String? nationality, bool? hasPermit, bool? hasFamily, String? germanLevel, String? englishLevel,@DateTimeConverter() DateTime? birthday, int? age, bool? hasJobOffer, String? profession, int? experienceYears, bool? hasDegree, String? degreeField, String? degreeOrigin, bool? hasVocational, int? salary, String? employmentStatus, bool? isSelfEmployed, bool? hasAnerkennung, bool? isItField, bool? itExperience, bool? hasLicense, int? drivingYears, bool? hasPerformance, int? performanceCount, bool? isLanguageTeacher, bool? isAthlete, bool? isEsports, String? eduLevel, String? studyField, bool? admitted,@DateTimeConverter() DateTime? programStart, bool? proofFunds, bool? isLanguageCourse, bool? fulltimeGerman, bool? isAusbildung, bool? isNursing, bool? internshipRelated, bool? internshipType, bool? hasHostAgreement, bool? researchFunded, bool? hasFamilyInGermany, String? personalRoute, bool? hasHostContract, bool? isStartup, String? businessSector, bool? hasFunding, String? applyLocation, String? currentResidence, bool? hasInsurance, bool? hasAccommodation
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
@pragma('vm:prefer-inline') @override $Res call({Object? purpose = freezed,Object? nationality = freezed,Object? hasPermit = freezed,Object? hasFamily = freezed,Object? germanLevel = freezed,Object? englishLevel = freezed,Object? birthday = freezed,Object? age = freezed,Object? hasJobOffer = freezed,Object? profession = freezed,Object? experienceYears = freezed,Object? hasDegree = freezed,Object? degreeField = freezed,Object? degreeOrigin = freezed,Object? hasVocational = freezed,Object? salary = freezed,Object? employmentStatus = freezed,Object? isSelfEmployed = freezed,Object? hasAnerkennung = freezed,Object? isItField = freezed,Object? itExperience = freezed,Object? hasLicense = freezed,Object? drivingYears = freezed,Object? hasPerformance = freezed,Object? performanceCount = freezed,Object? isLanguageTeacher = freezed,Object? isAthlete = freezed,Object? isEsports = freezed,Object? eduLevel = freezed,Object? studyField = freezed,Object? admitted = freezed,Object? programStart = freezed,Object? proofFunds = freezed,Object? isLanguageCourse = freezed,Object? fulltimeGerman = freezed,Object? isAusbildung = freezed,Object? isNursing = freezed,Object? internshipRelated = freezed,Object? internshipType = freezed,Object? hasHostAgreement = freezed,Object? researchFunded = freezed,Object? hasFamilyInGermany = freezed,Object? personalRoute = freezed,Object? hasHostContract = freezed,Object? isStartup = freezed,Object? businessSector = freezed,Object? hasFunding = freezed,Object? applyLocation = freezed,Object? currentResidence = freezed,Object? hasInsurance = freezed,Object? hasAccommodation = freezed,}) {
  return _then(_self.copyWith(
purpose: freezed == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,hasPermit: freezed == hasPermit ? _self.hasPermit : hasPermit // ignore: cast_nullable_to_non_nullable
as bool?,hasFamily: freezed == hasFamily ? _self.hasFamily : hasFamily // ignore: cast_nullable_to_non_nullable
as bool?,germanLevel: freezed == germanLevel ? _self.germanLevel : germanLevel // ignore: cast_nullable_to_non_nullable
as String?,englishLevel: freezed == englishLevel ? _self.englishLevel : englishLevel // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,hasJobOffer: freezed == hasJobOffer ? _self.hasJobOffer : hasJobOffer // ignore: cast_nullable_to_non_nullable
as bool?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,hasDegree: freezed == hasDegree ? _self.hasDegree : hasDegree // ignore: cast_nullable_to_non_nullable
as bool?,degreeField: freezed == degreeField ? _self.degreeField : degreeField // ignore: cast_nullable_to_non_nullable
as String?,degreeOrigin: freezed == degreeOrigin ? _self.degreeOrigin : degreeOrigin // ignore: cast_nullable_to_non_nullable
as String?,hasVocational: freezed == hasVocational ? _self.hasVocational : hasVocational // ignore: cast_nullable_to_non_nullable
as bool?,salary: freezed == salary ? _self.salary : salary // ignore: cast_nullable_to_non_nullable
as int?,employmentStatus: freezed == employmentStatus ? _self.employmentStatus : employmentStatus // ignore: cast_nullable_to_non_nullable
as String?,isSelfEmployed: freezed == isSelfEmployed ? _self.isSelfEmployed : isSelfEmployed // ignore: cast_nullable_to_non_nullable
as bool?,hasAnerkennung: freezed == hasAnerkennung ? _self.hasAnerkennung : hasAnerkennung // ignore: cast_nullable_to_non_nullable
as bool?,isItField: freezed == isItField ? _self.isItField : isItField // ignore: cast_nullable_to_non_nullable
as bool?,itExperience: freezed == itExperience ? _self.itExperience : itExperience // ignore: cast_nullable_to_non_nullable
as bool?,hasLicense: freezed == hasLicense ? _self.hasLicense : hasLicense // ignore: cast_nullable_to_non_nullable
as bool?,drivingYears: freezed == drivingYears ? _self.drivingYears : drivingYears // ignore: cast_nullable_to_non_nullable
as int?,hasPerformance: freezed == hasPerformance ? _self.hasPerformance : hasPerformance // ignore: cast_nullable_to_non_nullable
as bool?,performanceCount: freezed == performanceCount ? _self.performanceCount : performanceCount // ignore: cast_nullable_to_non_nullable
as int?,isLanguageTeacher: freezed == isLanguageTeacher ? _self.isLanguageTeacher : isLanguageTeacher // ignore: cast_nullable_to_non_nullable
as bool?,isAthlete: freezed == isAthlete ? _self.isAthlete : isAthlete // ignore: cast_nullable_to_non_nullable
as bool?,isEsports: freezed == isEsports ? _self.isEsports : isEsports // ignore: cast_nullable_to_non_nullable
as bool?,eduLevel: freezed == eduLevel ? _self.eduLevel : eduLevel // ignore: cast_nullable_to_non_nullable
as String?,studyField: freezed == studyField ? _self.studyField : studyField // ignore: cast_nullable_to_non_nullable
as String?,admitted: freezed == admitted ? _self.admitted : admitted // ignore: cast_nullable_to_non_nullable
as bool?,programStart: freezed == programStart ? _self.programStart : programStart // ignore: cast_nullable_to_non_nullable
as DateTime?,proofFunds: freezed == proofFunds ? _self.proofFunds : proofFunds // ignore: cast_nullable_to_non_nullable
as bool?,isLanguageCourse: freezed == isLanguageCourse ? _self.isLanguageCourse : isLanguageCourse // ignore: cast_nullable_to_non_nullable
as bool?,fulltimeGerman: freezed == fulltimeGerman ? _self.fulltimeGerman : fulltimeGerman // ignore: cast_nullable_to_non_nullable
as bool?,isAusbildung: freezed == isAusbildung ? _self.isAusbildung : isAusbildung // ignore: cast_nullable_to_non_nullable
as bool?,isNursing: freezed == isNursing ? _self.isNursing : isNursing // ignore: cast_nullable_to_non_nullable
as bool?,internshipRelated: freezed == internshipRelated ? _self.internshipRelated : internshipRelated // ignore: cast_nullable_to_non_nullable
as bool?,internshipType: freezed == internshipType ? _self.internshipType : internshipType // ignore: cast_nullable_to_non_nullable
as bool?,hasHostAgreement: freezed == hasHostAgreement ? _self.hasHostAgreement : hasHostAgreement // ignore: cast_nullable_to_non_nullable
as bool?,researchFunded: freezed == researchFunded ? _self.researchFunded : researchFunded // ignore: cast_nullable_to_non_nullable
as bool?,hasFamilyInGermany: freezed == hasFamilyInGermany ? _self.hasFamilyInGermany : hasFamilyInGermany // ignore: cast_nullable_to_non_nullable
as bool?,personalRoute: freezed == personalRoute ? _self.personalRoute : personalRoute // ignore: cast_nullable_to_non_nullable
as String?,hasHostContract: freezed == hasHostContract ? _self.hasHostContract : hasHostContract // ignore: cast_nullable_to_non_nullable
as bool?,isStartup: freezed == isStartup ? _self.isStartup : isStartup // ignore: cast_nullable_to_non_nullable
as bool?,businessSector: freezed == businessSector ? _self.businessSector : businessSector // ignore: cast_nullable_to_non_nullable
as String?,hasFunding: freezed == hasFunding ? _self.hasFunding : hasFunding // ignore: cast_nullable_to_non_nullable
as bool?,applyLocation: freezed == applyLocation ? _self.applyLocation : applyLocation // ignore: cast_nullable_to_non_nullable
as String?,currentResidence: freezed == currentResidence ? _self.currentResidence : currentResidence // ignore: cast_nullable_to_non_nullable
as String?,hasInsurance: freezed == hasInsurance ? _self.hasInsurance : hasInsurance // ignore: cast_nullable_to_non_nullable
as bool?,hasAccommodation: freezed == hasAccommodation ? _self.hasAccommodation : hasAccommodation // ignore: cast_nullable_to_non_nullable
as bool?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? purpose,  String? nationality,  bool? hasPermit,  bool? hasFamily,  String? germanLevel,  String? englishLevel, @DateTimeConverter()  DateTime? birthday,  int? age,  bool? hasJobOffer,  String? profession,  int? experienceYears,  bool? hasDegree,  String? degreeField,  String? degreeOrigin,  bool? hasVocational,  int? salary,  String? employmentStatus,  bool? isSelfEmployed,  bool? hasAnerkennung,  bool? isItField,  bool? itExperience,  bool? hasLicense,  int? drivingYears,  bool? hasPerformance,  int? performanceCount,  bool? isLanguageTeacher,  bool? isAthlete,  bool? isEsports,  String? eduLevel,  String? studyField,  bool? admitted, @DateTimeConverter()  DateTime? programStart,  bool? proofFunds,  bool? isLanguageCourse,  bool? fulltimeGerman,  bool? isAusbildung,  bool? isNursing,  bool? internshipRelated,  bool? internshipType,  bool? hasHostAgreement,  bool? researchFunded,  bool? hasFamilyInGermany,  String? personalRoute,  bool? hasHostContract,  bool? isStartup,  String? businessSector,  bool? hasFunding,  String? applyLocation,  String? currentResidence,  bool? hasInsurance,  bool? hasAccommodation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisaQuestionnaire() when $default != null:
return $default(_that.purpose,_that.nationality,_that.hasPermit,_that.hasFamily,_that.germanLevel,_that.englishLevel,_that.birthday,_that.age,_that.hasJobOffer,_that.profession,_that.experienceYears,_that.hasDegree,_that.degreeField,_that.degreeOrigin,_that.hasVocational,_that.salary,_that.employmentStatus,_that.isSelfEmployed,_that.hasAnerkennung,_that.isItField,_that.itExperience,_that.hasLicense,_that.drivingYears,_that.hasPerformance,_that.performanceCount,_that.isLanguageTeacher,_that.isAthlete,_that.isEsports,_that.eduLevel,_that.studyField,_that.admitted,_that.programStart,_that.proofFunds,_that.isLanguageCourse,_that.fulltimeGerman,_that.isAusbildung,_that.isNursing,_that.internshipRelated,_that.internshipType,_that.hasHostAgreement,_that.researchFunded,_that.hasFamilyInGermany,_that.personalRoute,_that.hasHostContract,_that.isStartup,_that.businessSector,_that.hasFunding,_that.applyLocation,_that.currentResidence,_that.hasInsurance,_that.hasAccommodation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? purpose,  String? nationality,  bool? hasPermit,  bool? hasFamily,  String? germanLevel,  String? englishLevel, @DateTimeConverter()  DateTime? birthday,  int? age,  bool? hasJobOffer,  String? profession,  int? experienceYears,  bool? hasDegree,  String? degreeField,  String? degreeOrigin,  bool? hasVocational,  int? salary,  String? employmentStatus,  bool? isSelfEmployed,  bool? hasAnerkennung,  bool? isItField,  bool? itExperience,  bool? hasLicense,  int? drivingYears,  bool? hasPerformance,  int? performanceCount,  bool? isLanguageTeacher,  bool? isAthlete,  bool? isEsports,  String? eduLevel,  String? studyField,  bool? admitted, @DateTimeConverter()  DateTime? programStart,  bool? proofFunds,  bool? isLanguageCourse,  bool? fulltimeGerman,  bool? isAusbildung,  bool? isNursing,  bool? internshipRelated,  bool? internshipType,  bool? hasHostAgreement,  bool? researchFunded,  bool? hasFamilyInGermany,  String? personalRoute,  bool? hasHostContract,  bool? isStartup,  String? businessSector,  bool? hasFunding,  String? applyLocation,  String? currentResidence,  bool? hasInsurance,  bool? hasAccommodation)  $default,) {final _that = this;
switch (_that) {
case _VisaQuestionnaire():
return $default(_that.purpose,_that.nationality,_that.hasPermit,_that.hasFamily,_that.germanLevel,_that.englishLevel,_that.birthday,_that.age,_that.hasJobOffer,_that.profession,_that.experienceYears,_that.hasDegree,_that.degreeField,_that.degreeOrigin,_that.hasVocational,_that.salary,_that.employmentStatus,_that.isSelfEmployed,_that.hasAnerkennung,_that.isItField,_that.itExperience,_that.hasLicense,_that.drivingYears,_that.hasPerformance,_that.performanceCount,_that.isLanguageTeacher,_that.isAthlete,_that.isEsports,_that.eduLevel,_that.studyField,_that.admitted,_that.programStart,_that.proofFunds,_that.isLanguageCourse,_that.fulltimeGerman,_that.isAusbildung,_that.isNursing,_that.internshipRelated,_that.internshipType,_that.hasHostAgreement,_that.researchFunded,_that.hasFamilyInGermany,_that.personalRoute,_that.hasHostContract,_that.isStartup,_that.businessSector,_that.hasFunding,_that.applyLocation,_that.currentResidence,_that.hasInsurance,_that.hasAccommodation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? purpose,  String? nationality,  bool? hasPermit,  bool? hasFamily,  String? germanLevel,  String? englishLevel, @DateTimeConverter()  DateTime? birthday,  int? age,  bool? hasJobOffer,  String? profession,  int? experienceYears,  bool? hasDegree,  String? degreeField,  String? degreeOrigin,  bool? hasVocational,  int? salary,  String? employmentStatus,  bool? isSelfEmployed,  bool? hasAnerkennung,  bool? isItField,  bool? itExperience,  bool? hasLicense,  int? drivingYears,  bool? hasPerformance,  int? performanceCount,  bool? isLanguageTeacher,  bool? isAthlete,  bool? isEsports,  String? eduLevel,  String? studyField,  bool? admitted, @DateTimeConverter()  DateTime? programStart,  bool? proofFunds,  bool? isLanguageCourse,  bool? fulltimeGerman,  bool? isAusbildung,  bool? isNursing,  bool? internshipRelated,  bool? internshipType,  bool? hasHostAgreement,  bool? researchFunded,  bool? hasFamilyInGermany,  String? personalRoute,  bool? hasHostContract,  bool? isStartup,  String? businessSector,  bool? hasFunding,  String? applyLocation,  String? currentResidence,  bool? hasInsurance,  bool? hasAccommodation)?  $default,) {final _that = this;
switch (_that) {
case _VisaQuestionnaire() when $default != null:
return $default(_that.purpose,_that.nationality,_that.hasPermit,_that.hasFamily,_that.germanLevel,_that.englishLevel,_that.birthday,_that.age,_that.hasJobOffer,_that.profession,_that.experienceYears,_that.hasDegree,_that.degreeField,_that.degreeOrigin,_that.hasVocational,_that.salary,_that.employmentStatus,_that.isSelfEmployed,_that.hasAnerkennung,_that.isItField,_that.itExperience,_that.hasLicense,_that.drivingYears,_that.hasPerformance,_that.performanceCount,_that.isLanguageTeacher,_that.isAthlete,_that.isEsports,_that.eduLevel,_that.studyField,_that.admitted,_that.programStart,_that.proofFunds,_that.isLanguageCourse,_that.fulltimeGerman,_that.isAusbildung,_that.isNursing,_that.internshipRelated,_that.internshipType,_that.hasHostAgreement,_that.researchFunded,_that.hasFamilyInGermany,_that.personalRoute,_that.hasHostContract,_that.isStartup,_that.businessSector,_that.hasFunding,_that.applyLocation,_that.currentResidence,_that.hasInsurance,_that.hasAccommodation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisaQuestionnaire implements VisaQuestionnaire {
  const _VisaQuestionnaire({this.purpose, this.nationality, this.hasPermit, this.hasFamily, this.germanLevel, this.englishLevel, @DateTimeConverter() this.birthday, this.age, this.hasJobOffer, this.profession, this.experienceYears, this.hasDegree, this.degreeField, this.degreeOrigin, this.hasVocational, this.salary, this.employmentStatus, this.isSelfEmployed, this.hasAnerkennung, this.isItField, this.itExperience, this.hasLicense, this.drivingYears, this.hasPerformance, this.performanceCount, this.isLanguageTeacher, this.isAthlete, this.isEsports, this.eduLevel, this.studyField, this.admitted, @DateTimeConverter() this.programStart, this.proofFunds, this.isLanguageCourse, this.fulltimeGerman, this.isAusbildung, this.isNursing, this.internshipRelated, this.internshipType, this.hasHostAgreement, this.researchFunded, this.hasFamilyInGermany, this.personalRoute, this.hasHostContract, this.isStartup, this.businessSector, this.hasFunding, this.applyLocation, this.currentResidence, this.hasInsurance, this.hasAccommodation});
  factory _VisaQuestionnaire.fromJson(Map<String, dynamic> json) => _$VisaQuestionnaireFromJson(json);

// Universal
@override final  String? purpose;
@override final  String? nationality;
@override final  bool? hasPermit;
@override final  bool? hasFamily;
@override final  String? germanLevel;
@override final  String? englishLevel;
@override@DateTimeConverter() final  DateTime? birthday;
@override final  int? age;
// Work: General
@override final  bool? hasJobOffer;
@override final  String? profession;
@override final  int? experienceYears;
@override final  bool? hasDegree;
@override final  String? degreeField;
@override final  String? degreeOrigin;
@override final  bool? hasVocational;
@override final  int? salary;
@override final  String? employmentStatus;
@override final  bool? isSelfEmployed;
@override final  bool? hasAnerkennung;
// Work: IT
@override final  bool? isItField;
@override final  bool? itExperience;
// Work: Driver
@override final  bool? hasLicense;
@override final  int? drivingYears;
// Work: Artist
@override final  bool? hasPerformance;
@override final  int? performanceCount;
// Work: Teacher
@override final  bool? isLanguageTeacher;
// Work: Sports
@override final  bool? isAthlete;
// Work: Esports
@override final  bool? isEsports;
// Education: General
@override final  String? eduLevel;
@override final  String? studyField;
@override final  bool? admitted;
@override@DateTimeConverter() final  DateTime? programStart;
@override final  bool? proofFunds;
// Education: Language Course
@override final  bool? isLanguageCourse;
@override final  bool? fulltimeGerman;
// Education: Ausbildung
@override final  bool? isAusbildung;
// Education: Nursing
@override final  bool? isNursing;
// Education: Internship
@override final  bool? internshipRelated;
@override final  bool? internshipType;
// Research: General
@override final  bool? hasHostAgreement;
@override final  bool? researchFunded;
// Personal: General
@override final  bool? hasFamilyInGermany;
@override final  String? personalRoute;
@override final  bool? hasHostContract;
// Startup: General
@override final  bool? isStartup;
@override final  String? businessSector;
@override final  bool? hasFunding;
// Meta
@override final  String? applyLocation;
@override final  String? currentResidence;
@override final  bool? hasInsurance;
@override final  bool? hasAccommodation;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisaQuestionnaire&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.hasPermit, hasPermit) || other.hasPermit == hasPermit)&&(identical(other.hasFamily, hasFamily) || other.hasFamily == hasFamily)&&(identical(other.germanLevel, germanLevel) || other.germanLevel == germanLevel)&&(identical(other.englishLevel, englishLevel) || other.englishLevel == englishLevel)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.age, age) || other.age == age)&&(identical(other.hasJobOffer, hasJobOffer) || other.hasJobOffer == hasJobOffer)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.hasDegree, hasDegree) || other.hasDegree == hasDegree)&&(identical(other.degreeField, degreeField) || other.degreeField == degreeField)&&(identical(other.degreeOrigin, degreeOrigin) || other.degreeOrigin == degreeOrigin)&&(identical(other.hasVocational, hasVocational) || other.hasVocational == hasVocational)&&(identical(other.salary, salary) || other.salary == salary)&&(identical(other.employmentStatus, employmentStatus) || other.employmentStatus == employmentStatus)&&(identical(other.isSelfEmployed, isSelfEmployed) || other.isSelfEmployed == isSelfEmployed)&&(identical(other.hasAnerkennung, hasAnerkennung) || other.hasAnerkennung == hasAnerkennung)&&(identical(other.isItField, isItField) || other.isItField == isItField)&&(identical(other.itExperience, itExperience) || other.itExperience == itExperience)&&(identical(other.hasLicense, hasLicense) || other.hasLicense == hasLicense)&&(identical(other.drivingYears, drivingYears) || other.drivingYears == drivingYears)&&(identical(other.hasPerformance, hasPerformance) || other.hasPerformance == hasPerformance)&&(identical(other.performanceCount, performanceCount) || other.performanceCount == performanceCount)&&(identical(other.isLanguageTeacher, isLanguageTeacher) || other.isLanguageTeacher == isLanguageTeacher)&&(identical(other.isAthlete, isAthlete) || other.isAthlete == isAthlete)&&(identical(other.isEsports, isEsports) || other.isEsports == isEsports)&&(identical(other.eduLevel, eduLevel) || other.eduLevel == eduLevel)&&(identical(other.studyField, studyField) || other.studyField == studyField)&&(identical(other.admitted, admitted) || other.admitted == admitted)&&(identical(other.programStart, programStart) || other.programStart == programStart)&&(identical(other.proofFunds, proofFunds) || other.proofFunds == proofFunds)&&(identical(other.isLanguageCourse, isLanguageCourse) || other.isLanguageCourse == isLanguageCourse)&&(identical(other.fulltimeGerman, fulltimeGerman) || other.fulltimeGerman == fulltimeGerman)&&(identical(other.isAusbildung, isAusbildung) || other.isAusbildung == isAusbildung)&&(identical(other.isNursing, isNursing) || other.isNursing == isNursing)&&(identical(other.internshipRelated, internshipRelated) || other.internshipRelated == internshipRelated)&&(identical(other.internshipType, internshipType) || other.internshipType == internshipType)&&(identical(other.hasHostAgreement, hasHostAgreement) || other.hasHostAgreement == hasHostAgreement)&&(identical(other.researchFunded, researchFunded) || other.researchFunded == researchFunded)&&(identical(other.hasFamilyInGermany, hasFamilyInGermany) || other.hasFamilyInGermany == hasFamilyInGermany)&&(identical(other.personalRoute, personalRoute) || other.personalRoute == personalRoute)&&(identical(other.hasHostContract, hasHostContract) || other.hasHostContract == hasHostContract)&&(identical(other.isStartup, isStartup) || other.isStartup == isStartup)&&(identical(other.businessSector, businessSector) || other.businessSector == businessSector)&&(identical(other.hasFunding, hasFunding) || other.hasFunding == hasFunding)&&(identical(other.applyLocation, applyLocation) || other.applyLocation == applyLocation)&&(identical(other.currentResidence, currentResidence) || other.currentResidence == currentResidence)&&(identical(other.hasInsurance, hasInsurance) || other.hasInsurance == hasInsurance)&&(identical(other.hasAccommodation, hasAccommodation) || other.hasAccommodation == hasAccommodation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,purpose,nationality,hasPermit,hasFamily,germanLevel,englishLevel,birthday,age,hasJobOffer,profession,experienceYears,hasDegree,degreeField,degreeOrigin,hasVocational,salary,employmentStatus,isSelfEmployed,hasAnerkennung,isItField,itExperience,hasLicense,drivingYears,hasPerformance,performanceCount,isLanguageTeacher,isAthlete,isEsports,eduLevel,studyField,admitted,programStart,proofFunds,isLanguageCourse,fulltimeGerman,isAusbildung,isNursing,internshipRelated,internshipType,hasHostAgreement,researchFunded,hasFamilyInGermany,personalRoute,hasHostContract,isStartup,businessSector,hasFunding,applyLocation,currentResidence,hasInsurance,hasAccommodation]);

@override
String toString() {
  return 'VisaQuestionnaire(purpose: $purpose, nationality: $nationality, hasPermit: $hasPermit, hasFamily: $hasFamily, germanLevel: $germanLevel, englishLevel: $englishLevel, birthday: $birthday, age: $age, hasJobOffer: $hasJobOffer, profession: $profession, experienceYears: $experienceYears, hasDegree: $hasDegree, degreeField: $degreeField, degreeOrigin: $degreeOrigin, hasVocational: $hasVocational, salary: $salary, employmentStatus: $employmentStatus, isSelfEmployed: $isSelfEmployed, hasAnerkennung: $hasAnerkennung, isItField: $isItField, itExperience: $itExperience, hasLicense: $hasLicense, drivingYears: $drivingYears, hasPerformance: $hasPerformance, performanceCount: $performanceCount, isLanguageTeacher: $isLanguageTeacher, isAthlete: $isAthlete, isEsports: $isEsports, eduLevel: $eduLevel, studyField: $studyField, admitted: $admitted, programStart: $programStart, proofFunds: $proofFunds, isLanguageCourse: $isLanguageCourse, fulltimeGerman: $fulltimeGerman, isAusbildung: $isAusbildung, isNursing: $isNursing, internshipRelated: $internshipRelated, internshipType: $internshipType, hasHostAgreement: $hasHostAgreement, researchFunded: $researchFunded, hasFamilyInGermany: $hasFamilyInGermany, personalRoute: $personalRoute, hasHostContract: $hasHostContract, isStartup: $isStartup, businessSector: $businessSector, hasFunding: $hasFunding, applyLocation: $applyLocation, currentResidence: $currentResidence, hasInsurance: $hasInsurance, hasAccommodation: $hasAccommodation)';
}


}

/// @nodoc
abstract mixin class _$VisaQuestionnaireCopyWith<$Res> implements $VisaQuestionnaireCopyWith<$Res> {
  factory _$VisaQuestionnaireCopyWith(_VisaQuestionnaire value, $Res Function(_VisaQuestionnaire) _then) = __$VisaQuestionnaireCopyWithImpl;
@override @useResult
$Res call({
 String? purpose, String? nationality, bool? hasPermit, bool? hasFamily, String? germanLevel, String? englishLevel,@DateTimeConverter() DateTime? birthday, int? age, bool? hasJobOffer, String? profession, int? experienceYears, bool? hasDegree, String? degreeField, String? degreeOrigin, bool? hasVocational, int? salary, String? employmentStatus, bool? isSelfEmployed, bool? hasAnerkennung, bool? isItField, bool? itExperience, bool? hasLicense, int? drivingYears, bool? hasPerformance, int? performanceCount, bool? isLanguageTeacher, bool? isAthlete, bool? isEsports, String? eduLevel, String? studyField, bool? admitted,@DateTimeConverter() DateTime? programStart, bool? proofFunds, bool? isLanguageCourse, bool? fulltimeGerman, bool? isAusbildung, bool? isNursing, bool? internshipRelated, bool? internshipType, bool? hasHostAgreement, bool? researchFunded, bool? hasFamilyInGermany, String? personalRoute, bool? hasHostContract, bool? isStartup, String? businessSector, bool? hasFunding, String? applyLocation, String? currentResidence, bool? hasInsurance, bool? hasAccommodation
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
@override @pragma('vm:prefer-inline') $Res call({Object? purpose = freezed,Object? nationality = freezed,Object? hasPermit = freezed,Object? hasFamily = freezed,Object? germanLevel = freezed,Object? englishLevel = freezed,Object? birthday = freezed,Object? age = freezed,Object? hasJobOffer = freezed,Object? profession = freezed,Object? experienceYears = freezed,Object? hasDegree = freezed,Object? degreeField = freezed,Object? degreeOrigin = freezed,Object? hasVocational = freezed,Object? salary = freezed,Object? employmentStatus = freezed,Object? isSelfEmployed = freezed,Object? hasAnerkennung = freezed,Object? isItField = freezed,Object? itExperience = freezed,Object? hasLicense = freezed,Object? drivingYears = freezed,Object? hasPerformance = freezed,Object? performanceCount = freezed,Object? isLanguageTeacher = freezed,Object? isAthlete = freezed,Object? isEsports = freezed,Object? eduLevel = freezed,Object? studyField = freezed,Object? admitted = freezed,Object? programStart = freezed,Object? proofFunds = freezed,Object? isLanguageCourse = freezed,Object? fulltimeGerman = freezed,Object? isAusbildung = freezed,Object? isNursing = freezed,Object? internshipRelated = freezed,Object? internshipType = freezed,Object? hasHostAgreement = freezed,Object? researchFunded = freezed,Object? hasFamilyInGermany = freezed,Object? personalRoute = freezed,Object? hasHostContract = freezed,Object? isStartup = freezed,Object? businessSector = freezed,Object? hasFunding = freezed,Object? applyLocation = freezed,Object? currentResidence = freezed,Object? hasInsurance = freezed,Object? hasAccommodation = freezed,}) {
  return _then(_VisaQuestionnaire(
purpose: freezed == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,hasPermit: freezed == hasPermit ? _self.hasPermit : hasPermit // ignore: cast_nullable_to_non_nullable
as bool?,hasFamily: freezed == hasFamily ? _self.hasFamily : hasFamily // ignore: cast_nullable_to_non_nullable
as bool?,germanLevel: freezed == germanLevel ? _self.germanLevel : germanLevel // ignore: cast_nullable_to_non_nullable
as String?,englishLevel: freezed == englishLevel ? _self.englishLevel : englishLevel // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,hasJobOffer: freezed == hasJobOffer ? _self.hasJobOffer : hasJobOffer // ignore: cast_nullable_to_non_nullable
as bool?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,hasDegree: freezed == hasDegree ? _self.hasDegree : hasDegree // ignore: cast_nullable_to_non_nullable
as bool?,degreeField: freezed == degreeField ? _self.degreeField : degreeField // ignore: cast_nullable_to_non_nullable
as String?,degreeOrigin: freezed == degreeOrigin ? _self.degreeOrigin : degreeOrigin // ignore: cast_nullable_to_non_nullable
as String?,hasVocational: freezed == hasVocational ? _self.hasVocational : hasVocational // ignore: cast_nullable_to_non_nullable
as bool?,salary: freezed == salary ? _self.salary : salary // ignore: cast_nullable_to_non_nullable
as int?,employmentStatus: freezed == employmentStatus ? _self.employmentStatus : employmentStatus // ignore: cast_nullable_to_non_nullable
as String?,isSelfEmployed: freezed == isSelfEmployed ? _self.isSelfEmployed : isSelfEmployed // ignore: cast_nullable_to_non_nullable
as bool?,hasAnerkennung: freezed == hasAnerkennung ? _self.hasAnerkennung : hasAnerkennung // ignore: cast_nullable_to_non_nullable
as bool?,isItField: freezed == isItField ? _self.isItField : isItField // ignore: cast_nullable_to_non_nullable
as bool?,itExperience: freezed == itExperience ? _self.itExperience : itExperience // ignore: cast_nullable_to_non_nullable
as bool?,hasLicense: freezed == hasLicense ? _self.hasLicense : hasLicense // ignore: cast_nullable_to_non_nullable
as bool?,drivingYears: freezed == drivingYears ? _self.drivingYears : drivingYears // ignore: cast_nullable_to_non_nullable
as int?,hasPerformance: freezed == hasPerformance ? _self.hasPerformance : hasPerformance // ignore: cast_nullable_to_non_nullable
as bool?,performanceCount: freezed == performanceCount ? _self.performanceCount : performanceCount // ignore: cast_nullable_to_non_nullable
as int?,isLanguageTeacher: freezed == isLanguageTeacher ? _self.isLanguageTeacher : isLanguageTeacher // ignore: cast_nullable_to_non_nullable
as bool?,isAthlete: freezed == isAthlete ? _self.isAthlete : isAthlete // ignore: cast_nullable_to_non_nullable
as bool?,isEsports: freezed == isEsports ? _self.isEsports : isEsports // ignore: cast_nullable_to_non_nullable
as bool?,eduLevel: freezed == eduLevel ? _self.eduLevel : eduLevel // ignore: cast_nullable_to_non_nullable
as String?,studyField: freezed == studyField ? _self.studyField : studyField // ignore: cast_nullable_to_non_nullable
as String?,admitted: freezed == admitted ? _self.admitted : admitted // ignore: cast_nullable_to_non_nullable
as bool?,programStart: freezed == programStart ? _self.programStart : programStart // ignore: cast_nullable_to_non_nullable
as DateTime?,proofFunds: freezed == proofFunds ? _self.proofFunds : proofFunds // ignore: cast_nullable_to_non_nullable
as bool?,isLanguageCourse: freezed == isLanguageCourse ? _self.isLanguageCourse : isLanguageCourse // ignore: cast_nullable_to_non_nullable
as bool?,fulltimeGerman: freezed == fulltimeGerman ? _self.fulltimeGerman : fulltimeGerman // ignore: cast_nullable_to_non_nullable
as bool?,isAusbildung: freezed == isAusbildung ? _self.isAusbildung : isAusbildung // ignore: cast_nullable_to_non_nullable
as bool?,isNursing: freezed == isNursing ? _self.isNursing : isNursing // ignore: cast_nullable_to_non_nullable
as bool?,internshipRelated: freezed == internshipRelated ? _self.internshipRelated : internshipRelated // ignore: cast_nullable_to_non_nullable
as bool?,internshipType: freezed == internshipType ? _self.internshipType : internshipType // ignore: cast_nullable_to_non_nullable
as bool?,hasHostAgreement: freezed == hasHostAgreement ? _self.hasHostAgreement : hasHostAgreement // ignore: cast_nullable_to_non_nullable
as bool?,researchFunded: freezed == researchFunded ? _self.researchFunded : researchFunded // ignore: cast_nullable_to_non_nullable
as bool?,hasFamilyInGermany: freezed == hasFamilyInGermany ? _self.hasFamilyInGermany : hasFamilyInGermany // ignore: cast_nullable_to_non_nullable
as bool?,personalRoute: freezed == personalRoute ? _self.personalRoute : personalRoute // ignore: cast_nullable_to_non_nullable
as String?,hasHostContract: freezed == hasHostContract ? _self.hasHostContract : hasHostContract // ignore: cast_nullable_to_non_nullable
as bool?,isStartup: freezed == isStartup ? _self.isStartup : isStartup // ignore: cast_nullable_to_non_nullable
as bool?,businessSector: freezed == businessSector ? _self.businessSector : businessSector // ignore: cast_nullable_to_non_nullable
as String?,hasFunding: freezed == hasFunding ? _self.hasFunding : hasFunding // ignore: cast_nullable_to_non_nullable
as bool?,applyLocation: freezed == applyLocation ? _self.applyLocation : applyLocation // ignore: cast_nullable_to_non_nullable
as String?,currentResidence: freezed == currentResidence ? _self.currentResidence : currentResidence // ignore: cast_nullable_to_non_nullable
as String?,hasInsurance: freezed == hasInsurance ? _self.hasInsurance : hasInsurance // ignore: cast_nullable_to_non_nullable
as bool?,hasAccommodation: freezed == hasAccommodation ? _self.hasAccommodation : hasAccommodation // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
