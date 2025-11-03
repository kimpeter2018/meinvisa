import { VisaQuestionnaireInput, VisaRecommendation } from "./types.ts";
import { evaluateWorkPath } from "./rules/work.ts";
import { evaluateEducationPath } from "./rules/education.ts";
import { evaluateResearchPath } from "./rules/research.ts";
import { evaluatePersonalPath } from "./rules/personal.ts";

export function evaluateVisa(input: VisaQuestionnaireInput): VisaRecommendation {
  const { purpose } = input;

  if (!purpose) {
    return {
      recommended: {
        code: "unspecified_purpose",
        name: "Insufficient Information",
        summary: "Please select your main purpose in Germany."
      }
    };
  }

  // Add input as context for scoring
  const inputWithContext = {
    ...input,
    context: input  // Pass full input as context for personalization
  };

  switch (purpose.toLowerCase()) {
    case "work":
      return evaluateWorkPath(inputWithContext);

    case "study":
    case "education":
      return evaluateEducationPath(inputWithContext);

    case "research":
    case "culture":
      return evaluateResearchPath(inputWithContext);

    case "personal":
    case "development":
      return evaluatePersonalPath(inputWithContext);

    default:
      return {
        recommended: {
          code: "unknown_purpose",
          name: "Unknown Purpose",
          summary: "Please select a valid purpose: Work, Study, Research, or Personal."
        }
      };
  }
}