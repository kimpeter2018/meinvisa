// lib/utils/ranker.ts
import type { VisaCandidate, VisaQuestionnaireInput } from "../types.ts";
import { isVisaFreeNationality, isWorkingHolidayEligible } from "./nationality.ts";
import { compareLanguageLevel } from "./matchHelpers.ts";
import visasJson from "../constants/visas.json" with { type: "json" };

/**
 * Language level order for scoring
 */
const LANG_LEVELS = ["NONE", "A1", "A2", "B1", "B2", "C1", "C2"];

function langIndex(level?: string | null): number {
  if (!level) return 0;
  const idx = LANG_LEVELS.indexOf(level.toUpperCase());
  return idx === -1 ? 0 : idx;
}

/**
 * Normalizes raw score into 0..100 range
 */
function normalizeScore(raw: number, min = -100, max = 200): number {
  if (Number.isNaN(raw) || !isFinite(raw)) return 0;
  if (raw <= min) return 0;
  if (raw >= max) return 100;
  return Math.round(((raw - min) / (max - min)) * 100);
}

/**
 * Converts snake_case to camelCase
 */
function snakeToCamel(str: string): string {
  return str.replace(/_([a-z])/g, (_, c) => c.toUpperCase());
}

/**
 * Flatten visas.json into array of { code, meta, category }
 */
function loadAllVisas(): Array<{ code: string; meta: any; category: string }> {
  const list: Array<{ code: string; meta: any; category: string }> = [];
  
  for (const category of Object.keys(visasJson)) {
    const group = (visasJson as any)[category];
    if (!group || typeof group !== "object") continue;
    
    for (const code of Object.keys(group)) {
      const meta = group[code];
      if (!meta || typeof meta !== "object") continue;
      
      list.push({ code, meta, category });
    }
  }
  
  return list;
}

/**
 * Evaluate single criterion key (convention-based)
 * 
 * Returns:
 * - met: boolean (true if requirement is satisfied)
 * - partialFactor: 0..1 (partial credit for near-matches)
 * - disqualifyIfMissing: boolean (true if this is a strict requirement)
 * - reason: string (explanation for logging)
 * - detail: string (additional context)
 */
