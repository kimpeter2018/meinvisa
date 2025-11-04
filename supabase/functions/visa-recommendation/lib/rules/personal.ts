// lib/rules/personal.ts
import { VisaQuestionnaireInput, VisaRecommendation, VisaOption } from "../types.ts";
import { evaluateAllVisas, chooseTopCandidate, chooseUpToTwoAlternatives } from "../utils/ranker.ts";
import { personalizeCandidate } from "../utils/personalization.ts";

/**
 * Evaluates personal/family-related visa paths using the scoring engine.
 * 
 * This includes:
 * - Family reunion (spouse, children, parents)
 * - Au pair programs
 * - Volunteer services (FSJ, BFD, European Solidarity Corps)
 * - Cultural exchange programs
 * 
 * This function:
 * 1. Evaluates ALL visas using the scoring engine
 * 2. Prioritizes personal/family visas but includes alternatives
 * 3. Provides family-specific guidance and requirements
 * 4. Includes pathways to work/education after initial stay
 */
export function evaluatePersonalPath(input: VisaQuestionnaireInput): VisaRecommendation {
  // Evaluate all visas across all categories
  const allCandidates = evaluateAllVisas(input);
  
  // Filter candidates with reasonable scores
  const viableCandidates = allCandidates.filter(c => {
    // Always include personal category visas with score >= 15
    if (c.category === "personal" && c.score >= 15) return true;
    
    // Include high-scoring visas from other categories
    if (c.score >= 30) return true;
    
    // Include education visas (common bridge path) with score >= 25
    if (c.category === "education" && c.score >= 25) return true;
    
    // Include work visas for family members with score >= 25
    if (c.category === "work" && c.score >= 25 && input.hasFamilyInGermany) return true;
    
    return false;
  });

  // If no viable candidates, provide helpful fallback
  if (viableCandidates.length === 0) {
    return buildPersonalFallback(input);
  }

  // Choose top candidate as recommended
  const topCandidate = chooseTopCandidate(viableCandidates);
  
  if (!topCandidate) {
    return buildPersonalFallback(input);
  }

  // Choose up to 2 alternatives with category diversity
  const alternativeCandidates = chooseUpToTwoAlternatives(viableCandidates, topCandidate);

  // Personalize the recommended visa
  const recommended = personalizeCandidate(topCandidate);

  // Personalize alternatives
  const alternatives = alternativeCandidates.map(c => personalizeCandidate(c));

  // Generate contextual notes specific to personal/family paths
  const notes = buildPersonalNotes(input, topCandidate, viableCandidates);

  return {
    recommended: convertToVisaOption(recommended),
    alternatives: alternatives.map(convertToVisaOption),
    notes
  };
}

/**
 * Converts personalized candidate to VisaOption format
 */
function convertToVisaOption(personalized: any): VisaOption {
  const requirements: string[] = [];
  
  if (personalized.requirements?.met?.length > 0) {
    requirements.push(`✓ Met: ${personalized.requirements.met.join(", ")}`);
  }
  
  if (personalized.requirements?.missing?.length > 0) {
    requirements.push(`⚠ Missing: ${personalized.requirements.missing.join(", ")}`);
  }

  return {
    code: personalized.code,
    name: personalized.name,
    summary: `${personalized.summary}\n\nConfidence: ${personalized.confidence}`,
    requirements: requirements.length > 0 ? requirements : undefined,
    notes: personalized.notes
  };
}

/**
 * Builds personal/family-specific contextual notes
 */
