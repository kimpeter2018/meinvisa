// lib/utils/ranker.ts
import type { VisaCandidate, VisaQuestionnaireInput } from "../types.ts";
import { isVisaFreeNationality } from "../utils/nationality.ts";
import visasJson from "../constants/visas.json" with { type: "json" };

/**
 * Helpers and constants
 */
const LANG_LEVELS = ["NONE", "A1", "A2", "B1", "B2", "C1", "C2"];

function langIndex(level?: string | null) {
  if (!level) return 0;
  const idx = LANG_LEVELS.indexOf(level.toUpperCase());
  return idx === -1 ? 0 : idx;
}

/**
 * Normalizes score into 0..100
 */
function normalizeScore(raw: number, min = 0, max = 100) {
  if (Number.isNaN(raw) || !isFinite(raw)) return 0;
  if (raw <= min) return 0;
  if (raw >= max) return 100;
  return Math.round(((raw - min) / (max - min)) * 100);
}

/**
 * Flatten visas.json into array of { code, meta, category }
 */
function loadAllVisas() {
  const list: Array<{ code: string; meta: any; category: string }> = [];
  for (const category of Object.keys(visasJson)) {
    const group = (visasJson as any)[category];
    if (!group) continue;
    for (const code of Object.keys(group)) {
      const meta = group[code];
      list.push({ code, meta, category });
    }
  }
  return list;
}

/**
 * Evaluate single criterion key (convention-based)
 *
 * Supported convention examples (keys that might appear in meta.criteria):
 * - "has_degree" -> input.hasDegree boolean
 * - "degree_recognized" -> input.hasAnerkennung boolean
 * - "has_job_offer" -> input.hasJobOffer boolean
 * - "experience_years_2+" -> input.experienceYears >= 2
 * - "experience_years_3+" -> input.experienceYears >= 3
 * - "salary_above_threshold" -> uses meta.thresholds.* (if available), or 'salary_above_50260' numeric in key
 * - "is_it_field" -> input.isItField boolean
 * - "it_experience" -> input.it_experience or input.itExperience boolean
 * - "german_level_B1+" -> language minimum check
 *
 * Special rule for strict requirement:
 * If criterion key starts with "!" (example: "!has_job_offer"), treat it as strict => missing => disqualify
 */