function evaluateCriterion(
  keyRaw: string,
  weight: number,
  meta: any,
  input: VisaQuestionnaireInput
): {
  met: boolean;
  partialFactor: number;
  disqualifyIfMissing: boolean;
  reason: string;
  detail?: string;
} {
  const result = {
    met: false,
    partialFactor: 0,
    disqualifyIfMissing: false,
    reason: "",
    detail: "",
  };

  let key = keyRaw;
  
  // Check if strict requirement (starts with "!")
  if (key.startsWith("!")) {
    result.disqualifyIfMissing = true;
    key = key.slice(1);
  }

  key = key.trim().toLowerCase();

  // ===== BOOLEAN FIELDS =====
  // Matches: has_*, is_*, personal_route_*
  if (key.startsWith("has_") || key.startsWith("is_") || key.startsWith("personal_route_")) {
    const inputKey = snakeToCamel(key);
    const val = (input as any)[inputKey];
    
    result.met = val === true;
    result.partialFactor = val ? 1 : 0;
    result.reason = `${inputKey} is ${val ? "present" : "missing"}`;
    
    return result;
  }

  // ===== DEGREE RECOGNIZED =====
  if (key === "has_anerkennung") {
    const val = input.hasAnerkennung;
    result.met = val === true;
    result.partialFactor = val ? 1 : 0;
    result.reason = `Degree recognition (Anerkennung) is ${val ? "completed" : "missing"}`;
    
    return result;
  }

  // ===== EXPERIENCE YEARS =====
  // Matches: experience_years_2+, experience_years_3+, etc.
  if (key.startsWith("experience_years")) {
    const match = key.match(/experience_years[_\s]*([0-9]+)\+?/);
    const required = match ? Number(match[1]) : 0;
    const have = (input.experienceYears ?? 0) as number;
    
    if (have >= required) {
      result.met = true;
      result.partialFactor = 1;
    } else if (required > 0 && have > 0) {
      // Partial credit proportional to have/required
      result.partialFactor = Math.min(1, have / required);
      result.met = result.partialFactor >= 0.8; // Consider "met" if >= 80%
    } else {
      result.partialFactor = 0;
      result.met = false;
    }
    
    result.reason = `Experience ${have}/${required} years`;
    result.detail = `Partial credit: ${(result.partialFactor * 100).toFixed(0)}%`;
    
    return result;
  }

  // ===== IT EXPERIENCE =====
  if (key.includes("it") && (key.includes("experience") || key.includes("exp"))) {
    const have = !!((input as any).itExperience ?? (input as any).it_experience);
    result.met = have;
    result.partialFactor = have ? 1 : 0;
    result.reason = `IT experience is ${have ? "present" : "absent"}`;
    
    return result;
  }

  // ===== SALARY CHECKS =====
  // Matches: salary_above_threshold, salary_above_50260, etc.
  if (key.includes("salary")) {
    const salary = (input.salary ?? 0) as number;
    
    // Try to find threshold from meta.thresholds
    let threshold: number | undefined;
    
    if (meta && meta.thresholds) {
      // Priority order for threshold selection
      threshold = 
        meta.thresholds.min_salary_general ??
        meta.thresholds.min_salary ??
        meta.thresholds.min_salary_shortage ??
        Object.values(meta.thresholds).find((v: any) => typeof v === "number") as number;
    }

    // If key contains a numeric part like salary_above_50260
    const numMatch = key.match(/salary_above_([0-9]+)/);
    if (!threshold && numMatch) {
      threshold = Number(numMatch[1]);
    }

    // Default threshold
    if (!threshold) {
      threshold = 0;
    }

    if (salary >= threshold) {
      result.met = true;
      result.partialFactor = 1;
      result.reason = `Salary €${salary} >= threshold €${threshold}`;
    } else if (salary > 0) {
      // Partial credit proportional to salary/threshold
      result.partialFactor = Math.min(1, salary / threshold);
      result.met = result.partialFactor >= 0.9; // Consider "met" if >= 90%
      result.reason = `Salary €${salary} vs threshold €${threshold} (${(result.partialFactor * 100).toFixed(0)}%)`;
    } else {
      result.met = false;
      result.partialFactor = 0;
      result.reason = `No salary information provided (threshold: €${threshold})`;
    }
    
    result.detail = `salary:${salary}, threshold:${threshold}`;
    
    return result;
  }

  // ===== LANGUAGE LEVEL CHECKS =====
  // Matches: german_level_B1+, english_level_B2+, etc.
  if (key.match(/_(german|english|language)_level_/) || key.match(/_level_[a-c][1-2]/i)) {
    // Extract required level (e.g., B1, A2, etc.)
    const match = key.match(/_(a1|a2|b1|b2|c1|c2)\+?$/i);
    const required = match ? match[1].toUpperCase() : undefined;
    
    // Determine which language
    let haveLevel: string | undefined;
    if (key.includes("german")) {
      haveLevel = input.germanLevel;
    } else if (key.includes("english")) {
      haveLevel = input.englishLevel;
    }
    
    const haveIdx = langIndex(haveLevel);
    const reqIdx = required ? langIndex(required) : 0;
    
    // Score based on level comparison
    if (haveIdx >= reqIdx && reqIdx > 0) {
      result.met = true;
      result.partialFactor = 1;
    } else if (reqIdx > 0 && haveIdx > 0) {
      // Partial credit for near levels
      result.partialFactor = Math.min(1, haveIdx / reqIdx);
      result.met = result.partialFactor >= 0.8; // Consider "met" if >= 80%
    } else {
      result.met = reqIdx === 0; // If no requirement, treat as met
      result.partialFactor = reqIdx === 0 ? 1 : 0;
    }
    
    const langType = key.includes("german") ? "German" : 
                     key.includes("english") ? "English" : "Language";
    result.reason = `${langType} level ${haveLevel ?? "NONE"} vs required ${required ?? "any"}`;
    result.detail = `Partial credit: ${(result.partialFactor * 100).toFixed(0)}%`;
    
    return result;
  }

  // ===== AGE RANGE =====
  // Matches: age_between_18_26, age_between_18_30, etc.
  if (key.startsWith("age_between")) {
    const match = key.match(/age_between_(\d+)_(\d+)/);
    if (match && input.age) {
      const minAge = Number(match[1]);
      const maxAge = Number(match[2]);
      const age = input.age;
      
      result.met = age >= minAge && age <= maxAge;
      result.partialFactor = result.met ? 1 : 0;
      result.reason = `Age ${age} ${result.met ? "within" : "outside"} range ${minAge}-${maxAge}`;
      
      return result;
    }
  }

  // ===== NATIONALITY CHECKS =====
  // Matches: nationality_working_holiday
  if (key.startsWith("nationality_")) {
    const nationality = input.nationality;
    
    if (key.includes("working_holiday")) {
      const eligible = isWorkingHolidayEligible(nationality);
      result.met = eligible;
      result.partialFactor = eligible ? 1 : 0;
      result.reason = `${nationality ?? "Unknown nationality"} ${eligible ? "is" : "is not"} eligible for working holiday`;
      
      return result;
    }
    
    if (key.includes("visa_free")) {
      const eligible = isVisaFreeNationality(nationality);
      result.met = eligible;
      result.partialFactor = eligible ? 1 : 0;
      result.reason = `${nationality ?? "Unknown nationality"} ${eligible ? "is" : "is not"} visa-free`;
      
      return result;
    }
  }

  // ===== PROOF OF FUNDS =====
  if (key === "proof_funds") {
    const val = input.proofFunds;
    result.met = val === true;
    result.partialFactor = val ? 1 : 0;
    result.reason = `Proof of funds is ${val ? "available" : "missing"}`;
    
    return result;
  }

  // ===== GENERIC FALLBACK =====
  // Try to read input field with same name (snake_case → camelCase)
  const inputKey = snakeToCamel(key);
  const val = (input as any)[inputKey];
  
  if (typeof val === "boolean") {
    result.met = val === true;
    result.partialFactor = val ? 1 : 0;
    result.reason = `${inputKey} boolean is ${val}`;
    return result;
  }
  
  if (typeof val === "number") {
    // Any positive number counts as met
    result.met = val > 0;
    result.partialFactor = Math.min(1, val / 10); // Arbitrary partial metric
    result.reason = `${inputKey} numeric ${val}`;
    return result;
  }

  // Unknown criterion → treat as optional missing
  result.met = false;
  result.partialFactor = 0;
  result.reason = `Unknown criterion "${keyRaw}" (treated as optional missing)`;
  
  return result;
}

