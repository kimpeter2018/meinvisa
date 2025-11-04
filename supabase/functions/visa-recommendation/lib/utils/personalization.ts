// lib/utils/personalization.ts
import { VisaCandidate } from "../types.ts";

/**
 * Confidence label derived from normalized score
 * 
 * High: 85+ → Very likely to qualify
 * Medium: 70-84 → Good chance with some improvements
 * Low: 50-69 → Possible but needs work
 * Very Low: <50 → Significant gaps to address
 */
function confidenceLabel(score: number): string {
  if (score >= 85) return "High";
  if (score >= 70) return "Medium";
  if (score >= 50) return "Low";
  return "Very Low";
}

/**
 * Simple templating function that replaces {{field}} with values from context
 * 
 * Supports:
 * - {{field}} → context.field
 * - {{field|default}} → context.field or "default" if undefined
 * 
 * Examples:
 * - "With your {{degreeField}} degree..." → "With your Computer Science degree..."
 * - "€{{salary}} offer" → "€65000 offer"
 * - "{{experienceYears}} years of experience" → "4 years of experience"
 */
function fillTemplate(template: string, context: Record<string, any>): string {
  return template.replace(/\{\{(.*?)\}\}/g, (match, key) => {
    // Support default values: {{field|default}}
    const [fieldName, defaultValue] = key.trim().split("|");
    const val = context[fieldName.trim()];
    
    if (val !== undefined && val !== null && val !== "") {
      return String(val);
    }
    
    return defaultValue !== undefined ? defaultValue.trim() : "(unspecified)";
  });
}

/**
 * Converts matched/missing requirement lists into user-friendly descriptions
 * 
 * Returns:
 * - met: Array of human-readable satisfied requirements
 * - missing: Array of human-readable missing requirements with severity tags
 */
function buildRequirementLists(candidate: VisaCandidate): {
  met: string[];
  missing: string[];
} {
  // Convert matched criteria keys to readable labels
  const met = candidate.matched.map((k) => readableLabel(k));

  // Convert missing criteria to readable labels with severity indicators
  const missing = candidate.missing.map((m) => {
    const base = readableLabel(m.key);
    const extra = m.detail ? ` – ${m.detail}` : "";
    const tag = m.severity === "critical" ? " ⚠️ REQUIRED" :
                m.severity === "important" ? " ⚡ Important" : "";
    
    return `${base}${tag}${extra}`;
  });

  return { met, missing };
}

/**
 * Utility for mapping technical requirement keys to friendly labels
 * 
 * Supports:
 * - Boolean fields: has_*, is_*
 * - Language levels: german_level_*, english_level_*
 * - Experience: experience_years_*
 * - Salary: salary_above_*
 * - Age: age_between_*
 * - Personal routes: personal_route_*
 */
