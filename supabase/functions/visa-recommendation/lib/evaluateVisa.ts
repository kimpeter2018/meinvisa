// lib/evaluateVisa.ts - UPDATED main router

import { VisaQuestionnaireInput, VisaRecommendation } from "./types.ts";
import { evaluateWorkPath } from "./rules/work.ts";
import { evaluateEducationPath } from "./rules/education.ts";
import { evaluateSpecializedPath } from "./rules/specialized.ts";
import { evaluatePersonalPath } from "./rules/personal.ts";
import { evaluateTrainingPath } from "./rules/training.ts";
import { evaluateBusinessPath } from "./rules/business.ts";
import { calculateAge } from "./utils/matchHelpers.ts";

/**
 * Main router for visa evaluation - UPDATED for comprehensive coverage
 *
 * Routes user input to appropriate path evaluator based on purpose.
 * All path evaluators use the same scoring-based engine for consistency.
 *
 * Supported purposes:
 * - Work: Employment-based visas (Blue Card, Skilled Worker, IT Specialist, Job Seeker)
 * - Study/Education: Academic and vocational training (Student, Language, Ausbildung, PhD)
 * - Research: Academic research positions
 * - Specialized: Arts, culture, sports, freelance, special professions
 * - Personal/Family: Family reunion, au pair, volunteer, working holiday
 * - Training/Internship: Professional training and internships
 * - Business/Entrepreneur: Self-employment and startup visas
 */
export function evaluateVisa(
  input: VisaQuestionnaireInput,
): VisaRecommendation {
  const { purpose } = input;

  if (!purpose) {
    return {
      recommended: {
        code: "unspecified_purpose",
        name: "Insufficient Information",
        summary: "Please select your main purpose for coming to Germany.",
        notes: [],
      },
      notes: [
        "Common purposes: Work, Study, Research, Family/Personal, Training, Start a Business",
        "Your choice helps us recommend the most suitable visa type",
      ],
    };
  }

  // PRE-PROCESSING: Calculate age if birthday provided
  if (input.birthday && !input.age) {
    try {
      input.age = calculateAge(input.birthday);
    } catch (e) {
      console.warn("Failed to calculate age from birthday:", e);
    }
  }

  // PRE-PROCESSING: Validate critical impossible combinations
  const validationResult = validateInput(input);
  if (validationResult) {
    return validationResult;
  }

  // Add input as context for scoring and personalization
  const inputWithContext = {
    ...input,
    context: input,
  };

  // Route based on purpose
  const purposeLower = purpose.toLowerCase().trim();

  // ===== WORK-RELATED VISAS =====
  if (
    purposeLower === "work" || purposeLower === "employment" ||
    purposeLower === "job"
  ) {
    return evaluateWorkPath(inputWithContext);
  }

  // ===== EDUCATION-RELATED VISAS =====
  if (
    purposeLower === "study" ||
    purposeLower === "education" ||
    purposeLower === "student" ||
    purposeLower === "university" ||
    purposeLower === "college"
  ) {
    return evaluateEducationPath(inputWithContext);
  }

  // ===== RESEARCH VISAS =====
  if (
    purposeLower === "research" ||
    purposeLower === "postdoc" ||
    purposeLower === "academic"
  ) {
    return evaluateSpecializedPath(inputWithContext);
  }

  // ===== SPECIALIZED VISAS =====
  if (
    purposeLower === "culture" ||
    purposeLower === "arts" ||
    purposeLower === "artist" ||
    purposeLower === "performer" ||
    purposeLower === "sports" ||
    purposeLower === "athlete" ||
    purposeLower === "musician" ||
    purposeLower === "specialized" ||
    purposeLower === "freelance" ||
    purposeLower === "self-employed" ||
    purposeLower === "language teacher" ||
    purposeLower === "teacher"
  ) {
    return evaluateSpecializedPath(inputWithContext);
  }

  // ===== PERSONAL/FAMILY VISAS =====
  if (
    purposeLower === "personal" ||
    purposeLower === "family" ||
    purposeLower === "reunion" ||
    purposeLower === "family reunion" ||
    purposeLower === "au pair" ||
    purposeLower === "volunteer" ||
    purposeLower === "development" ||
    purposeLower === "cultural exchange" ||
    purposeLower === "working holiday"
  ) {
    return evaluatePersonalPath(inputWithContext);
  }

  // ===== TRAINING/INTERNSHIP VISAS (NEW) =====
  if (
    purposeLower === "training" ||
    purposeLower === "internship" ||
    purposeLower === "training/internship" ||
    purposeLower === "praktikum" ||
    purposeLower === "traineeship"
  ) {
    return evaluateTrainingPath(inputWithContext);
  }

  // ===== BUSINESS/ENTREPRENEUR VISAS (NEW) =====
  if (
    purposeLower === "business" ||
    purposeLower === "start a business" ||
    purposeLower === "entrepreneur" ||
    purposeLower === "startup" ||
    purposeLower === "self-employment" ||
    purposeLower === "freiberufler"
  ) {
    return evaluateBusinessPath(inputWithContext);
  }

  // ===== UNKNOWN PURPOSE =====
  return {
    recommended: {
      code: "unknown_purpose",
      name: "Unknown Purpose",
      summary:
        "We couldn't identify your purpose for coming to Germany. Please select one of the supported categories.",
      notes: [],
    },
    notes: [
      "Supported purposes:",
      "• Work - Employment, job seeking, skilled work",
      "• Study - University, language courses, vocational training",
      "• Research - Academic research positions",
      "• Specialized - Arts, sports, freelance, language teaching",
      "• Personal - Family reunion, au pair, volunteer, working holiday",
      "• Training - Professional internships and training programs",
      "• Business - Start a business, self-employment, freelance",
      "If you have multiple purposes, select your PRIMARY purpose",
      "The system will suggest alternatives from other categories as well",
    ],
  };
}