function evaluateCriterion(
  keyRaw: string,
  weight: number,
  meta: any,
  input: VisaQuestionnaireInput
) {
  const result = {
    met: false,
    partialFactor: 0, // 0..1 partial credit
    disqualifyIfMissing: false,
    reason: "",
    detail: "",
  };

  let key = keyRaw;
  if (key.startsWith("!")) {
    result.disqualifyIfMissing = true;
    key = key.slice(1);
  }

  key = key.trim().toLowerCase();

  // boolean fields
  if (key.startsWith("has_") || key.startsWith("is_") || key.startsWith("personal_route_")) {
    // map from snake-case to camelCase variations in input
    const inputKey = key.replace(/_([a-z])/g, (_, c) => c.toUpperCase());
    const val = (input as any)[inputKey];
    if (val === true) {
      result.met = true;
      result.partialFactor = 1;
    } else {
      result.met = false;
      result.partialFactor = 0;
    }
    result.reason = `${inputKey} is ${val ? "present" : "missing"}`;
    return result;
  }

  // experience checks like experience_years_2+
  if (key.startsWith("experience_years")) {
    const match = key.match(/experience_years[_\s]*([0-9]+)\+?/);
    const required = match ? Number(match[1]) : 0;
    const have = (input.experienceYears ?? (input as any).experience_years ?? 0) as number;
    if (have >= required) {
      result.met = true;
      result.partialFactor = 1;
    } else if (required > 0 && have > 0) {
      // partial credit proportional to have/required (capped)
      result.partialFactor = Math.min(1, have / required);
      result.met = result.partialFactor >= 0.8;
    } else {
      result.partialFactor = 0;
      result.met = false;
    }
    result.reason = `experience ${have}/${required} years`;
    return result;
  }

  // it_experience or related
  if (key.includes("it") && (key.includes("experience") || key.includes("exp"))) {
    const have = !!((input as any).it_experience ?? (input as any).itExperience);
    result.met = have;
    result.partialFactor = have ? 1 : 0;
    result.reason = `IT experience is ${have ? "present" : "absent"}`;
    return result;
  }

  // salary checks
  // support keys like "salary_above_threshold", "salary_above_50260"
  if (key.includes("salary")) {
    const salary = (input.salary ?? 0) as number;
    // 1) Try meta.thresholds - common key names
    let threshold = undefined;
    if (meta && meta.thresholds) {
      // pick a threshold heuristically: min_salary_general or min_salary_shortage or first numeric threshold
      threshold =
        meta.thresholds.min_salary_general ??
        meta.thresholds.min_salary ??
        meta.thresholds?.min_salary_shortage ??
        Object.values(meta.thresholds).find((v: any) => typeof v === "number");
    }

    // 2) If key contains a numeric part like salary_above_50260
    const numMatch = key.match(/salary_above_([0-9]+)/);
    if (!threshold && numMatch) {
      threshold = Number(numMatch[1]);
    }

    if (!threshold) {
      // fallback threshold for safety
      threshold = 0;
    }

    if (salary >= threshold) {
      result.met = true;
      result.partialFactor = 1;
      result.reason = `salary ${salary} >= threshold ${threshold}`;
    } else {
      // partial credit proportional to salary/threshold
      const diff = threshold > 0 ? salary / threshold : 0;
      result.partialFactor = Math.max(0, Math.min(1, diff));
      result.met = result.partialFactor >= 0.8;
      result.reason = `salary ${salary} vs threshold ${threshold} (partial ${result.partialFactor.toFixed(2)})`;
    }
    result.detail = `salary:${salary}, threshold:${threshold}`;
    return result;
  }

  // language level checks like german_level_b1+
  if (key.includes("german_level") || key.includes("english_level") || key.match(/_level_/)) {
    // extract requested level (eg. ..._b1+)
    const match = key.match(/_(a1|a2|b1|b2|c1|c2)\+?$/i);
    let required = undefined;
    if (match) required = match[1].toUpperCase();
    const which = key.includes("german") ? "germanLevel" : key.includes("english") ? "englishLevel" : null;
    const haveLevel = which ? ((input as any)[which] as string | undefined) : undefined;
    const haveIdx = langIndex(haveLevel);
    const reqIdx = required ? langIndex(required) : 0;
    // score: full credit if haveIdx >= reqIdx, partial if near
    if (haveIdx >= reqIdx && reqIdx > 0) {
      result.met = true;
      result.partialFactor = 1;
    } else if (reqIdx > 0 && haveIdx > 0) {
      // partial credit proportional to closeness
      const frac = haveIdx / reqIdx;
      result.partialFactor = Math.max(0, Math.min(1, frac));
      result.met = result.partialFactor >= 0.8;
    } else {
      result.met = reqIdx === 0; // if no requirement specified, treat as met
      result.partialFactor = reqIdx === 0 ? 1 : 0;
    }
    result.reason = `${which} ${haveLevel ?? "NONE"} vs required ${required ?? "any"}`;
    return result;
  }

  // generic fallback: try to read input field with same name
  {
    const inputKey = key.replace(/_([a-z])/g, (_, c) => c.toUpperCase()); // snake -> camel
    const val = (input as any)[inputKey];
    if (typeof val === "boolean") {
      result.met = val === true;
      result.partialFactor = val ? 1 : 0;
      result.reason = `${inputKey} boolean is ${val}`;
      return result;
    }
    if (typeof val === "number") {
      // assume any positive number counts as met
      result.met = val > 0;
      result.partialFactor = Math.min(1, val / 10); // arbitrary small partial metric
      result.reason = `${inputKey} numeric ${val}`;
      return result;
    }
  }

  // unknown criterion -> mark optional missing (small penalty)
  result.met = false;
  result.partialFactor = 0;
  result.reason = `Unknown criterion ${keyRaw} (treated as optional missing)`;
  return result;
}

