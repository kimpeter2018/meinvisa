// lib/rules/work.ts
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
 * Evaluates work-related visa paths using the scoring engine.
 *
 * This function:
 * 1. Evaluates ALL visas (not just work category) using the ranker
 * 2. Filters and ranks candidates by score
 * 3. Returns personalized recommendations with explanations
 * 4. Includes cross-category suggestions (e.g., language course as alternative)
 */
export function evaluateWorkPath(
  input: VisaQuestionnaireInput,
): VisaRecommendation {
  // Evaluate all visas across all categories
  const allCandidates = evaluateAllVisas(input);

  // Filter candidates with reasonable scores (>= 30) or important work visas
  const viableCandidates = allCandidates.filter((c) => {
    // Always include work category visas with score >= 20
    if (c.category === "work" && c.score >= 20) return true;

    // Include high-scoring visas from other categories
    if (c.score >= 30) return true;

    // Include language course if German level is low (common bridge path)
    if (c.code === "language_course" && c.score >= 15) return true;

    return false;
  });

  // If no viable candidates, provide helpful fallback
  if (viableCandidates.length === 0) {
    return buildFallbackRecommendation(input);
  }

  // Choose top candidate as recommended
  const topCandidate = chooseTopCandidate(viableCandidates);

  if (!topCandidate) {
    return buildFallbackRecommendation(input);
  }

  // Choose up to 2 alternatives with category diversity
  const alternativeCandidates = chooseUpToTwoAlternatives(
    viableCandidates,
    topCandidate,
  );

  // Personalize the recommended visa
  const recommended = personalizeCandidate(topCandidate);

  // Personalize alternatives
  const alternatives = alternativeCandidates.map((c) =>
    personalizeCandidate(c)
  );

  // Generate contextual notes
  const notes = buildContextualNotes(input, topCandidate, viableCandidates);

  return {
    recommended: convertToVisaOption(recommended),
    alternatives: alternatives.map(convertToVisaOption),
    notes,
  };
}

/**
 * Converts personalized candidate to VisaOption format
 */
