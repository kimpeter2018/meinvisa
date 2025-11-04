// lib/rules/specialized.ts
// Renamed from "research.ts" to better reflect: Research, Culture, Arts, Sports, Special Professions

import { VisaQuestionnaireInput, VisaRecommendation, VisaOption } from "../types.ts";
import { evaluateAllVisas, chooseTopCandidate, chooseUpToTwoAlternatives } from "../utils/ranker.ts";
import { personalizeCandidate } from "../utils/personalization.ts";

/**
 * Evaluates specialized visa paths including:
 * - Academic research
 * - Arts and culture (performers, artists, musicians)
 * - Professional sports and esports
 * - Language teachers
 * - Freelancers and self-employed
 * 
 * This function:
 * 1. Evaluates ALL visas using the scoring engine
 * 2. Prioritizes specialized visas but includes work/education alternatives
 * 3. Provides detailed guidance for niche professions
 * 4. Includes cross-category pathways (e.g., researcher → Blue Card transition)
 */
export function evaluateSpecializedPath(input: VisaQuestionnaireInput): VisaRecommendation {
  // Evaluate all visas across all categories
  const allCandidates = evaluateAllVisas(input);
  
  // Filter candidates with reasonable scores
  const viableCandidates = allCandidates.filter(c => {
    // Always include specialized category visas with score >= 15
    if (c.category === "specialized" && c.score >= 15) return true;
    
    // Include high-scoring visas from other categories
    if (c.score >= 30) return true;
    
    // Include work visas with score >= 25 (transition options)
    if (c.category === "work" && c.score >= 25) return true;
    
    return false;
  });

  // If no viable candidates, provide helpful fallback
  if (viableCandidates.length === 0) {
    return buildSpecializedFallback(input);
  }

  // Choose top candidate as recommended
  const topCandidate = chooseTopCandidate(viableCandidates);
  
  if (!topCandidate) {
    return buildSpecializedFallback(input);
  }

  // Choose up to 2 alternatives with category diversity
  const alternativeCandidates = chooseUpToTwoAlternatives(viableCandidates, topCandidate);

  // Personalize the recommended visa
  const recommended = personalizeCandidate(topCandidate);

  // Personalize alternatives
  const alternatives = alternativeCandidates.map(c => personalizeCandidate(c));

  // Generate contextual notes specific to specialized paths
  const notes = buildSpecializedNotes(input, topCandidate, viableCandidates);

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
 * Builds specialized-path contextual notes
 */
function buildSpecializedNotes(
  input: VisaQuestionnaireInput,
  topCandidate: any,
  allCandidates: any[]
): string[] {
  const notes: string[] = [];
  
  // Academic Research specific guidance
  if (topCandidate.code === "researcher" || input.hasHostAgreement) {
    notes.push("🔬 Research visa requires a hosting agreement signed by both you and the German institution.");
    
    if (input.researchFunded) {
      notes.push("💰 Your funded research position makes the visa process much smoother.");
    } else {
      notes.push("💰 Ensure you have proof of funding (scholarship, institutional funding, or personal funds).");
    }
    
    notes.push("🎓 After 2 years of research, you may be eligible for an EU Blue Card or permanent residence.");
    notes.push("📚 Resources: EURAXESS Germany, Alexander von Humboldt Foundation, DAAD research fellowships");
  }

  // Arts, Culture, and Performance
  if (input.hasPerformance || topCandidate.code === "artist") {
    notes.push("🎭 Performance visa requires: detailed CV, portfolio, and contracts/invitations from German venues.");
    
    if (input.performanceCount && input.performanceCount >= 3) {
      notes.push(`🌟 Your ${input.performanceCount} scheduled performances strengthen your application significantly.`);
    }
    
    notes.push("🎨 You can work as freelance artist (Freiberufler) with this visa - register with Finanzamt.");
    notes.push("💡 Join KSK (Künstlersozialkasse) for subsidized health insurance and pension (if earning >€3,900/year).");
    notes.push("🏛️ Network with: Goethe Institut, local cultural centers, artist collectives");
  }

  // Professional Sports and Esports
  if (input.isAthlete || input.isEsports) {
    const sportType = input.isEsports ? "esports" : "sports";
    
    notes.push(`⚽ Professional ${sportType} visa requires a contract with a German club/organization.`);
    notes.push("🏆 Your club must be officially registered (e.V. = eingetragener Verein or commercial entity).");
    
    if (input.isEsports) {
      notes.push("🎮 Germany recognizes esports as legitimate profession. Major cities: Berlin, Hamburg, Cologne.");
      notes.push("💼 Esports visa precedents exist - work with immigration lawyer familiar with esports cases.");
    } else {
      notes.push("🥇 Professional athletes in major sports (football, basketball, handball) have streamlined processing.");
    }
    
    notes.push("⏱️ Contract duration typically matches visa duration (1-3 years, renewable).");
  }

  // Language Teachers
  if (input.isLanguageTeacher) {
    notes.push("📚 Language teachers need: recognized teaching qualification + employment contract from German school/institution.");
    notes.push("🌍 Native speaker status is advantageous but not always required with proper qualifications.");
    notes.push("🏫 Employers: Goethe Institut, VHS (Volkshochschule), international schools, universities");
    notes.push("💡 Consider getting your teaching credentials recognized through KMK (Kultusministerkonferenz).");
  }

  // Freelance/Self-Employment considerations
  if (input.isSelfEmployed || input.isStartup) {
    const workCandidates = allCandidates.filter(c => 
      c.code === "self_employment" || c.code === "freelance"
    );
    
    if (workCandidates.length > 0) {
      notes.push("💼 Freelance visa (Freiberufler) requires: viable business plan, proof of clients/contracts, professional qualifications.");
      notes.push("📊 Business plan should show: market analysis, financial projections, contribution to German economy.");
      
      if (input.hasFunding) {
        notes.push("💰 Having secured funding strengthens your self-employment visa application.");
      }
      
      if (input.businessSector) {
        const techSectors = ["software", "tech", "it", "digital"];
        const isTech = techSectors.some(s => input.businessSector?.toLowerCase().includes(s));
        
        if (isTech) {
          notes.push("🚀 Tech startups: Check out German Accelerator, Factory Berlin, startup hubs in Berlin/Munich.");
        }
      }
      
      notes.push("🏦 You'll need German business bank account + registration with Finanzamt and IHK/HWK.");
    }
  }

  // Transition to permanent residence
  if (topCandidate.category === "specialized") {
    notes.push("🏡 After 2-4 years, you may qualify for permanent residence (Niederlassungserlaubnis).");
    notes.push("📈 Keep records of tax returns, health insurance, and German language progress.");
  }

  // Cross-category opportunities
  const workCandidates = allCandidates.filter(c => c.category === "work" && c.score >= 40);
  if (workCandidates.length > 0 && topCandidate.category === "specialized") {
    notes.push("🔄 Your qualifications may also qualify you for standard work visas - consider multiple pathways.");
  }

  // Health insurance (universal requirement)
  if (!input.hasInsurance) {
    notes.push("🏥 Health insurance is mandatory. Options: Public (TK, AOK) ~€200-400/month OR Private (if self-employed).");
  }

  // Accommodation
  if (!input.hasAccommodation) {
    notes.push("🏠 Secure housing before visa application. Use: WG-Gesucht, ImmobilienScout24, local Facebook groups.");
  }

  // German language considerations
  const germanLevel = input.germanLevel?.toUpperCase();
  
  if (!germanLevel || ["A1", "A2"].includes(germanLevel)) {
    notes.push("🗣️ While not always required for specialized visas, B1+ German significantly helps with integration and administrative tasks.");
  }

  // Networking and professional communities
  if (topCandidate.category === "specialized") {
    notes.push("🤝 Join professional networks: Meetup.com groups, LinkedIn communities, expat associations.");
    notes.push("📍 Major hubs: Berlin (arts/tech/research), Munich (research/sports), Hamburg (culture/media).");
  }

  return notes;
}

/**
 * Fallback recommendation when no viable candidates found
 */
function buildSpecializedFallback(input: VisaQuestionnaireInput): VisaRecommendation {
  const notes: string[] = [];
  
  // Identify the specialized path user is interested in
  let pathType = "specialized";
  if (input.hasHostAgreement || input.researchFunded) pathType = "research";
  else if (input.hasPerformance || input.isLanguageTeacher) pathType = "arts/culture";
  else if (input.isAthlete || input.isEsports) pathType = "sports";
  else if (input.isSelfEmployed || input.isStartup) pathType = "freelance/startup";
  
  notes.push(`🎯 You're pursuing a ${pathType} visa pathway. Here's what you need:`);
  
  // Research path guidance
  if (pathType === "research") {
    if (!input.hasHostAgreement) {
      notes.push("📋 Step 1: Secure a hosting agreement from a German research institution.");
      notes.push("🔍 Search: EURAXESS, DAAD, Max Planck Society, Helmholtz Association, Fraunhofer");
    }
    
    if (!input.researchFunded) {
      notes.push("💰 Step 2: Secure funding (scholarship, institutional, or self-funded with proof).");
    }
    
    notes.push("📄 Step 3: Prepare documents - CV, publications, research proposal, recommendation letters.");
  }
  
  // Arts/Culture path guidance
  else if (pathType === "arts/culture") {
    notes.push("🎨 Step 1: Build strong portfolio showcasing your work (photos, videos, press, reviews).");
    notes.push("📜 Step 2: Secure contracts or invitations from German venues/institutions.");
    notes.push("💼 Step 3: Prepare detailed CV highlighting performances, exhibitions, awards, teaching.");
    notes.push("🎭 Step 4: Get recommendation letters from recognized figures in your field.");
  }
  
  // Sports path guidance
  else if (pathType === "sports") {
    notes.push("🏆 Step 1: Secure a contract with a German sports club or esports organization.");
    notes.push("📊 Step 2: Club must provide: registration proof, financial viability, salary details.");
    notes.push("🏅 Step 3: Gather evidence of professional status (competition results, rankings, press).");
  }
  
  // Freelance/Startup guidance
  else if (pathType === "freelance/startup") {
    notes.push("💡 Step 1: Develop comprehensive business plan (market analysis, financials, competitive advantage).");
    notes.push("📝 Step 2: Secure client letters of intent or contracts demonstrating demand.");
    notes.push("💰 Step 3: Show proof of funds (typically €20,000+ in business capital).");
    notes.push("🎓 Step 4: Document your professional qualifications and experience.");
  }
  
  // Generic next steps
  else {
    notes.push("📋 Step 1: Clarify your specific profession and visa category.");
    notes.push("💼 Step 2: Gather contracts, invitations, or agreements from German partners.");
    notes.push("📄 Step 3: Prepare comprehensive documentation of qualifications and experience.");
  }

  // Common requirements
  notes.push("🏥 Universal: Secure health insurance (mandatory for all visa types).");
  notes.push("🏠 Universal: Find accommodation (Mietvertrag or reservation for initial stay).");
  notes.push("💰 Universal: Proof of financial means (income, savings, or sponsorship).");

  return {
    recommended: {
      code: "specialized_preparation_needed",
      name: "Specialized Visa Preparation Phase",
      summary: `You're on a ${pathType} visa pathway - a niche but very achievable route with proper preparation. Germany values specialized talent and has successful precedents for your profession.`,
      notes
    },
    notes: [
      "Specialized visas often require more documentation but offer unique opportunities.",
      "Consider consulting an immigration lawyer familiar with your specific profession.",
      "Many specialized visa holders transition to permanent residence within 2-4 years."
    ]
  };
}