/**
 * Validate input for impossible combinations - RETURNS blocking errors ONLY for critical issues
 */
function validateInput(
  input: VisaQuestionnaireInput,
): VisaRecommendation | null {
  // ===== AGE VALIDATIONS =====
  const age = input.age ??
    (input.birthday ? calculateAge(input.birthday) : undefined);

  // Au Pair age restriction - BLOCKING
  if (input.personalRoute?.toLowerCase().includes("au pair")) {
    if (age && (age < 18 || age > 26)) {
      return {
        recommended: {
          code: "au_pair_age_ineligible",
          name: "Au Pair Age Requirement Not Met",
          summary:
            `You must be between 18-26 years old for an Au Pair visa. Your age: ${age}.`,
          notes: [],
        },
        notes: [
          "Au Pair programs in Germany have strict age requirements",
          "Consider alternative visa types:",
          "• Language Course Visa (if learning German)",
          "• Volunteer Service Visa (FSJ/BFD)",
          "• Work Visa (if you have qualifications)",
          "• Student Visa (if pursuing education)",
        ],
      };
    }
  }

  // Working Holiday age restriction - BLOCKING
  if (input.personalRoute?.toLowerCase().includes("working holiday")) {
    if (age && (age < 18 || age > 30)) {
      return {
        recommended: {
          code: "working_holiday_age_ineligible",
          name: "Working Holiday Age Requirement Not Met",
          summary: `Working Holiday visa requires age 18-30. Your age: ${age}.`,
          notes: [],
        },
        notes: [
          "Working Holiday agreements have strict age limits",
          "Consider alternative visa types if you're over 30:",
          "• Job Seeker Visa (6 months to find work)",
          "• Work Visa (with job offer)",
          "• Language Course Visa",
        ],
      };
    }
  }

  // ===== STUDY MODE VALIDATION - BLOCKING =====
  if (
    input.eduLevel?.toLowerCase().includes("university") &&
    input.studyMode?.toLowerCase() === "part-time"
  ) {
    return {
      recommended: {
        code: "part_time_study_ineligible",
        name: "Part-Time Study Not Eligible",
        summary:
          "Student visas require full-time enrollment. Part-time study does not qualify.",
        notes: [],
      },
      notes: [
        "German student visas require full-time enrollment (minimum 18 hours/week)",
        "Options:",
        "• Switch to full-time program if possible",
        "• Consider other visa types (work visa if employed)",
        "• Evening/weekend programs generally don't qualify for student visas",
      ],
    };
  }

  // ===== LANGUAGE COURSE VALIDATION - BLOCKING =====
  if (input.isLanguageCourse && input.fulltimeGerman === false) {
    return {
      recommended: {
        code: "part_time_language_ineligible",
        name: "Part-Time Language Course Not Eligible",
        summary:
          "Language course visas require full-time enrollment (18+ hours per week).",
        notes: [],
      },
      notes: [
        "To qualify for a language course visa, you must attend:",
        "• Minimum 18 hours of instruction per week",
        "• Intensive German language course",
        "Options if you want part-time study:",
        "• Take the course while on tourist visa (if visa-free nationality)",
        "• Come on another visa type (work, family reunion, etc.)",
      ],
    };
  }

  // All other validations are NON-BLOCKING - let the scoring engine handle them
  return null;
}
