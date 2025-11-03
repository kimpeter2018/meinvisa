import { VisaQuestionnaireInput, VisaRecommendation } from "../types.ts";
import visas from "../constants/visas.json" with { type: "json" };

export function evaluateResearchPath(input: VisaQuestionnaireInput): VisaRecommendation {
  const { hasHostAgreement, researchFunded, isAthlete, hasPerformance, isLanguageTeacher, isEsports } = input;

  // 1️⃣ Researcher with host agreement
  if (hasHostAgreement && researchFunded) {
    return { recommended: visas.research.research };
  }

  // 2️⃣ Artist or performer
  if (hasPerformance) {
    return { recommended: visas.research.artist };
  }

  // 3️⃣ Language teacher
  if (isLanguageTeacher) {
    return {
      recommended: {
        code: "language_teacher",
        name: "Special Regulation for Language Teachers",
        summary: "For certified language teachers employed by German schools.",
        requirements: ["Employment contract", "Proof of teaching qualifications"],
      },
    };
  }

  // 4️⃣ Sports or esports
  if (isAthlete) {
    return {
      recommended: {
        code: "athlete_coach",
        name: "Athlete or Coach Visa",
        summary: "For professional athletes and coaches contracted by German clubs.",
        requirements: ["Club contract", "Health insurance"],
      },
    };
  }

  if (isEsports) {
    return {
      recommended: {
        code: "esports_pro",
        name: "Esports Professional Visa",
        summary: "For professional esports players employed by registered German esports organizations.",
        requirements: ["Club or team contract", "Proof of professional status"],
      },
    };
  }

  // fallback
  return {
    recommended: visas.research.research,
    notes: ["If unsure, contact the research institution for the correct visa category."],
  };
}
