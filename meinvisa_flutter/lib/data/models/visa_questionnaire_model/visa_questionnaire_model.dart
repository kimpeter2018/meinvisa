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
    bool? isDegreeRecognized,
    bool? workedInGermany,
    bool? contractOverOneYear,
    bool? hasAccompanyingFamily,

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
    bool? completedStudienkolleg,
    bool? intendParttimeWork,
    bool? hasBlockedAccount,

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
    String? institutionType,
    bool? receivesStipend,
    int? researchDurationMonths,

    // Personal: General
    bool? hasFamilyInGermany,
    String? personalRoute,
    bool? hasHostContract,
    bool? hasChildcareExperience,
    bool? livesWithHost,
    bool? hasRecognizedSponsor,

    // Startup: General
    bool? isStartup,
    String? businessSector,
    bool? hasFunding,

    // Meta
    String? applyLocation,
    String? currentResidence,
    bool? hasInsurance,
    bool? hasAccommodation,
    bool? hasGermanInsurance,
    bool? stayOver90Days,
    bool? isEuMobilityProgram,
  }) = _VisaQuestionnaire;

  factory VisaQuestionnaire.fromJson(Map<String, dynamic> json) =>
      _$VisaQuestionnaireFromJson(json);
}
