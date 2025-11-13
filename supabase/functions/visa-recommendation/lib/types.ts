// lib/types.ts - UPDATED to match new database schema

export interface VisaRecommendation {
  recommended: VisaOption | null;
  alternatives?: VisaOption[];
  notes?: string[];
}

export interface VisaOption {
  code: string;
  name: string;
  summary: string;
  requirements?: string[];
  notes?: string[];
}

/**
 * Complete input structure matching ALL database fields
 * Organized by category for clarity
 */
export interface VisaQuestionnaireInput {
  // ===== UNIVERSAL FIELDS =====
  purpose?: string;
  nationality?: string;
  currentLocation?: string; // NEW
  birthday?: string;
  age?: number;
  germanLevel?: string;
  englishLevel?: string;

  // ===== WORK FIELDS =====
  // General
  profession?: string;
  employmentStatus?: string; // NEW: Employed, Self-Employed, Unemployed, Student
  experienceYears?: number;
  hasJobOffer?: boolean;

  // Job offer details
  employerName?: string;
  jobStartDate?: string;
  salary?: number;
  workLocation?: string;
  companySize?: string; // NEW: Startup, Medium, Large

  // Remote work
  remoteWork?: boolean; // NEW

  // Degree & recognition
  hasDegree?: boolean;
  degreeLevel?: string;
  degreeField?: string;
  universityNameWork?: string;
  universityCountry?: string;
  hasAnerkennung?: boolean;

  // Vocational
  hasVocational?: boolean;

  // Professional certifications
  hasProfessionalCertification?: boolean; // NEW

  // Job seeker specific
  jobSearchTimeline?: string; // NEW: Within 1 month, 1-3 months, etc.
  jobSeekerFunds?: boolean; // NEW

  // ===== IT FIELD SPECIFIC =====
  isItField?: boolean;
  itSpecialization?: string;
  programmingLanguages?: string;
  hasItCertifications?: boolean;
  itExperience?: boolean;

  // ===== ENGINEERING SPECIFIC =====
  isEngineer?: boolean;
  engineeringField?: string;
  professionalEngineer?: boolean;

  // ===== HEALTHCARE SPECIFIC =====
  isHealthcare?: boolean;
  healthcareProfession?: string;
  hasMedicalLicense?: boolean;
  germanMedicalExam?: boolean;

  // ===== EDUCATION FIELDS =====
  eduLevel?: string;

  // University
  universityNameEdu?: string;
  studyField?: string;
  previousEducationLevel?: string; // NEW: High School, Some University, Bachelor, Master, PhD
  admitted?: boolean;
  programStart?: string;
  studyLanguage?: string;
  studyMode?: string; // NEW: Full-time, Part-time
  needsStudienkolleg?: boolean; // NEW

  // Studienkolleg (NEW section)
  studienkollegName?: string;
  studienkollegCourse?: string; // T-Kurs, M-Kurs, W-Kurs, etc.

  // Language course
  languageSchoolName?: string;
  fulltimeGerman?: boolean;
  courseDurationWeeks?: number;
  targetGermanLevel?: string;
  isLanguageCourse?: boolean;

  // Ausbildung
  ausbildungField?: string;
  companyName?: string;
  ausbildungStart?: string;
  ausbildungDurationYears?: string;
  isAusbildung?: boolean;

  // PhD
  phdUniversity?: string;
  phdField?: string;
  hasPhDSupervisor?: boolean;
  phdFunding?: string;

  // Financial
  fundingSource?: string;
  proofFunds?: boolean;
  monthlyBudget?: number;
  hasScholarship?: boolean; // NEW
  scholarshipName?: string; // NEW
  blockedAccountAmount?: number; // NEW

  // ===== RESEARCH FIELDS =====
  hasHostAgreement?: boolean;
  institutionName?: string;
  researchField?: string;
  researchFunded?: boolean;
  researchDurationMonths?: number;
  researchPositionType?: string; // NEW: Postdoc, Visiting Researcher, etc.
  hasPublications?: boolean; // NEW

  // ===== FAMILY FIELDS =====
  hasFamilyInGermany?: boolean;
  familyMemberStatus?: string;
  relationship?: string;
  familyMemberIncome?: boolean;

  // Spouse/Partner specific
  marriageDate?: string;

