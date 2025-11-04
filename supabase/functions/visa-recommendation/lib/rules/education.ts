// lib/rules/education.ts
import { VisaQuestionnaireInput, VisaRecommendation, VisaOption } from "../types.ts";
import { evaluateAllVisas, chooseTopCandidate, chooseUpToTwoAlternatives } from "../utils/ranker.ts";
import { personalizeCandidate } from "../utils/personalization.ts";

/**
 * Evaluates education-related visa paths using the scoring engine.
 * 
 * This function:
 * 1. Evaluates ALL visas (not just education category) using the ranker
 * 2. Prioritizes education visas but includes cross-category alternatives
 * 3. Returns personalized recommendations with clear next steps
 * 4. Includes work visas as future pathways (e.g., post-study work options)
 */
export function evaluateEducationPath(input: VisaQuestionnaireInput): VisaRecommendation {
  // Evaluate all visas across all categories
  const allCandidates = evaluateAllVisas(input);
  
  // Filter candidates with reasonable scores
  const viableCandidates = allCandidates.filter(c => {
    // Always include education category visas with score >= 20
    if (c.category === "education" && c.score >= 20) return true;
    
    // Include high-scoring visas from other categories
    if (c.score >= 30) return true;
    
    // Include work visas with score >= 25 (post-study options)
    if (c.category === "work" && c.score >= 25) return true;
    
    return false;
  });

  // If no viable candidates, provide helpful fallback
  if (viableCandidates.length === 0) {
    return buildEducationFallback(input);
  }

  // Choose top candidate as recommended
  const topCandidate = chooseTopCandidate(viableCandidates);
  
  if (!topCandidate) {
    return buildEducationFallback(input);
  }

  // Choose up to 2 alternatives with category diversity
  const alternativeCandidates = chooseUpToTwoAlternatives(viableCandidates, topCandidate);

  // Personalize the recommended visa
  const recommended = personalizeCandidate(topCandidate);

  // Personalize alternatives
  const alternatives = alternativeCandidates.map(c => personalizeCandidate(c));

  // Generate contextual notes specific to education path
  const notes = buildEducationNotes(input, topCandidate, viableCandidates);

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
 * Builds education-specific contextual notes
 */
function buildEducationNotes(
  input: VisaQuestionnaireInput,
  topCandidate: any,
  allCandidates: any[]
): string[] {
  const notes: string[] = [];
  
  // University admission status
  if (!input.admitted && topCandidate.category === "education") {
    notes.push("💡 Secure university admission first. Use Uni-Assist or apply directly to universities.");
  }

  // Language requirements for study
  if (input.admitted) {
    const germanLevel = input.germanLevel?.toUpperCase();
    const englishLevel = input.englishLevel?.toUpperCase();
    
    if ((!germanLevel || ["A1", "A2"].includes(germanLevel)) && 
        (!englishLevel || ["A1", "A2", "B1"].includes(englishLevel))) {
      notes.push("🗣️ Most German universities require B2-C1 German OR B2-C1 English. Verify your program's language requirements.");
    }
  }

  // Blocked account requirement
  if (!input.proofFunds && topCandidate.code === "student") {
    notes.push("💰 You'll need a blocked account (Sperrkonto) with approximately €11,904/year (2024 rate) for living expenses.");
  }

  // Language course as preparatory step
  if (!input.admitted && !input.isLanguageCourse) {
    const hasLanguageCourse = allCandidates.slice(0, 3).some(c => c.code === "language_course");
    if (!hasLanguageCourse && input.germanLevel && ["A1", "A2", "B1"].includes(input.germanLevel.toUpperCase())) {
      notes.push("🎓 Consider a language course visa first to improve German while preparing university applications.");
    }
  }

  // Ausbildung pathway
  if (input.isAusbildung || (input.hasVocational && topCandidate.code === "ausbildung")) {
    notes.push("🛠️ Ausbildung is a 2-3 year vocational training with salary. Great pathway to work visa afterward!");
  }

  // Post-study work opportunities
  if (topCandidate.code === "student") {
    const workCandidates = allCandidates.filter(c => c.category === "work" && c.score >= 25);
    if (workCandidates.length > 0) {
      notes.push("🎯 After graduation, you can switch to a work visa. You'll get 18 months to find a job in your field.");
    } else {
      notes.push("🎯 After graduation, you'll be eligible for an 18-month job-seeker residence permit.");
    }
  }

  // Nursing/healthcare specific guidance
  if (input.isNursing) {
    notes.push("🏥 Nursing qualifications need recognition (Anerkennung). Contact your state's recognition office early.");
    notes.push("💡 Many hospitals offer integration programs that combine language training + adaptation courses.");
  }

  // Study field considerations
  if (input.studyField && input.admitted) {
    const stemFields = ["engineering", "computer", "mathematics", "physics", "chemistry", "biology"];
    const isStem = stemFields.some(field => input.studyField?.toLowerCase().includes(field));
    
    if (isStem) {
      notes.push("🔬 STEM graduates have excellent work visa prospects in Germany's shortage occupations.");
    }
  }

  // Financial planning
  if (topCandidate.category === "education" && !input.proofFunds) {
    notes.push("📊 Budget planning: Rent €400-800/month, Health insurance €110/month, Living expenses €600-900/month.");
  }

  // Part-time work permissions
  if (topCandidate.code === "student") {
    notes.push("💼 Student visa allows 120 full days OR 240 half days of work per year.");
  }

  // Application timeline
  if (input.programStart) {
    const startDate = new Date(input.programStart);
    const today = new Date();
    const monthsUntilStart = Math.floor((startDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24 * 30));
    
    if (monthsUntilStart < 3 && monthsUntilStart > 0) {
      notes.push(`⏰ Your program starts in ${monthsUntilStart} months. Apply for visa NOW - processing takes 6-12 weeks.`);
    } else if (monthsUntilStart >= 3) {
      notes.push(`📅 You have ${monthsUntilStart} months until program start. You can apply for visa 3 months before arrival.`);
    }
  }

  // Nationality-specific advantages
  if (input.nationality) {
    const visaFreeCheck = ["United States", "Canada", "Australia", "Japan", "Korea", "United Kingdom", "New Zealand"].some(
      country => input.nationality?.toLowerCase().includes(country.toLowerCase())
    );
    
    if (visaFreeCheck) {
      notes.push("✈️ Your nationality allows visa-free entry. You can enter Germany and apply for residence permit from within the country.");
    }
  }

  // Insurance requirement
  if (!input.hasInsurance && topCandidate.category === "education") {
    notes.push("🏥 Health insurance is mandatory. You can use TK, AOK, or other public insurance (~€110/month for students).");
  }

  return notes;
}

/**
 * Fallback recommendation when no viable candidates found
 */
function buildEducationFallback(input: VisaQuestionnaireInput): VisaRecommendation {
  const notes: string[] = [];
  
  // Provide actionable guidance based on what's missing
  if (!input.admitted && !input.isLanguageCourse && !input.isAusbildung) {
    notes.push("🎓 Step 1: Get admission to a German university or enroll in a language course.");
    notes.push("📚 Resources: Uni-Assist (uni-assist.de), DAAD (daad.de), Study-in-Germany (study-in-germany.de)");
  }
  
  if (!input.proofFunds) {
    notes.push("💰 Step 2: Open a blocked account (Sperrkonto) with ~€11,904 for living expenses.");
    notes.push("🏦 Providers: Fintiba, Expatrio, Deutsche Bank, Coracle");
  }
  
  const germanLevel = input.germanLevel?.toUpperCase();
  const englishLevel = input.englishLevel?.toUpperCase();
  
  if ((!germanLevel || ["A1", "A2"].includes(germanLevel)) && 
      (!englishLevel || ["A1", "A2"].includes(englishLevel))) {
    notes.push("🗣️ Step 3: Improve language skills. Most programs require B2-C1 German OR B2-C1 English.");
    notes.push("📖 German courses: Goethe Institut, VHS (Volkshochschule), language schools in your country");
  }

  notes.push("💡 Consider starting with a language course visa (easier requirements) while preparing your main study application.");

  return {
    recommended: {
      code: "education_preparation_needed",
      name: "Education Preparation Phase",
      summary: "You're on the path to studying in Germany! Follow these steps to strengthen your application. The education visa is very achievable with proper preparation.",
      notes
    },
    notes: [
      "Germany has over 400,000 international students - you can be one of them!",
      "Many universities have English-taught programs if German is a barrier.",
      "Public universities charge little to no tuition fees (€0-350/semester)."
    ]
  };
}