function readableLabel(key: string): string {
  // Remove strict marker (!) if present
  const cleanKey = key.startsWith("!") ? key.slice(1) : key;
  
  // Predefined dictionary for common keys
  const dictionary: Record<string, string> = {
    // Boolean fields
    "has_job_offer": "Valid job offer from German employer",
    "has_degree": "University degree",
    "degree_recognized": "Degree recognition (Anerkennung)",
    "has_anerkennung": "Degree recognition (Anerkennung)",
    "proof_funds": "Proof of sufficient funds",
    "has_insurance": "Health insurance coverage",
    "has_accommodation": "Housing arrangement",
    "has_host_agreement": "Hosting agreement from institution",
    "has_host_contract": "Contract with host organization",
    "research_funded": "Research funding secured",
    "has_performance": "Performance contracts/invitations",
    "has_family_in_germany": "Family member with legal residence in Germany",
    "has_vocational": "Vocational qualification",
    "has_business_plan": "Business plan",
    "has_license": "Professional license",
    
    // Education
    "admitted": "University admission letter",
    "is_language_course": "Enrolled in language course",
    "fulltime_german": "Full-time German course (18+ hrs/week)",
    "is_ausbildung": "Vocational training contract (Ausbildung)",
    "is_nursing": "Nursing qualification",
    
    // IT/Tech
    "is_it_field": "IT/Software profession",
    "it_experience": "Proven IT work experience",
    
    // Personal routes
    "personal_route_au_pair": "Au pair program participation",
    "personal_route_volunteer": "Volunteer program participation",
    
    // Specialized
    "is_language_teacher": "Language teaching qualification",
    "is_athlete": "Professional athlete status",
    "is_esports": "Professional esports player status",
    "is_self_employed": "Self-employment/freelance intent",
    "is_startup": "Startup business plan",
    
    // Nationality
    "nationality_working_holiday": "Working holiday eligible nationality",
  };
  
  // Check dictionary first
  if (dictionary[cleanKey]) {
    return dictionary[cleanKey];
  }
  
  // Handle language levels
  if (cleanKey.match(/german_level_([a-c][1-2])\+?/i)) {
    const level = cleanKey.match(/([a-c][1-2])\+?/i)?.[1].toUpperCase();
    return `German proficiency (${level} or higher)`;
  }
  
  if (cleanKey.match(/english_level_([a-c][1-2])\+?/i)) {
    const level = cleanKey.match(/([a-c][1-2])\+?/i)?.[1].toUpperCase();
    return `English proficiency (${level} or higher)`;
  }
  
  // Handle experience years
  if (cleanKey.match(/experience_years_(\d+)\+?/)) {
    const years = cleanKey.match(/(\d+)/)?.[1];
    return `${years}+ years of work experience`;
  }
  
  // Handle salary requirements
  if (cleanKey.includes("salary_above")) {
    const amount = cleanKey.match(/(\d+)/)?.[1];
    return amount ? `Minimum salary €${amount}` : "Minimum salary requirement";
  }
  
  // Handle age ranges
  if (cleanKey.match(/age_between_(\d+)_(\d+)/)) {
    const match = cleanKey.match(/age_between_(\d+)_(\d+)/);
    return `Age ${match?.[1]}-${match?.[2]} years`;
  }
  
  // Fallback: convert snake_case to readable text
  return cleanKey
    .replace(/_/g, " ")
    .replace(/\b\w/g, (c) => c.toUpperCase());
}

/**
 * Generates contextual notes based on candidate and missing requirements
 * 
 * Provides:
 * - Application process hints
 * - Missing requirement guidance
 * - Related visa suggestions
 * - Timeline expectations
 */
function generateNotes(candidate: VisaCandidate): string[] {
  const { meta, missing, context, category } = candidate;
  const notes: string[] = [];

  // Nationality advantages
  const nationality = context?.nationality;
  if (nationality && meta.canApplyInCountry) {
    const canApplyInCountry = Array.isArray(meta.canApplyInCountry) &&
      meta.canApplyInCountry.some((c: string) => 
        nationality.toLowerCase().includes(c.toLowerCase())
      );
    
    if (canApplyInCountry) {
      notes.push("✈️ Your nationality allows visa-free entry - you can apply for residence permit after arriving in Germany.");
    }
  }

  // German language guidance
  if (missing.some((m) => m.key.includes("german_level"))) {
    notes.push("🗣️ German language improvement will strengthen your application. Consider starting lessons now.");
  }

  // Degree recognition guidance
  if (missing.some((m) => m.key.includes("degree") || m.key.includes("anerkennung"))) {
    if (context?.hasDegree && !context?.hasAnerkennung) {
      notes.push("🎓 Get your degree recognized through Anabin database or ZAB (Central Office for Foreign Education).");
    }
  }

  // Job offer guidance
  if (missing.some((m) => m.key.includes("job_offer"))) {
    notes.push("💼 Focus on securing a job offer. Use platforms: LinkedIn, XING, Make it in Germany, StepStone.");
  }

  // Financial guidance
  if (missing.some((m) => m.key.includes("funds"))) {
    if (category === "education") {
      notes.push("💰 Open a blocked account (Sperrkonto) with approximately €11,904/year. Providers: Fintiba, Expatrio, Coracle.");
    } else {
      notes.push("💰 Prepare proof of sufficient funds (bank statements, sponsorship letter, or income proof).");
    }
  }

  // Insurance guidance
  if (missing.some((m) => m.key.includes("insurance"))) {
    notes.push("🏥 Arrange health insurance before application. Options: Public (TK, AOK) or private insurance.");
  }

  // Family considerations
  const hasFamily = context?.hasFamilyInGermany;
  if (hasFamily && category !== "personal") {
    notes.push("👨‍👩‍👧‍👦 Since you have family in Germany, family reunion visa might also be an option.");
  }

  // Research/academic notes
  if (category === "specialized" && meta.code === "researcher") {
    notes.push("🔬 Contact German research institutions directly. Resources: EURAXESS, DAAD, Alexander von Humboldt Foundation.");
  }

  // Work visa transition notes
  if (category === "education") {
    notes.push("🎯 After graduation, you'll be eligible for an 18-month job-seeker permit to find employment in your field.");
  }

  // Timeline expectations
  if (category === "work" && context?.hasJobOffer) {
    notes.push("⏱️ Work visa processing typically takes 6-12 weeks. Start application as soon as you have all documents.");
  }

  return notes;
}