function buildPersonalNotes(
  input: VisaQuestionnaireInput,
  topCandidate: any,
  allCandidates: any[]
): string[] {
  const notes: string[] = [];
  
  // Family Reunion specific guidance
  if (topCandidate.code === "family_reunion" || input.hasFamilyInGermany) {
    notes.push("👨‍👩‍👧‍👦 Family reunion visa allows you to join your family member who has legal residence in Germany.");
    
    // Language requirements vary by family member's status
    notes.push("🗣️ Language requirement: Usually A1 German, but exceptions exist if family member has Blue Card, permanent residence, or is EU citizen.");
    
    // Spouse-specific notes
    if (input.personalRoute?.toLowerCase().includes("spouse") || input.personalRoute?.toLowerCase().includes("partner")) {
      notes.push("💑 Spouses of German citizens or permanent residents have easier requirements.");
      notes.push("💼 You'll be eligible for unrestricted work permit immediately upon arrival.");
      notes.push("🏡 After 3 years, you can apply for permanent residence (2 years if you have B1 German).");
    }
    
    // Children-specific notes
    if (input.personalRoute?.toLowerCase().includes("child")) {
      notes.push("👶 Children under 16 don't need German language certification.");
      notes.push("🎒 School enrollment is mandatory for children aged 6-16 (compulsory education).");
    }
    
    // Parent reunification
    if (input.personalRoute?.toLowerCase().includes("parent")) {
      notes.push("👴 Parent reunification is more restrictive - requires proof that sponsor can support you financially.");
      notes.push("💰 Sponsor needs sufficient income (typically ~€1,500-2,000/month + additional per family member).");
    }
    
    // Financial requirements
    if (!input.proofFunds) {
      notes.push("💰 Your family member (sponsor) must prove sufficient income/funds to support you without social benefits.");
    }
    
    // Housing requirements
    if (!input.hasAccommodation) {
      notes.push("🏠 Adequate housing required: minimum space standards apply (varies by city, typically 12-15 sqm per person).");
    }
    
    notes.push("📄 Required documents: Marriage certificate, birth certificates, family member's residence permit, housing proof.");
  }

  // Au Pair specific guidance
  if (topCandidate.code === "au_pair" || input.personalRoute?.toLowerCase().includes("au pair")) {
    notes.push("🏡 Au pair visa: Live with German host family, provide childcare (~30 hrs/week), receive pocket money (~€280/month) + accommodation.");
    
    // Age requirement
    if (input.age) {
      if (input.age >= 18 && input.age <= 26) {
        notes.push(`✓ Your age (${input.age}) fits the au pair requirement (18-26 years).`);
      } else if (input.age < 18) {
        notes.push(`❌ You must be at least 18 years old for au pair visa (currently ${input.age}).`);
      } else if (input.age > 26) {
        notes.push(`⚠️ Au pair programs typically require age 18-26 (you're ${input.age}). Some families may accept slightly older applicants.`);
      }
    } else {
      notes.push("⚠️ Au pair visa requires age 18-26 years.");
    }
    
    // Language and cultural requirements
    const germanLevel = input.germanLevel?.toUpperCase();
    if (!germanLevel || ["A1", "A2"].includes(germanLevel)) {
      notes.push("🗣️ A1 German minimum required, but A2-B1 is highly recommended for better family matching.");
    }
    
    notes.push("🎓 You must attend German language course (minimum 6 hours/week) - included in program.");
    notes.push("⏱️ Au pair stay is limited to 12 months (some extend to 24 months).");
    notes.push("💼 After au pair year, you can switch to work/study visa if you meet requirements.");
    notes.push("🔍 Find families through: Au Pair World, AuPair.com, Cultural Care, AIFS");
  }

  // Volunteer Service (FSJ/BFD) guidance
  if (topCandidate.code === "volunteer_service" || input.personalRoute?.toLowerCase().includes("volunteer")) {
    notes.push("🤝 Volunteer visa (FSJ/BFD/ESC): Work with social, ecological, or cultural organizations.");
    notes.push("💰 You receive: Housing + meals + pocket money (~€150-400/month) + health insurance.");
    notes.push("⏱️ Duration: 6-18 months (typically 12 months).");
    
    // Language requirements
    const germanLevel = input.germanLevel?.toUpperCase();
    if (!germanLevel || germanLevel === "A1") {
      notes.push("🗣️ A2-B1 German is recommended for most volunteer positions (A1 accepted for some).");
    }
    
    notes.push("📚 Program includes: German language classes, educational seminars, cultural integration.");
    notes.push("🎓 Great pathway to work/study visa: Many volunteers continue with education or employment in Germany.");
    notes.push("🌍 Programs: FSJ (Freiwilliges Soziales Jahr), BFD (Bundesfreiwilligendienst), European Solidarity Corps");
    notes.push("🔍 Find organizations: ijgd.de, pro-fsj.de, bundes-freiwilligendienst.de");
  }

  // Working Holiday Visa (if eligible)
  if (input.nationality) {
    const workingHolidayCountries = ["Australia", "New Zealand", "Canada", "Japan", "South Korea", "Israel", "Chile", "Argentina", "Uruguay", "Hong Kong", "Taiwan"];
    const isEligible = workingHolidayCountries.some(
      country => input.nationality?.toLowerCase().includes(country.toLowerCase())
    );
    
    if (isEligible && input.age && input.age >= 18 && input.age <= 30) {
      const hasWHVisa = allCandidates.some(c => c.code === "working_holiday");
      if (!hasWHVisa) {
        notes.push(`🎒 As a ${input.nationality} national aged ${input.age}, you're eligible for Working Holiday Visa (18-30 years)!`);
        notes.push("🌍 Working Holiday: 12 months stay + unlimited work permission + travel freedom. Great way to explore Germany.");
      }
    }
  }

  // Age considerations
  if (input.age) {
    if (input.age < 18) {
      notes.push("👶 As a minor, you'll need parental consent and guardian arrangements in Germany.");
    } else if (input.age > 60 && topCandidate.code === "family_reunion") {
      notes.push("👴 Senior applicants: Consider health insurance requirements carefully (can be expensive for private insurance).");
    }
  }

  // Language learning emphasis
  const germanLevel = input.germanLevel?.toUpperCase();
  if (!germanLevel || ["A1", "A2"].includes(germanLevel)) {
    notes.push("🗣️ Invest in German language learning NOW. It opens more opportunities and helps with integration.");
    notes.push("📖 Free resources: DW Learn German, Goethe Institut free courses, VHS Volkshochschule (~€100-300 for full course)");
  }

  // Integration courses
  if (topCandidate.category === "personal") {
    notes.push("🎓 After arrival, you're eligible for Integration Course (Integrationskurs): 600-900 hours German + 100 hours orientation.");
    notes.push("💡 Integration course costs: €2.29/hour (subsidized) or free if receiving social benefits.");
  }

  // Work permission for personal visa holders
  if (topCandidate.category === "personal") {
    if (topCandidate.code === "family_reunion") {
      notes.push("💼 Work permission: Usually unlimited work rights if family member has work permit/Blue Card/permanent residence.");
    } else if (topCandidate.code === "au_pair") {
      notes.push("💼 Work restriction: Only au pair work allowed during program. Can work freely after switching visa.");
    } else if (topCandidate.code === "volunteer_service") {
      notes.push("💼 Work restriction: Only volunteer position allowed. Can apply for work visa after completion.");
    }
  }

  // Pathway to permanent residence
  if (topCandidate.category === "personal") {
    notes.push("🏡 Path to permanent residence:");
    if (topCandidate.code === "family_reunion") {
      notes.push("   → 3 years with residence permit + B1 German = eligible for permanent residence");
      notes.push("   → 2 years if you have B1 German at time of application");
    } else {
      notes.push("   → Complete personal visa program → Switch to work/education visa → 2-4 years → Permanent residence");
    }
  }

  // Health insurance (mandatory)
  if (!input.hasInsurance) {
    notes.push("🏥 Health insurance mandatory from day 1. Options:");
    notes.push("   • Public insurance: ~€110/month (students/au pair) or ~€200-400/month (employed)");
    notes.push("   • Private insurance: Varies by age/health (consider carefully for long-term stay)");
  }

  // Cultural integration tips
  if (topCandidate.category === "personal") {
    notes.push("🤝 Integration tips:");
    notes.push("   • Join local Verein (clubs) - sports, culture, hobbies");
    notes.push("   • Attend language exchange meetups (Tandem partners)");
    notes.push("   • Use city integration services (Integrationsbüro)");
    notes.push("   • Connect with expat communities while building local friendships");
  }

  return notes;
}

