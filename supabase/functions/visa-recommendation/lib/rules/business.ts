// lib/rules/business.ts - NEW for Entrepreneur/Self-Employment visas

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
 * Evaluates business/entrepreneur visa paths
 *
 * Covers:
 * - Self-employment visa (Selbständigkeit)
 * - Freelance visa (Freiberufler)
 * - Startup visa
 * - Business founder visa
 */
export function evaluateBusinessPath(
  input: VisaQuestionnaireInput,
): VisaRecommendation {
  const allCandidates = evaluateAllVisas(input);

  // Filter candidates
  const viableCandidates = allCandidates.filter((c) => {
    // Include specialized business visas
    if (
      c.code.includes("freelance") || c.code.includes("self") ||
      c.code.includes("business")
    ) {
      return c.score >= 15;
    }

    // Include high-scoring alternatives
    if (c.score >= 30) return true;

    return false;
  });

  if (viableCandidates.length === 0) {
    return buildBusinessFallback(input);
  }

  const topCandidate = chooseTopCandidate(viableCandidates);

  if (!topCandidate) {
    return buildBusinessFallback(input);
  }

  const alternativeCandidates = chooseUpToTwoAlternatives(
    viableCandidates,
    topCandidate,
  );
  const recommended = personalizeCandidate(topCandidate);
  const alternatives = alternativeCandidates.map((c) =>
    personalizeCandidate(c)
  );
  const notes = buildBusinessNotes(input, topCandidate, viableCandidates);

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

function buildBusinessNotes(
  input: VisaQuestionnaireInput,
  topCandidate: any,
  allCandidates: any[],
): string[] {
  const notes: string[] = [];

  // Business type specific guidance
  if (input.businessType) {
    const type = input.businessType.toLowerCase();

    if (type.includes("freelance") || type.includes("consulting")) {
      notes.push(
        "💼 Freelance visa (Freiberufler) is for independent professionals (consultants, designers, IT, etc.)",
      );
      notes.push(
        "📋 Freelancers (Freiberufler) vs Self-Employed (Gewerbetreibende):",
      );
      notes.push(
        "   • Freelance: Knowledge-based services (consulting, IT, design, writing)",
      );
      notes.push(
        "   • Self-Employed: Trade/commerce (retail, manufacturing, restaurants)",
      );
    }

    if (type.includes("startup") || type.includes("tech")) {
      notes.push(
        "🚀 Startup visa focuses on innovative business ideas with economic benefit to Germany",
      );
      notes.push(
        "💡 Tech startups: Berlin, Munich, Hamburg have strong ecosystem support",
      );
    }

    if (type.includes("restaurant") || type.includes("retail")) {
      notes.push(
        "🏪 Trade businesses need to show economic interest and job creation",
      );
      notes.push(
        "💰 Higher capital requirements for trade/commerce (typically €25,000+)",
      );
    }
  }

  // Business plan requirement
  if (!input.hasBusinessPlan) {
    notes.push("📊 Business plan is CRITICAL. Must include:");
    notes.push("   • Executive summary");
    notes.push("   • Market analysis (German market specific)");
    notes.push("   • Financial projections (3-5 years)");
    notes.push("   • Marketing strategy");
    notes.push("   • Proof of economic interest to Germany");
  } else {
    notes.push(
      "✓ Business plan prepared - ensure it's comprehensive and shows economic benefit to Germany",
    );
  }

  // Capital requirements
  if (input.businessInvestment) {
    if (input.businessInvestment < 10000) {
      notes.push(
        `💰 Your investment (€${input.businessInvestment}) is quite low. Consider:`,
      );
      notes.push("   • Freelance visa (lower capital requirement)");
      notes.push("   • Partnering to increase capital");
    } else if (input.businessInvestment >= 25000) {
      notes.push(
        `💰 Strong investment (€${input.businessInvestment}) strengthens your application significantly`,
      );
    }
  } else {
    notes.push("💰 Typical capital requirements:");
    notes.push("   • Freelance: €10,000-€20,000 recommended");
    notes.push("   • Startup/Tech: €15,000-€50,000");
    notes.push("   • Trade/Commerce: €25,000-€100,000+");
  }

  // Client base
  if (input.hasBusinessClients) {
    notes.push(
      "✓ Existing German clients/contracts significantly improve approval chances",
    );
  } else {
    notes.push(
      "🤝 Having confirmed clients or letters of intent from German companies is very helpful",
    );
  }

  // Qualifications
  if (input.hasDegree) {
    notes.push(
      "🎓 Your degree supports your business visa - shows professional qualification",
    );
  }

  if (input.experienceYears && input.experienceYears >= 3) {
    notes.push(
      `💼 ${input.experienceYears} years of experience demonstrates professional competence`,
    );
  }

  // Language requirements
  const germanLevel = input.germanLevel?.toUpperCase();
  if (!germanLevel || ["A1", "A2", "NONE"].includes(germanLevel)) {
    notes.push(
      "🗣️ B1-B2 German strongly recommended for business visa (not always required but helpful)",
    );
  }

  // Registration requirements
  notes.push("📋 After approval, you must:");
  notes.push(
    "   • Register business with local authorities (Gewerbeamt or Finanzamt)",
  );
  notes.push(
    "   • Register with IHK (Chamber of Commerce) or HWK (Chamber of Crafts)",
  );
  notes.push("   • Get business insurance");
  notes.push("   • Register for taxes (Steuernummer)");
  notes.push("   • Open business bank account");

  // Timeline
  notes.push(
    "⏱️ Business visa processing: 3-6 months (longer than other visa types)",
  );
  notes.push(
    "🔍 Application reviewed by multiple authorities: Immigration office + Chamber of Commerce",
  );

  // Success factors
  notes.push("\n✅ Key success factors:");
  notes.push("   • Comprehensive, realistic business plan");
  notes.push("   • Sufficient capital (provable)");
  notes.push("   • Proof of professional qualification");
  notes.push("   • Clear economic benefit to Germany");
  notes.push("   • Evidence of market demand");

  // Sector-specific hubs
  if (input.businessSector || input.businessType) {
    notes.push("\n🌍 Recommended cities by sector:");
    notes.push("   • Tech/Startup: Berlin, Munich, Hamburg");
    notes.push("   • Finance/Consulting: Frankfurt, Munich");
    notes.push("   • Creative/Media: Berlin, Hamburg, Cologne");
    notes.push("   • Manufacturing/Engineering: Munich, Stuttgart, Düsseldorf");
  }

  return notes;
}

function buildBusinessFallback(
  input: VisaQuestionnaireInput,
): VisaRecommendation {
  const notes: string[] = [];

  notes.push("🎯 To qualify for a business/self-employment visa, you need:");

  if (!input.hasBusinessPlan) {
    notes.push("\n📊 Step 1: Develop comprehensive business plan");
    notes.push("   Must include:");
    notes.push("   • Market analysis (German market)");
    notes.push("   • Financial projections (3-5 years)");
    notes.push("   • Marketing strategy");
    notes.push("   • Economic benefit to Germany");
    notes.push("   • Job creation potential (if applicable)");
  }

  if (!input.businessInvestment || input.businessInvestment < 10000) {
    notes.push("\n💰 Step 2: Secure sufficient capital");
    notes.push("   • Freelance/Consulting: €10,000-€20,000");
    notes.push("   • Startup: €15,000-€50,000");
    notes.push("   • Trade/Commerce: €25,000+");
    notes.push(
      "   Capital must be provable (bank statements, investment agreements)",
    );
  }

  if (
    !input.hasDegree && (!input.experienceYears || input.experienceYears < 3)
  ) {
    notes.push("\n🎓 Step 3: Document your qualifications");
    notes.push("   • University degree (preferred), OR");
    notes.push("   • 3-5+ years professional experience");
    notes.push("   • Professional certifications");
    notes.push("   • Portfolio/previous work examples");
  }

  const germanLevel = input.germanLevel?.toUpperCase();
  if (!germanLevel || germanLevel === "A1" || germanLevel === "NONE") {
    notes.push("\n🗣️ Step 4: Improve German language skills");
    notes.push("   • B1 minimum recommended");
    notes.push("   • B2 strongly preferred for business interactions");
  }

  if (!input.hasBusinessClients) {
    notes.push(
      "\n🤝 Step 5: Build German client base (optional but very helpful)",
    );
    notes.push("   • Letters of intent from German companies");
    notes.push("   • Pre-contracts or agreements");
    notes.push("   • Partnership agreements");
  }

  notes.push("\n💡 Resources:");
  notes.push("   • German Accelerator (tech startups)");
  notes.push("   • IHK/HWK (Chambers of Commerce/Crafts)");
  notes.push("   • EXIST Business Start-up Grant");
  notes.push("   • Make it in Germany (official portal)");

  notes.push("\n⚠️ Important notes:");
  notes.push(
    "   • Self-employment visa is one of the most difficult to obtain",
  );
  notes.push("   • Plan for 3-6 months processing time");
  notes.push("   • Consider consulting an immigration lawyer");
  notes.push(
    "   • Some professions (architect, lawyer, doctor) have additional requirements",
  );

  return {
    recommended: {
      code: "business_preparation_needed",
      name: "Business Visa Preparation Phase",
      summary:
        "Self-employment visas require thorough preparation. Success rate improves significantly with solid planning.",
      notes: [],
    },
    notes: [
      "Business visas are challenging but achievable with solid preparation",
      "Many successful entrepreneurs started with work visas before switching to self-employment",
      "Consider starting as freelancer (easier) before opening larger business",
      ...notes,
    ],
  };
}
