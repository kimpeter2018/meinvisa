// lib/evaluateVisa.ts
import { VisaQuestionnaireInput, VisaRecommendation } from "./types.ts";
import { evaluateWorkPath } from "./rules/work.ts";
import { evaluateEducationPath } from "./rules/education.ts";
import { evaluateSpecializedPath } from "./rules/specialized.ts";
import { evaluatePersonalPath } from "./rules/personal.ts";

/**
 * Main router for visa evaluation
 * 
 * Routes user input to appropriate path evaluator based on purpose.
 * All path evaluators use the same scoring-based engine for consistency.
 * 
 * Supported purposes:
 * - work: Employment-based visas
 * - education/study: Academic and vocational training
 * - research/culture/specialized: Research, arts, sports, special professions
 * - personal/family: Family reunion, au pair, volunteer, working holiday
 */
export function evaluateVisa(input: VisaQuestionnaireInput): VisaRecommendation {
  const { purpose } = input;

  if (!purpose) {
    return {
      recommended: {
        code: "unspecified_purpose",
        name: "Insufficient Information",
        summary: "Please select your main purpose for coming to Germany.",
        notes: [
          "Common purposes: Work, Study, Research, Family/Personal",
          "Your choice helps us recommend the most suitable visa type"
        ]
      }
    };
  }

  // Add input as context for scoring and personalization
  const inputWithContext = {
    ...input,
    context: input  // Pass full input as context
  };

  // Route based on purpose
  const purposeLower = purpose.toLowerCase();

  // Work-related visas
  if (purposeLower === "work" || purposeLower === "employment") {
    return evaluateWorkPath(inputWithContext);
  }

  // Education-related visas
  if (purposeLower === "study" || 
      purposeLower === "education" || 
      purposeLower === "student" || 
      purposeLower === "training") {
    return evaluateEducationPath(inputWithContext);
  }

  // Specialized visas: Research, Arts, Culture, Sports
  if (purposeLower === "research" || 
      purposeLower === "culture" || 
      purposeLower === "arts" ||
      purposeLower === "sports" ||
      purposeLower === "specialized" ||
      purposeLower === "freelance" ||
      purposeLower === "self-employed") {
    return evaluateSpecializedPath(inputWithContext);
  }

  // Personal/Family visas
  if (purposeLower === "personal" || 
      purposeLower === "family" || 
      purposeLower === "reunion" ||
      purposeLower === "au pair" ||
      purposeLower === "volunteer" ||
      purposeLower === "development" ||
      purposeLower === "cultural exchange") {
    return evaluatePersonalPath(inputWithContext);
  }

  // Unknown purpose - provide helpful guidance
  return {
    recommended: {
      code: "unknown_purpose",
      name: "Unknown Purpose",
      summary: "We couldn't identify your purpose for coming to Germany. Please select one of the supported categories.",
      notes: [
        "Supported purposes:",
        "• Work - Employment, job seeking, skilled work",
        "• Education - University, language courses, vocational training",
        "• Specialized - Research, arts, sports, freelance",
        "• Personal - Family reunion, au pair, volunteer, working holiday"
      ]
    },
    notes: [
      "If you have multiple purposes, select your PRIMARY purpose",
      "The system will suggest alternatives from other categories as well"
    ]
  };
}