/**
 * Fallback recommendation when no viable candidates found
 */
function buildPersonalFallback(input: VisaQuestionnaireInput): VisaRecommendation {
  const notes: string[] = [];
  
  // Identify the personal path user is interested in
  let pathType = "personal/family";
  if (input.hasFamilyInGermany) pathType = "family reunion";
  else if (input.personalRoute?.toLowerCase().includes("au pair")) pathType = "au pair";
  else if (input.personalRoute?.toLowerCase().includes("volunteer")) pathType = "volunteer";
  
  notes.push(`🎯 You're pursuing a ${pathType} visa pathway. Here's what you need:`);
  
  // Family Reunion path guidance
  if (pathType === "family reunion") {
    if (!input.hasFamilyInGermany) {
      notes.push("👨‍👩‍👧‍👦 Step 1: Confirm your family member has legal residence in Germany (work permit, Blue Card, permanent residence, or citizenship).");
    }
    
    notes.push("🗣️ Step 2: Achieve A1 German level (usually required, exceptions for Blue Card holders' families).");
    notes.push("📄 Step 3: Gather documents:");
    notes.push("   • Marriage certificate / birth certificate (apostilled + translated)");
    notes.push("   • Family member's residence permit copy");
    notes.push("   • Housing proof (Mietvertrag showing adequate space)");
    notes.push("   • Family member's income proof");
    notes.push("💰 Step 4: Ensure family member earns enough to support you (~€1,500-2,000/month + more for each family member).");
  }
  
  // Au Pair path guidance
  else if (pathType === "au pair") {
    notes.push("🔍 Step 1: Find a host family through:");
    notes.push("   • AuPairWorld.com, AuPair.com, Cultural Care, AIFS, GreatAuPair");
    
    if (!input.age || input.age < 18 || input.age > 26) {
      notes.push("⚠️ Step 2: Confirm age eligibility (must be 18-26 years).");
    }
    
    const germanLevel = input.germanLevel?.toUpperCase();
    if (!germanLevel || germanLevel === "A1") {
      notes.push("🗣️ Step 3: Learn basic German (A1 minimum, A2 recommended) before applying.");
    }
    
    notes.push("📝 Step 4: Sign au pair contract with host family (standard template available).");
    notes.push("🏥 Step 5: Arrange health insurance (host family usually helps with this).");
  }
  
  // Volunteer path guidance
  else if (pathType === "volunteer") {
    notes.push("🔍 Step 1: Find volunteer organization through:");
    notes.push("   • ijgd.de, pro-fsj.de, bundes-freiwilligendienst.de");
    notes.push("   • European Solidarity Corps (europa.eu/youth/solidarity)");
    
    notes.push("📝 Step 2: Apply to volunteer positions (social services, ecological projects, cultural institutions).");
    
    const germanLevel = input.germanLevel?.toUpperCase();
    if (!germanLevel || germanLevel === "A1") {
      notes.push("🗣️ Step 3: Improve German to A2-B1 level (makes finding positions much easier).");
    }
    
    notes.push("🤝 Step 4: Organization provides: hosting agreement, accommodation, health insurance, stipend.");
  }
  
  // Generic personal visa guidance
  else {
    notes.push("📋 Step 1: Clarify your specific personal/family situation.");
    notes.push("💼 Step 2: Check if you have family connections, au pair interest, or volunteer opportunities.");
    notes.push("🗣️ Step 3: Start learning German (at least A1 level recommended).");
  }

  // Common requirements across all personal visas
  notes.push("\n📋 Universal requirements for personal visas:");
  notes.push("   • Valid passport (6+ months validity)");
  notes.push("   • Health insurance");
  notes.push("   • Clean criminal record (police clearance certificate)");
  notes.push("   • Biometric photos");
  notes.push("   • Completed application forms");

  // Encouragement
  notes.push("\n💡 Personal visas are often overlooked but provide excellent pathways:");
  notes.push("   • Lower barriers than work/study visas");
  notes.push("   • Great for cultural immersion");
  notes.push("   • Can transition to work/education visas later");

  return {
    recommended: {
      code: "personal_preparation_needed",
      name: "Personal Visa Preparation Phase",
      summary: `You're pursuing a ${pathType} visa - a wonderful way to experience German life and culture. These visas have achievable requirements with proper preparation.`,
      notes
    },
    notes: [
      "Personal visas offer unique opportunities for cultural exchange and integration.",
      "Many successful work visa holders started with au pair or volunteer programs.",
      "Germany values family unity and cultural exchange - your path is supported by law."
    ]
  };
}