  // Children (NEW section)
  hasChildren?: boolean;
  childrenCount?: number;
  childrenAges?: string; // Comma-separated ages

  // Relationship proof (NEW)
  relationshipProof?: boolean;
  sponsorResidenceYears?: string;

  // ===== PERSONAL/CULTURAL FIELDS =====
  personalRoute?: string;
  hasHostContract?: boolean;

  // Au Pair specific
  auPairAgeCheck?: boolean; // NEW: 18-26 check

  // Performance/Artist
  hasPerformance?: boolean;
  performanceCount?: number;

  // Working Holiday (NEW)
  eligibleWorkingHoliday?: boolean;

  // ===== TRAINING/INTERNSHIP FIELDS (NEW) =====
  trainingType?: string;
  trainingDurationMonths?: number;
  trainingCompany?: string;
  trainingCompensation?: boolean;

  internshipDurationMonths?: number;
  internshipCompany?: string;
  internshipPaid?: boolean;

  // Cultural exchange (NEW)
  culturalProgramName?: string;

  // ===== BUSINESS/ENTREPRENEUR FIELDS (NEW) =====
  businessType?: string;
  hasBusinessPlan?: boolean;
  businessInvestment?: number;
  hasBusinessClients?: boolean;
  businessSector?: string;
  hasFunding?: boolean;

  // ===== SPECIALIZED FIELDS =====
  isLanguageTeacher?: boolean;
  isAthlete?: boolean;
  isEsports?: boolean;
  isSelfEmployed?: boolean;
  isStartup?: boolean;

  // ===== LOGISTICS/META =====
  hasInsurance?: boolean;
  hasAccommodation?: boolean;
  applyLocation?: string;
  currentResidence?: string;

  // History
  previousVisa?: boolean;
  visaRefusalHistory?: boolean;

  // ===== LICENSE/PROFESSIONAL =====
  hasLicense?: boolean;
  drivingYears?: number;

  // ===== NURSING SPECIFIC =====
  isNursing?: boolean;

  // ===== INTERNSHIP RELATED =====
  internshipRelated?: boolean;
  internshipType?: boolean;

  // ===== LEGACY/COMPATIBILITY =====
  hasPermit?: boolean;
  hasFamily?: boolean;
  degreeOrigin?: string;
}

/**
 * VisaCandidate - result structure for each evaluated visa
 */
export interface VisaCandidate {
  code: string; // e.g., "blue_card"
  name: string; // e.g., "EU Blue Card"
  category: string; // e.g., "work", "education", "specialized", "personal"
  meta: {
    code: string;
    name: string;
    explanationTemplate: string;
    canApplyInCountry?: string[];
    basePriority?: number;
    criteria?: Record<string, number>;
    thresholds?: Record<string, number>;
  };
  score: number;
  matched: string[];
  missing: {
    key: string;
    severity: "critical" | "important" | "optional";
    detail?: string;
  }[];
  disqualify: boolean;
  context?: Record<string, any>;
  reasons?: string[]; // Optional: for debugging/logging
}

/**
 * Database question structure (for reference)
 */
export interface VisaQuestion {
  uid: string;
  fieldKey: string;
  question: string;
  questionType:
    | "text"
    | "number"
    | "boolean"
    | "select"
    | "autocomplete"
    | "date";
  category: string;
  subcategory?: string;
  dependsOnField?: string;
  dependsOnValue?: string;
  options?: string[];
  optionsSource?:
    | "countries"
    | "universities"
    | "degree_fields"
    | "occupations";
  required: boolean;
  validationRules?: Record<string, any>;
  helpText?: string;
  placeholder?: string;
  orderIndex: number;
  skipIfAnswered: boolean;
  autoSkipConditions?: Record<string, any>;
}

/**
 * Database question path structure (for reference)
 */
export interface VisaQuestionPath {
  id: string;
  fromField: string;
  answerValue?: string;
  conditionType?:
    | "equals"
    | "not_equals"
    | "contains"
    | "greater_than_or_equal"
    | "less_than_or_equal"
    | "greater_than"
    | "less_than"
    | "exists"
    | "age_under"
    | "age_over";
  conditionValue?: string;
  nextCategories?: string[];
  nextQuestionKeys?: string[];
  skipCategories?: string[];
  skipQuestionKeys?: string[];
  priority: number;
  description: string;
}