/**
 * Compute score for a given visa meta + user input
 * 
 * Returns VisaCandidate object with:
 * - score: normalized 0-100
 * - matched: list of satisfied criteria
 * - missing: list of unsatisfied criteria with severity
 * - disqualify: true if strict requirements are missing
 * - reasons: detailed scoring breakdown (for debugging)
 */
export function computeScoreForVisa(
  metaContainer: { code: string; meta: any; category: string },
  input: VisaQuestionnaireInput
): VisaCandidate {
  const { code, meta, category } = metaContainer;
  
  // Start with base priority
  const rawBase = (meta.basePriority ?? 50) as number;
  let rawScore = rawBase;
  
  const matched: string[] = [];
  const missing: Array<{ key: string; severity: "critical" | "important" | "optional"; detail?: string }> = [];
  const reasons: string[] = [];
  let disqualify = false;

  const criteria = meta.criteria ?? {};

  // Evaluate each criterion
  for (const keyRaw of Object.keys(criteria)) {
    const weight = Number(criteria[keyRaw] ?? 0);
    const evalRes = evaluateCriterion(keyRaw, weight, meta, input);

    if (evalRes.met) {
      // Full or partial match
      const score = weight * (evalRes.partialFactor || 1);
      rawScore += score;
      matched.push(keyRaw);
      reasons.push(`✓ ${keyRaw}: +${score.toFixed(1)} (${evalRes.reason})`);
    } else {
      // Missing requirement
      const penaltyBase = evalRes.disqualifyIfMissing ? 100 : Math.max(6, Math.round(weight * 0.8));
      const penalty = penaltyBase;
      
      rawScore -= penalty;
      
      const severity: "critical" | "important" | "optional" = 
        evalRes.disqualifyIfMissing ? "critical" : 
        weight >= 20 ? "important" : "optional";
      
      missing.push({ 
        key: keyRaw, 
        severity, 
        detail: evalRes.reason 
      });
      
      reasons.push(`✗ ${keyRaw}: -${penalty} [${severity}] (${evalRes.reason})`);
      
      if (evalRes.disqualifyIfMissing) {
        disqualify = true;
      }
    }
  }

  // ===== CONTEXT MODIFIERS (BONUSES) =====
  
  // Visa-free nationality + can apply in-country
  if (input.nationality && meta.canApplyInCountry) {
    if (isVisaFreeNationality(input.nationality)) {
      const matchesCountry = meta.canApplyInCountry.some((c: string) => 
        input.nationality?.toLowerCase().includes(c.toLowerCase())
      );
      
      if (matchesCountry) {
        rawScore += 5;
        reasons.push(`✓ Visa-free nationality + in-country application: +5`);
      }
    }
  }

  // Research visa + host agreement bonus
  if ((category === "specialized" || category === "research") && input.hasHostAgreement) {
    rawScore += 15;
    reasons.push(`✓ Host agreement present: +15`);
  }

  // Work visa + job offer bonus
  if (category === "work" && input.hasJobOffer) {
    rawScore += 15;
    reasons.push(`✓ Job offer present: +15`);
  }

  // Student visa + admission bonus
  if (category === "education" && input.admitted) {
    rawScore += 10;
    reasons.push(`✓ University admission: +10`);
  }

  // Family reunion + family in Germany bonus
  if (category === "personal" && input.hasFamilyInGermany) {
    rawScore += 10;
    reasons.push(`✓ Family in Germany: +10`);
  }

  // Working holiday eligibility bonus
  if (code === "working_holiday" && input.nationality) {
    if (isWorkingHolidayEligible(input.nationality)) {
      rawScore += 20;
      reasons.push(`✓ Working Holiday eligible nationality: +20`);
    }
  }

  // Language proficiency bonus (cross-category)
  if (input.germanLevel) {
    const level = input.germanLevel.toUpperCase();
    if (["B2", "C1", "C2"].includes(level)) {
      rawScore += 5;
      reasons.push(`✓ High German proficiency (${level}): +5`);
    }
  }

  // Normalize to 0-100 scale
  const finalScore = normalizeScore(rawScore, -100, 200);

  return {
    code,
    name: meta.name ?? code,
    category,
    meta,
    score: finalScore,
    matched,
    missing,
    disqualify,
    reasons,
  };
}