function convertToVisaOption(personalized: any): VisaOption {
  const requirements: string[] = [];

  // Add met requirements
  if (personalized.requirements?.met?.length > 0) {
    requirements.push(`✓ Met: ${personalized.requirements.met.join(", ")}`);
  }

  // Add missing requirements
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

/**
 * Builds contextual notes based on user input and evaluation results
 */
function buildContextualNotes(
  input: VisaQuestionnaireInput,
  topCandidate: any,
  allCandidates: any[],
): string[] {
  const notes: string[] = [];

  // Job offer status
  if (!input.hasJobOffer && topCandidate.category === "work") {
    notes.push(
      "💡 Tip: Securing a job offer will significantly improve your visa options and processing time.",
    );
  }

  // Employment status guidance
  if (input.employmentStatus) {
    const status = input.employmentStatus.toLowerCase();

    if (status === "unemployed" && !input.hasJobOffer) {
      notes.push(
        "💼 Job Seeker Visa allows 6 months in Germany to find employment (requires degree + experience)",
      );
    }

    if (
      status === "employed" &&
      input.currentLocation?.toLowerCase().includes("germany")
    ) {
      notes.push(
        "📍 Already in Germany? Some visas can be applied for from within the country if you're visa-free nationality",
      );
    }
  }

  // Job offer status
  if (!input.hasJobOffer && topCandidate.category === "work") {
    notes.push(
      "💡 Tip: Securing a job offer will significantly improve your visa options and processing time.",
    );

    // Job search timeline guidance
    if (input.jobSearchTimeline) {
      const timeline = input.jobSearchTimeline.toLowerCase();
      if (timeline.includes("6+")) {
        notes.push(
          "🎯 With 6+ months timeline, consider Job Seeker Visa to search on-site in Germany",
        );
      }
    }
  }

  // Salary considerations (UPDATED with new thresholds)
  if (input.hasJobOffer && input.salary) {
    const blueCardThreshold = 58400;
    const shortageThreshold = 45600;
    const itThreshold = 50260;

    if (input.salary < shortageThreshold) {
      notes.push(
        `📊 Your salary (€${input.salary}) is below Blue Card minimums. Consider:`,
      );
      notes.push("   • Negotiating higher salary");
      notes.push(
        "   • Skilled Worker visa (no salary requirement with recognition)",
      );
      if (input.isItField && input.salary >= itThreshold) {
        notes.push(
          `   • IT Specialist visa (you meet €${itThreshold} threshold!)`,
        );
      }
    } else if (
      input.salary >= shortageThreshold && input.salary < blueCardThreshold
    ) {
      notes.push(
        `📊 Your salary (€${input.salary}) qualifies for Blue Card if your job is in a shortage occupation.`,
      );
      notes.push(
        "🔍 Shortage occupations: STEM fields, healthcare, IT, engineering",
      );
    } else if (input.salary >= blueCardThreshold) {
      notes.push(
        `✅ Your salary (€${input.salary}) exceeds Blue Card threshold - excellent for approval!`,
      );
    }
  }

  // Language considerations
  if (input.germanLevel) {
    const level = input.germanLevel.toUpperCase();
    if (["A1", "A2"].includes(level)) {
      notes.push(
        "🗣️ Consider improving your German to B1+ level to unlock more visa options and faster settlement pathways.",
      );

      // Suggest language course if not in top 3
      const hasLanguageCourse = allCandidates.slice(0, 3).some((c) =>
        c.code === "language_course"
      );
      if (!hasLanguageCourse) {
        notes.push(
          "💡 A language course visa could be a strategic first step while job searching.",
        );
      }
    }
  } else {
    notes.push(
      "🗣️ German language proficiency (even A2-B1) can significantly improve your visa prospects.",
    );
  }

  // Degree recognition
  if (input.hasDegree && !input.hasAnerkennung) {
    notes.push(
      "🎓 Getting your degree officially recognized (Anerkennung) through Anabin/ZAB will improve your eligibility.",
    );
  }

  // IT specialists special path
  if (
    input.isItField && !input.hasDegree && (input.experienceYears || 0) >= 3
  ) {
    const hasITVisa = allCandidates.slice(0, 3).some((c) =>
      c.code === "it_specialist"
    );
    if (!hasITVisa && input.salary && input.salary >= 50260) {
      notes.push(
        "💻 As an IT professional with 3+ years experience, you may qualify for the IT Specialist visa even without a degree.",
      );
    }
  }

  // Experience considerations
  if (input.experienceYears && input.experienceYears < 2) {
    notes.push(
      "📈 Gaining more work experience (2+ years) will open additional visa pathways.",
    );
  }

  // Cross-category suggestions
  if (topCandidate.category === "work" && topCandidate.score < 60) {
    const educationCandidates = allCandidates.filter((c) =>
      c.category === "education" && c.score >= 40
    );
    if (educationCandidates.length > 0) {
      notes.push(
        "🎯 Consider educational pathways (language course, Ausbildung) as a bridge to work visas.",
      );
    }
  }

  // Remote work guidance (NEW)
  if (input.remoteWork) {
    notes.push("🌐 Remote work for non-German companies:");
    notes.push("   • Freelance visa if working for multiple clients");
    notes.push(
      "   • Some remote positions qualify as 'digital nomad' - check specific requirements",
    );
    notes.push("   • May need proof of stable income + health insurance");
  }

  // Application location
  if (input.nationality) {
    const visaFreeCheck = [
      "United States",
      "Canada",
      "Australia",
      "Japan",
      "Korea",
      "United Kingdom",
    ].some(
      (country) =>
        input.nationality?.toLowerCase().includes(country.toLowerCase()),
    );

    if (visaFreeCheck && topCandidate.meta?.canApplyInCountry) {
      notes.push(
        "✈️ Your nationality allows visa-free entry. Some visas can be applied for from within Germany.",
      );
    }
  }

  return notes;
}

/**
 * Fallback recommendation when no viable candidates found
 */
function buildFallbackRecommendation(
  input: VisaQuestionnaireInput,
): VisaRecommendation {
  const notes: string[] = [];

  // Provide actionable guidance based on what's missing
  if (!input.hasJobOffer) {
    notes.push("🔍 Step 1: Secure a job offer from a German employer.");
  }

  if (!input.hasDegree && !input.hasVocational) {
    notes.push(
      "🎓 Step 2: Consider getting your qualifications recognized or pursuing education/training in Germany.",
    );
  }

  if (
    !input.germanLevel || ["A1", "A2"].includes(input.germanLevel.toUpperCase())
  ) {
    notes.push(
      "🗣️ Step 3: Improve German language skills to at least B1 level.",
    );
  }

  notes.push(
    "💡 Consider starting with a Job Seeker Visa (if qualified) or Language Course Visa to build your profile.",
  );

  return {
    recommended: {
      code: "preparation_needed",
      name: "Preparation Phase Required",
      summary:
        "Based on your current profile, you'll need to strengthen certain qualifications before applying for a work visa. See the notes below for specific steps.",
      notes,
    },
    notes: [
      "This is not a visa rejection - it's a roadmap to improve your eligibility.",
      "Many successful applicants start by addressing these gaps systematically.",
    ],
  };
}
