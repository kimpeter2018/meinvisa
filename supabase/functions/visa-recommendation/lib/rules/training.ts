// lib/rules/training.ts - NEW for Training/Internship visas

import {
  VisaOption,
  VisaQuestionnaireInput,
  VisaRecommendation,
} from "../types.ts";
import {
  chooseTopCandidate,
  chooseUpToTwoAlternatives,
  evaluateAllVisas,
} from "../utils/ranker.ts";
import { personalizeCandidate } from "../utils/personalization.ts";

/**
 * Evaluates training/internship visa paths
 *
 * Covers:
 * - Professional internships (Praktikum)
 * - On-the-job training
 * - Practical training for students
 * - Language + internship combined programs
 */
export function evaluateTrainingPath(
  input: VisaQuestionnaireInput,
): VisaRecommendation {
  const allCandidates = evaluateAllVisas(input);

  // Filter candidates with reasonable scores
  const viableCandidates = allCandidates.filter((c) => {
    // Include training-related visas
    if (c.code.includes("training") || c.code.includes("internship")) {
      return c.score >= 15;
    }

    // Include high-scoring work visas (transition option)
    if (c.category === "work" && c.score >= 30) return true;

    // Include education visas
    if (c.category === "education" && c.score >= 25) return true;

    return false;
  });

  if (viableCandidates.length === 0) {
    return buildTrainingFallback(input);
  }

  const topCandidate = chooseTopCandidate(viableCandidates);

  if (!topCandidate) {
    return buildTrainingFallback(input);
  }

  const alternativeCandidates = chooseUpToTwoAlternatives(
    viableCandidates,
    topCandidate,
  );
  const recommended = personalizeCandidate(topCandidate);
  const alternatives = alternativeCandidates.map((c) =>
    personalizeCandidate(c)
  );
  const notes = buildTrainingNotes(input, topCandidate, viableCandidates);

  return {
    recommended: convertToVisaOption(recommended),
    alternatives: alternatives.map(convertToVisaOption),
    notes,
  };
}

function convertToVisaOption(personalized: any): VisaOption {
  const requirements: string[] = [];

  if (personalized.requirements?.met?.length > 0) {
    requirements.push(`✓ Met: ${personalized.requirements.met.join(", ")}`);
  }

  if (personalized.requirements?.missing?.length > 0) {
    requirements.push(
      `⚠ Missing: ${personalized.requirements.missing.join(", ")}`,
    );
  }

  return {
    code: personalized.code,
    name: personalized.name,
    summary:
      `${personalized.summary}\n\nConfidence: ${personalized.confidence}`,
    requirements: requirements.length > 0 ? requirements : undefined,
    notes: personalized.notes,
  };
}

function buildTrainingNotes(
  input: VisaQuestionnaireInput,
  topCandidate: any,
  allCandidates: any[],
): string[] {
  const notes: string[] = [];

  // Training type specific guidance
  if (input.trainingType) {
    const type = input.trainingType.toLowerCase();

    if (type.includes("internship")) {
      notes.push(
        "💼 Internship visa (Praktikum) allows work experience in your field for up to 12-18 months.",
      );
    }

    if (type.includes("language")) {
      notes.push(
        "🗣️ Language + Internship programs combine German learning with practical work experience.",
      );
    }
  }

  // Duration guidance
  if (input.trainingDurationMonths) {
    if (input.trainingDurationMonths > 12) {
      notes.push(
        `⏱️ Training duration of ${input.trainingDurationMonths} months may require special justification (typically max 12 months).`,
      );
    } else {
      notes.push(
        `⏱️ Your ${input.trainingDurationMonths}-month training period fits standard visa requirements.`,
      );
    }
  }

  // Compensation guidance
  if (input.trainingCompensation === false) {
    notes.push(
      "💰 Unpaid training requires proof of funds (approximately €1,000/month for living expenses).",
    );
  } else if (input.trainingCompensation === true) {
    notes.push(
      "💰 Paid training positions strengthen your visa application significantly.",
    );
  }

  // Company requirement
  if (!input.trainingCompany) {
    notes.push(
      "🏢 You need a confirmed training agreement from a German company or organization.",
    );
  }

  // Qualification match
  if (input.hasDegree) {
    notes.push(
      "🎓 Your university degree supports your training visa - training should relate to your field of study.",
    );
  }

  // German language
  const germanLevel = input.germanLevel?.toUpperCase();
  if (!germanLevel || ["A1", "A2", "NONE"].includes(germanLevel)) {
    notes.push(
      "🗣️ B1 German is recommended for most training positions (though not always required).",
    );
  }

  // Age consideration
  if (input.age && input.age < 25) {
    notes.push(
      "👤 Younger applicants often have easier approval for training visas.",
    );
  }

  // Transition to work visa
  notes.push(
    "🎯 After successful training, you may be eligible to switch to a work visa if you secure employment.",
  );

  // Required documents
  notes.push("📄 Required documents:");
  notes.push("   • Training agreement/contract from German company");
  notes.push("   • Training plan (detailing learning objectives)");
  notes.push("   • Proof of accommodation");
  notes.push("   • Health insurance");
  notes.push("   • Proof of financial means (if unpaid/low-paid)");

  return notes;
}

function buildTrainingFallback(
  input: VisaQuestionnaireInput,
): VisaRecommendation {
  const notes: string[] = [];

  notes.push("🎯 Training/Internship visas require:");

  if (!input.trainingCompany) {
    notes.push("📋 Step 1: Secure a training position with a German company");
    notes.push("🔍 Resources: DAAD, AIESEC, IES Abroad, company career pages");
  }

  if (!input.trainingType) {
    notes.push(
      "📝 Step 2: Clarify training type (internship, practical training, on-the-job)",
    );
  }

  if (!input.proofFunds && input.trainingCompensation === false) {
    notes.push(
      "💰 Step 3: Arrange proof of funds (€12,000-15,000 for 12 months if unpaid)",
    );
  }

  const germanLevel = input.germanLevel?.toUpperCase();
  if (!germanLevel || germanLevel === "A1" || germanLevel === "NONE") {
    notes.push(
      "🗣️ Step 4: Improve German to at least A2-B1 level (helpful but not always required)",
    );
  }

  notes.push(
    "\n💡 Training visas are excellent stepping stones to work visas!",
  );
  notes.push("🏢 Many trainees receive job offers from their host companies");

  return {
    recommended: {
      code: "training_preparation_needed",
      name: "Training Visa Preparation Phase",
      summary:
        "Training/internship visas are very achievable with proper preparation. Follow the steps below.",
      notes: [],
    },
    notes: [
      "Training visas typically process in 6-12 weeks",
      "Success rate is high for applicants with confirmed training agreements",
      "Training can lead directly to employment and work visa",
      ...notes,
    ],
  };
}