/**
 * Evaluate all visas and return sorted candidates (descending by score)
 */
export function evaluateAllVisas(input: VisaQuestionnaireInput): VisaCandidate[] {
  const rawList = loadAllVisas();
  const candidates: VisaCandidate[] = [];

  for (const m of rawList) {
    const candidate = computeScoreForVisa(m, input);
    
    // Add input as context for personalization
    candidate.context = {
      ...input,
      nationality: input.nationality,
      salary: input.salary,
      degreeField: input.degreeField || "your field",
      experienceYears: input.experienceYears || 0,
      studyField: input.studyField || "your program",
      age: input.age,
      germanLevel: input.germanLevel,
      performanceCount: input.performanceCount || 0,
      businessSector: input.businessSector || "your industry"
    };
    
    // Include if not disqualified OR if conditionally allowed
    const allowConditional = !!(m.meta?.allowConditional === true);
    if (!candidate.disqualify || allowConditional) {
      candidates.push(candidate);
    }
  }

  // Sort by score (descending)
  candidates.sort((a, b) => b.score - a.score);
  
  return candidates;
}

/**
 * Choose top candidate as recommended (highest score)
 */
export function chooseTopCandidate(candidates: VisaCandidate[]): VisaCandidate | null {
  return candidates.length > 0 ? candidates[0] : null;
}

/**
 * Choose up to two alternatives (exclude recommended)
 * 
 * Strategy:
 * 1. Prioritize category diversity (different from recommended)
 * 2. Fall back to same category if no diverse options with good scores
 * 3. Always return highest scoring alternatives
 */
export function chooseUpToTwoAlternatives(
  candidates: VisaCandidate[],
  recommended?: VisaCandidate
): VisaCandidate[] {
  const alts: VisaCandidate[] = [];
  
  // Filter out the recommended visa
  const available = candidates.filter(
    c => !recommended || c.code !== recommended.code
  );
  
  if (available.length === 0) return [];
  
  // First pass: try to get diverse categories
  for (const candidate of available) {
    // Skip if we already have this category
    if (alts.length > 0 && alts.some(a => a.category === candidate.category)) {
      continue;
    }
    
    // Skip if same category as recommended and we haven't filled slots yet
    if (recommended && candidate.category === recommended.category && alts.length < 2) {
      continue;
    }
    
    alts.push(candidate);
    if (alts.length >= 2) break;
  }
  
  // Second pass: if we still need more alternatives, add highest scoring ones
  if (alts.length < 2) {
    for (const candidate of available) {
      if (alts.some(a => a.code === candidate.code)) continue;
      
      alts.push(candidate);
      if (alts.length >= 2) break;
    }
  }
  
  return alts;
}