/**
 * Compute score for a given visa meta + user input
 *
 * - meta.criteria is a map { criterionKey: weight }
 * - meta.minimum_score is the threshold to consider it a valid candidate (not used to compute, but may be used by caller)
 *
 * Returns VisaCandidate object.
 */
export function computeScoreForVisa(metaContainer: { code: string; meta: any; category: string }, input: VisaQuestionnaireInput): VisaCandidate {
  const { code, meta, category } = metaContainer;
  const rawBase = (meta.basePriority ?? 50) as number; // default base
  let rawScore = rawBase;
  const matched: string[] = [];
  const missing: Array<{ key: string; severity: "critical" | "important" | "optional"; detail?: string }> = [];
  const reasons: string[] = [];
  let disqualify = false;

  const criteria = meta.criteria ?? {};

  // For each criterion key => weight
  for (const keyRaw of Object.keys(criteria)) {
    const weight = Number(criteria[keyRaw] ?? 0);
    const evalRes = evaluateCriterion(keyRaw, weight, meta, input);

    // scoring policy:
    // - full match -> + weight
    // - partial -> + weight * partialFactor
    // - missing -> - penalty proportional to weight (or heavy if disqualify)
    if (evalRes.met) {
      rawScore += weight * (evalRes.partialFactor || 1);
      matched.push(keyRaw);
      reasons.push(`Matched ${keyRaw} (+${(weight * (evalRes.partialFactor || 1)).toFixed(1)})`);
    } else {
      // treat missing as penalty
      const penaltyIfStrict = evalRes.disqualifyIfMissing ? 100 : Math.max(6, Math.round(weight * 0.8)); // heuristic
      const severity: "critical" | "important" | "optional" = evalRes.disqualifyIfMissing ? "critical" : "important";
      rawScore -= penaltyIfStrict;
      missing.push({ key: keyRaw, severity, detail: evalRes.reason });
      reasons.push(`Missing ${keyRaw} (-${penaltyIfStrict})`);
      if (evalRes.disqualifyIfMissing) {
        // if strict missing -> immediate disqualify
        disqualify = true;
      }
    }
  }

  // context modifiers / bonuses
  // nationality (if visa likely can be applied in-country and user is visa-free)
  const nationality = input.nationality;
  if (nationality && meta.canApplyInCountry && isVisaFreeNationality(nationality)) {
    rawScore += 5;
    reasons.push("Visa-free entry eases in-country application (+5)");
  }

  // host agreement bonus for research visas
  if ((category === "research" || meta.category === "research") && input.hasHostAgreement) {
    rawScore += 15;
    reasons.push("Host agreement present (+15)");
  }

  // Job offer big bonus for work visas
  if (category === "work" && input.hasJobOffer) {
    rawScore += 15;
    reasons.push("Job offer (+15)");
  }

  // Normalize to 0..100 assuming reasonable raw range -200..200
  const final = normalizeScore(rawScore, -100, 200);

  return {
    code,
    name: meta.name ?? code,
    category,
    meta,
    score: final,
    matched,
    missing,
    disqualify,
    reasons,
  };
}

/**
 * Evaluate all visas and return sorted candidates (desc)
 */
export function evaluateAllVisas(input: VisaQuestionnaireInput) {
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
      experienceYears: input.experienceYears || 0
    };
  }

  candidates.sort((a, b) => b.score - a.score);
  return candidates;
}

/**
 * Choose top candidate as recommended (at least one)
 */
export function chooseTopCandidate(candidates: VisaCandidate[]) {
  if (!candidates || candidates.length === 0) return null;
  return candidates[0];
}

/**
 * Choose up to two alternatives (exclude recommended)
 *
 * Diversity: prefer different categories for better options coverage
 * Falls back to same category if no other high-scoring options exist
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
    // Skip if we already have this category and there are other options
    if (alts.length > 0 && alts.some(a => a.category === candidate.category)) {
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