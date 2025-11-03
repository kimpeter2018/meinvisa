import { VisaQuestionnaireInput, VisaRecommendation } from "../types.ts";
import visas from "../constants/visas.json" with { type: "json" };
import { compareLanguageLevel } from "../utils/matchHelpers.ts";
import { isVisaFreeNationality } from "../utils/nationality.ts";

export function evaluateEducationPath(input: VisaQuestionnaireInput): VisaRecommendation {
  const { admitted, eduLevel, isLanguageCourse, isAusbildung, isNursing, proofFunds, germanLevel, englishLevel } = input;

  // 1️⃣ Admitted to a university → Student Visa
  if (admitted && eduLevel?.toLowerCase().includes("university")) {
    const notes: string[] = [];

    if (germanLevel && ["a1", "a2", "b1"].includes(germanLevel.toLowerCase())) {
      notes.push("Many universities require B2–C1 German level. Consider improving language proficiency.");
    }

    if (!proofFunds) {
      notes.push("You’ll need proof of approximately €11,208/year for living expenses.");
    }

    return {
      recommended: visas.education.student,
      notes,
      alternatives: [visas.education.language_course],
    };
  }

  // 2️⃣ Language course visa
  if (isLanguageCourse) {
    return {
      recommended: visas.education.language_course,
      notes: ["Ensure the course is full-time (minimum 18 hours per week)."],
    };
  }

  // 3️⃣ Ausbildung visa
  if (isAusbildung) {
    return {
      recommended: visas.education.ausbildung,
      notes: ["You must have a training contract and usually B1 German proficiency."],
    };
  }

  // 4️⃣ Nursing adaptation
  if (isNursing) {
    return {
      recommended: {
        code: "nursing_adaptation",
        name: "Special Regulation for Nursing Assistants",
        summary:
          "For partially recognized nursing qualifications completing adaptation programs in Germany.",
        requirements: ["Partial recognition notice", "B1–B2 German", "Training contract"],
      },
    };
  }

  // fallback
  return {
    recommended: visas.education.language_course,
    notes: ["If you’re still deciding, start with a language course visa to improve your eligibility."],
  };
}