/**
 * Generates next steps based on missing requirements
 * 
 * Prioritizes by severity:
 * 1. Critical (REQUIRED) items first
 * 2. Important items second  
 * 3. Optional items last
 */
function generateNextSteps(candidate: VisaCandidate): string[] {
  const steps: string[] = [];
  
  // Sort missing by severity
  const critical = candidate.missing.filter(m => m.severity === "critical");
  const important = candidate.missing.filter(m => m.severity === "important");
  const optional = candidate.missing.filter(m => m.severity === "optional");
  
  let stepNum = 1;
  
  // Critical requirements
  if (critical.length > 0) {
    steps.push("🚨 Critical Requirements:");
    critical.forEach(m => {
      steps.push(`   ${stepNum}. ${readableLabel(m.key)}`);
      stepNum++;
    });
  }
  
  // Important requirements
  if (important.length > 0) {
    steps.push("⚡ Important Requirements:");
    important.forEach(m => {
      steps.push(`   ${stepNum}. ${readableLabel(m.key)}`);
      stepNum++;
    });
  }
  
  // Optional improvements
  if (optional.length > 0 && optional.length <= 3) {
    steps.push("💡 Optional Improvements:");
    optional.forEach(m => {
      steps.push(`   • ${readableLabel(m.key)}`);
    });
  }
  
  return steps;
}

/**
 * Main export: converts a VisaCandidate into a personalized recommendation
 * 
 * Returns object with:
 * - code: visa code
 * - name: visa name
 * - confidence: High/Medium/Low/Very Low
 * - summary: personalized explanation
 * - requirements: { met: string[], missing: string[] }
 * - notes: contextual guidance
 * - nextSteps: prioritized action items
 */
export function personalizeCandidate(candidate: VisaCandidate) {
  const { meta, score, context } = candidate;

  // Calculate confidence label
  const confidence = confidenceLabel(score);
  
  // Fill template with user's actual data
  const summary = fillTemplate(meta.explanationTemplate || "{{name}}", {
    ...context,
    name: meta.name,
    // Ensure common fields have defaults
    salary: context?.salary || "unspecified",
    degreeField: context?.degreeField || "your field",
    nationality: context?.nationality || "your country",
    experienceYears: context?.experienceYears || 0,
    studyField: context?.studyField || "your program",
    age: context?.age || "your age",
    performanceCount: context?.performanceCount || 0,
    businessSector: context?.businessSector || "your industry"
  });

  // Build requirement lists
  const { met, missing } = buildRequirementLists(candidate);
  
  // Generate contextual notes
  const notes = generateNotes(candidate);
  
  // Generate next steps (if there are missing requirements)
  const nextSteps = missing.length > 0 ? generateNextSteps(candidate) : undefined;

  return {
    code: candidate.code,
    name: meta.name,
    confidence,
    summary,
    score, // Include raw score for debugging
    requirements: { met, missing },
    notes,
    nextSteps
  };
}