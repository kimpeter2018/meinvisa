import 'package:freezed_annotation/freezed_annotation.dart';

part 'visa_questionnaire_model.freezed.dart';
part 'visa_questionnaire_model.g.dart';

class DateTimeConverter implements JsonConverter<DateTime?, dynamic> {
  const DateTimeConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is DateTime) return json;
    if (json is String) return DateTime.parse(json);
    return null;
  }

  @override
  dynamic toJson(DateTime? object) {
    return object?.toIso8601String();
  }
}

@freezed
abstract class VisaQuestionnaire with _$VisaQuestionnaire {
  const factory VisaQuestionnaire({
    // Universal
    String? purpose,
    String? nationality,
    bool? hasPermit,
    bool? hasFamily,
    String? germanLevel,
    String? englishLevel,
    @DateTimeConverter() DateTime? birthday,
    int? age,

    // Work: General
    bool? hasJobOffer,
    String? profession,
    int? experienceYears,
    bool? hasDegree,
    String? degreeField,
    String? degreeOrigin,
    bool? hasVocational,
    int? salary,
    String? employmentStatus,
    bool? isSelfEmployed,
    bool? hasAnerkennung,

    // Work: IT
    bool? isItField,
    bool? itExperience,

    // Work: Driver
    bool? hasLicense,
    int? drivingYears,

    // Work: Artist
    bool? hasPerformance,
    int? performanceCount,

    // Work: Teacher
    bool? isLanguageTeacher,

    // Work: Sports
    bool? isAthlete,

    // Work: Esports
    bool? isEsports,

    // Education: General
    String? eduLevel,
    String? studyField,
    bool? admitted,
    @DateTimeConverter() DateTime? programStart,
    bool? proofFunds,

    // Education: Language Course
    bool? isLanguageCourse,
    bool? fulltimeGerman,

    // Education: Ausbildung
    bool? isAusbildung,

    // Education: Nursing
    bool? isNursing,

    // Education: Internship
    bool? internshipRelated,
    bool? internshipType,

    // Research: General
    bool? hasHostAgreement,
    bool? researchFunded,

    // Personal: General
    bool? hasFamilyInGermany,
    String? personalRoute,
    bool? hasHostContract,

    // Startup: General
    bool? isStartup,
    String? businessSector,
    bool? hasFunding,

    // Meta
    String? applyLocation,
    String? currentResidence,
    bool? hasInsurance,
    bool? hasAccommodation,
  }) = _VisaQuestionnaire;

  factory VisaQuestionnaire.fromJson(Map<String, dynamic> json) =>
      _$VisaQuestionnaireFromJson(json);
}
