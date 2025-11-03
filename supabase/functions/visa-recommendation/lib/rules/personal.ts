import { VisaQuestionnaireInput, VisaRecommendation } from "../types.ts";
import visas from "../constants/visas.json" with { type: "json" };

export function evaluatePersonalPath(input: VisaQuestionnaireInput): VisaRecommendation {
  const { hasFamilyInGermany, personalRoute } = input;

  // 1️⃣ Family reunion
  if (hasFamilyInGermany) {
    return { recommended: visas.personal.family_reunion };
  }

  // 2️⃣ Au pair
  if (personalRoute?.toLowerCase().includes("au pair")) {
    return { recommended: visas.personal.au_pair };
  }

  // 3️⃣ Volunteer
  if (personalRoute?.toLowerCase().includes("volunteer")) {
    return { recommended: visas.personal.volunteer_service };
  }

  // fallback
  return {
    recommended: visas.personal.volunteer_service,
    notes: [
      "You can also explore cultural exchange or au pair programs depending on your goals.",
    ],
  };
}
