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

export interface VisaQuestionnaireInput {
  purpose?: string;
  nationality?: string;
  hasPermit?: boolean;
  hasFamily?: boolean;
  germanLevel?: string;
  englishLevel?: string;
  birthday?: string;
  age?: number;
  hasJobOffer?: boolean;
  profession?: string;
  experienceYears?: number;
  hasDegree?: boolean;
  degreeField?: string;
  degreeOrigin?: string;
  hasVocational?: boolean;
  salary?: number;
  employmentStatus?: string;
  isSelfEmployed?: boolean;
  hasAnerkennung?: boolean;
  isItField?: boolean;
  itExperience?: boolean;
  hasLicense?: boolean;
  drivingYears?: number;
  hasPerformance?: boolean;
  performanceCount?: number;
  isLanguageTeacher?: boolean;
  isAthlete?: boolean;
  isEsports?: boolean;
  eduLevel?: string;
  studyField?: string;
  admitted?: boolean;
  programStart?: string;
  proofFunds?: boolean;
  isLanguageCourse?: boolean;
  fulltimeGerman?: boolean;
  isAusbildung?: boolean;
  isNursing?: boolean;
  internshipRelated?: boolean;
  internshipType?: boolean;
  hasHostAgreement?: boolean;
  researchFunded?: boolean;
  hasFamilyInGermany?: boolean;
  personalRoute?: string;
  hasHostContract?: boolean;
  isStartup?: boolean;
  businessSector?: string;
  hasFunding?: boolean;
  applyLocation?: string;
  currentResidence?: string;
  hasInsurance?: boolean;
  hasAccommodation?: boolean;
}


/**
 * VisaCandidate - result structure for each evaluated visa
 */

export interface VisaCandidate {
  code: string;           // e.g., "blue_card"
  name: string;           // e.g., "EU Blue Card"
  category: string;       // e.g., "work", "education", "research"
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
  reasons?: string[];     // Optional: for debugging/logging
}
