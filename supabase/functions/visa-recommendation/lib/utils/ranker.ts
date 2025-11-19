import type { VisaCandidate, VisaQuestionnaireInput } from "../types.ts";
import {
  isVisaFreeNationality,
  isWorkingHolidayEligible,
} from "./nationality.ts";
import {
  calculateAge,
  isAgeInRange,
  isHealthcareField,
  isItField,
  isStemField,
  meetsLanguageRequirement,
} from "./matchHelpers.ts";
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
 * FIXED: Enhanced criterion evaluation with proper negative criteria handling
 */
function evaluateCriterion(
  keyRaw: string,
  weight: number,
  meta: any,
  input: VisaQuestionnaireInput,
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
  let isNegativeCriterion = false;

  // Check if strict requirement (starts with "!")
  if (key.startsWith("!")) {
    key = key.slice(1);

    // Determine if this is a negative criterion
    // Negative criterion: the field should be FALSE/absent (e.g., !has_job_offer for job_seeker)
    // Positive strict criterion: the field should be TRUE/present (e.g., !has_degree for blue_card)

    // Check if this is a boolean field that should be false
    const booleanNegativeFields = [
      "has_job_offer",
      "has_degree",
      "has_vocational",
      "is_language_course",
      "is_ausbildung",
      "is_it_field",
      "is_healthcare",
      "is_engineer",
    ];

    if (booleanNegativeFields.includes(key.toLowerCase())) {
      isNegativeCriterion = true;
    } else {
      // For other fields with !, it means strictly required to be present
      result.disqualifyIfMissing = true;
    }
  }

  key = key.trim().toLowerCase();

  // ===== BOOLEAN FIELDS =====
  if (
    key.startsWith("has_") || key.startsWith("is_") || key.startsWith("needs_")
  ) {
    const inputKey = snakeToCamel(key);
    const val = (input as any)[inputKey];

    if (isNegativeCriterion) {
      // For negative criteria, we want the field to be FALSE
      result.met = val === false || val === null || val === undefined;
      result.partialFactor = result.met ? 1 : 0;
      result.reason = `${inputKey} is ${
        val ? "present (not desired)" : "absent (desired)"
      }`;
    } else {
      // Normal positive criterion
      result.met = val === true;
      result.partialFactor = val ? 1 : 0;
      result.reason = `${inputKey} is ${val ? "present" : "missing"}`;
    }

    return result;
  }

  // ===== PERSONAL ROUTE CHECKS =====
  if (key.startsWith("personal_route_")) {
    const routeType = key.replace("personal_route_", "").replace(/_/g, " ");
    const userRoute = input.personalRoute?.toLowerCase() || "";

    result.met = userRoute.includes(routeType);
    result.partialFactor = result.met ? 1 : 0;
    result.reason = `Personal route ${userRoute} ${
      result.met ? "matches" : "doesn't match"
    } ${routeType}`;

    return result;
  }

  // ===== DEGREE RECOGNIZED =====
  if (key === "degree_recognized" || key === "has_anerkennung") {
    const val = input.hasAnerkennung;
    result.met = val === true;
    result.partialFactor = val ? 1 : 0;
    result.reason = `Degree recognition (Anerkennung) is ${
      val ? "completed" : "missing"
    }`;

    return result;
  }

  // ===== EXPERIENCE YEARS =====
  if (key.startsWith("experience_years")) {
    const match = key.match(/experience_years[_\s]*([0-9]+)\+?/);
    const required = match ? Number(match[1]) : 0;
    const have = (input.experienceYears ?? 0) as number;

    if (have >= required) {
      result.met = true;
      result.partialFactor = 1;
    } else if (required > 0 && have > 0) {
      result.partialFactor = Math.min(1, have / required);
      result.met = result.partialFactor >= 0.8;
    } else {
      result.partialFactor = 0;
      result.met = false;
    }

    result.reason = `Experience ${have}/${required} years`;
    result.detail = `Partial credit: ${
      (result.partialFactor * 100).toFixed(0)
    }%`;

    return result;
  }

  // ===== IT EXPERIENCE =====
  if (
    key.includes("it") && (key.includes("experience") || key.includes("exp"))
  ) {
    const have = !!(input.itExperience ?? false);
    result.met = have;
    result.partialFactor = have ? 1 : 0;
    result.reason = `IT experience is ${have ? "present" : "absent"}`;

    return result;
  }

  // ===== SALARY CHECKS =====
  if (key.includes("salary")) {
    const salary = (input.salary ?? 0) as number;

    let threshold: number | undefined;

    if (meta && meta.thresholds) {
      threshold = meta.thresholds.min_salary_general ??
        meta.thresholds.min_salary ??
        meta.thresholds.min_salary_shortage ??
        Object.values(meta.thresholds).find((v: any) =>
          typeof v === "number"
        ) as number;
    }

    const numMatch = key.match(/salary_above_([0-9]+)/);
    if (!threshold && numMatch) {
      threshold = Number(numMatch[1]);
    }

    if (!threshold) {
      threshold = 0;
    }

    if (salary >= threshold) {
      result.met = true;
      result.partialFactor = 1;
      result.reason = `Salary €${salary} >= threshold €${threshold}`;
    } else if (salary > 0) {
      result.partialFactor = Math.min(1, salary / threshold);
      result.met = result.partialFactor >= 0.9;
      result.reason = `Salary €${salary} vs threshold €${threshold} (${
        (result.partialFactor * 100).toFixed(0)
      }%)`;
    } else {
      result.met = false;
      result.partialFactor = 0;
      result.reason =
        `No salary information provided (threshold: €${threshold})`;
    }

    result.detail = `salary:${salary}, threshold:${threshold}`;

    return result;
  }

  // ===== LANGUAGE LEVEL CHECKS =====
  if (
    key.match(/_(german|english|language)_level_/) ||
    key.match(/_level_[a-c][1-2]/i)
  ) {
    const match = key.match(/_(a1|a2|b1|b2|c1|c2)\+?$/i);
    const required = match && match[1] ? match[1].toUpperCase() : undefined;

    let haveLevel: string | undefined;
    if (key.includes("german")) {
      haveLevel = input.germanLevel;
    } else if (key.includes("english")) {
      haveLevel = input.englishLevel;
    }

    const haveIdx = langIndex(haveLevel);
    const reqIdx = required ? langIndex(required) : 0;

    if (haveIdx >= reqIdx && reqIdx > 0) {
      result.met = true;
      result.partialFactor = 1;
    } else if (reqIdx > 0 && haveIdx > 0) {
      result.partialFactor = Math.min(1, haveIdx / reqIdx);
      result.met = result.partialFactor >= 0.8;
    } else {
      result.met = reqIdx === 0;
      result.partialFactor = reqIdx === 0 ? 1 : 0;
    }

    const langType = key.includes("german")
      ? "German"
      : key.includes("english")
      ? "English"
      : "Language";
    result.reason = `${langType} level ${haveLevel ?? "NONE"} vs required ${
      required ?? "any"
    }`;
    result.detail = `Partial credit: ${
      (result.partialFactor * 100).toFixed(0)
    }%`;

    return result;
  }

  // ===== AGE RANGE =====
  if (key.startsWith("age_between")) {
    const match = key.match(/age_between_(\d+)_(\d+)/);
    if (match) {
      const minAge = Number(match[1]);
      const maxAge = Number(match[2]);
      const age = input.age ??
        (input.birthday ? calculateAge(input.birthday) : undefined);

      if (age) {
        result.met = age >= minAge && age <= maxAge;
        result.partialFactor = result.met ? 1 : 0;
        result.reason = `Age ${age} ${
          result.met ? "within" : "outside"
        } range ${minAge}-${maxAge}`;
      } else {
        result.met = false;
        result.partialFactor = 0;
        result.reason = "Age information missing";
      }

      return result;
    }
  }

  // ===== NATIONALITY CHECKS =====
  if (key.startsWith("nationality_")) {
    const nationality = input.nationality;

    if (key.includes("working_holiday")) {
      const eligible = isWorkingHolidayEligible(nationality);
      result.met = eligible;
      result.partialFactor = eligible ? 1 : 0;
      result.reason = `${nationality ?? "Unknown"} ${
        eligible ? "is" : "is not"
      } eligible for working holiday`;

      return result;
    }

    if (key.includes("visa_free")) {
      const eligible = isVisaFreeNationality(nationality);
      result.met = eligible;
      result.partialFactor = eligible ? 1 : 0;
      result.reason = `${nationality ?? "Unknown"} ${
        eligible ? "is" : "is not"
      } visa-free`;

      return result;
    }
  }

  // ===== ADMISSION/APPLICATION STATUS =====
  if (key === "admitted") {
    const admitted = input.admitted;
    result.met = admitted === true;
    result.partialFactor = admitted ? 1 : 0;
    result.reason = `University admission is ${
      admitted ? "confirmed" : "pending"
    }`;

    return result;
  }

  // ===== FULL-TIME REQUIREMENTS =====
  if (key === "fulltime_german") {
    const fulltime = input.fulltimeGerman;
    result.met = fulltime === true;
    result.partialFactor = fulltime ? 1 : 0;
    result.reason = `Full-time German course (18+ hrs/week) is ${
      fulltime ? "confirmed" : "not confirmed"
    }`;

    return result;
  }

  // ===== PROOF OF FUNDS =====
  if (key === "proof_funds") {
    const val = input.proofFunds;
    result.met = val === true;
    result.partialFactor = val ? 1 : 0;
    result.reason = `Proof of funds is ${val ? "available" : "missing"}`;

    return result;
  }

  // ===== FIELD-BASED CHECKS =====
  if (key === "it_field") {
    const itField = input.isItField ?? isItField(input.profession) ??
      isItField(input.degreeField);
    result.met = itField === true;
    result.partialFactor = itField ? 1 : 0;
    result.reason = `IT field is ${itField ? "confirmed" : "not confirmed"}`;

    return result;
  }

  if (key === "healthcare_field") {
    const healthcare = input.isHealthcare ??
      isHealthcareField(input.profession) ??
      isHealthcareField(input.degreeField);
    result.met = healthcare === true;
    result.partialFactor = healthcare ? 1 : 0;
    result.reason = `Healthcare field is ${
      healthcare ? "confirmed" : "not confirmed"
    }`;

    return result;
  }

  if (key === "stem_field") {
    const stem = isStemField(input.degreeField) ??
      isStemField(input.profession);
    result.met = stem === true;
    result.partialFactor = stem ? 1 : 0;
    result.reason = `STEM field is ${stem ? "confirmed" : "not confirmed"}`;

    return result;
  }

  // ===== GENERIC FALLBACK =====
  const inputKey = snakeToCamel(key);
  const val = (input as any)[inputKey];

  if (typeof val === "boolean") {
    if (isNegativeCriterion) {
      result.met = val === false;
      result.partialFactor = !val ? 1 : 0;
      result.reason = `${inputKey} boolean is ${val} (should be false)`;
    } else {
      result.met = val === true;
      result.partialFactor = val ? 1 : 0;
      result.reason = `${inputKey} boolean is ${val}`;
    }
    return result;
  }

  if (typeof val === "number") {
    result.met = val > 0;
    result.partialFactor = Math.min(1, val / 10);
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
 */
export function computeScoreForVisa(
  metaContainer: { code: string; meta: any; category: string },
  input: VisaQuestionnaireInput,
): VisaCandidate {
  const { code, meta, category } = metaContainer;

  const rawBase = (meta.basePriority ?? 50) as number;
  let rawScore = rawBase;

  const matched: string[] = [];
  const missing: Array<{
    key: string;
    severity: "critical" | "important" | "optional";
    detail?: string;
  }> = [];
  const reasons: string[] = [];
  let disqualify = false;

  const criteria = meta.criteria ?? {};

  // Evaluate each criterion
  for (const keyRaw of Object.keys(criteria)) {
    const weight = Number(criteria[keyRaw] ?? 0);
    const evalRes = evaluateCriterion(keyRaw, weight, meta, input);

    if (evalRes.met) {
      const score = weight * (evalRes.partialFactor || 1);
      rawScore += score;
      matched.push(keyRaw);
      reasons.push(`✓ ${keyRaw}: +${score.toFixed(1)} (${evalRes.reason})`);
    } else {
      const penaltyBase = evalRes.disqualifyIfMissing
        ? 100
        : Math.max(5, Math.round(weight * 0.5));
      const penalty = penaltyBase;

      rawScore -= penalty;

      const severity: "critical" | "important" | "optional" =
        evalRes.disqualifyIfMissing
          ? "critical"
          : weight >= 20
          ? "important"
          : "optional";

      missing.push({
        key: keyRaw,
        severity,
        detail: evalRes.reason,
      });

      reasons.push(
        `✗ ${keyRaw}: -${penalty} [${severity}] (${evalRes.reason})`,
      );

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
        rawScore += 10; // INCREASED from 5
        reasons.push(`✓ Visa-free nationality + in-country application: +10`);
      }
    }
  }

  // Work visa + job offer bonus
  if (category === "work" && input.hasJobOffer) {
    rawScore += 20; // INCREASED from 15
    reasons.push(`✓ Job offer present: +20`);
  }

  // Student visa + admission bonus
  if (category === "education" && input.admitted) {
    rawScore += 15; // INCREASED from 10
    reasons.push(`✓ University admission: +15`);
  }

  // Research visa + host agreement bonus
  if (
    (category === "specialized" || category === "research") &&
    input.hasHostAgreement
  ) {
    rawScore += 20; // INCREASED from 15
    reasons.push(`✓ Host agreement present: +20`);
  }

  // Family reunion + family in Germany bonus
  if (category === "personal" && input.hasFamilyInGermany) {
    rawScore += 15; // INCREASED from 10
    reasons.push(`✓ Family in Germany: +15`);
  }

  // Working holiday eligibility bonus
  if (code === "working_holiday" && input.nationality) {
    if (isWorkingHolidayEligible(input.nationality)) {
      rawScore += 25; // INCREASED from 20
      reasons.push(`✓ Working Holiday eligible nationality: +25`);
    }
  }

  // Language proficiency bonus
  if (input.germanLevel) {
    const level = input.germanLevel.toUpperCase();
    if (["B2", "C1", "C2"].includes(level)) {
      rawScore += 10; // INCREASED from 5
      reasons.push(`✓ High German proficiency (${level}): +10`);
    } else if (["A2", "B1"].includes(level)) {
      rawScore += 5; // NEW: bonus for basic German
      reasons.push(`✓ Basic German proficiency (${level}): +5`);
    }
  }

  // STEM field bonus for work visas
  if (
    category === "work" && isStemField(input.degreeField || input.profession)
  ) {
    rawScore += 10; // INCREASED from 5
    reasons.push(`✓ STEM field (high demand): +10`);
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
 * Evaluate all visas and return sorted candidates
 */
export function evaluateAllVisas(
  input: VisaQuestionnaireInput,
): VisaCandidate[] {
  const rawList = loadAllVisas();
  const candidates: VisaCandidate[] = [];

  // Calculate age if birthday provided
  const age = input.age ??
    (input.birthday ? calculateAge(input.birthday) : undefined);

  for (const m of rawList) {
    const candidate = computeScoreForVisa(m, input);

    // Add enhanced context for personalization
    candidate.context = {
      ...input,
      age,
      nationality: input.nationality,
      salary: input.salary,
      degreeField: input.degreeField || "your field",
      experienceYears: input.experienceYears || 0,
      studyField: input.studyField || "your program",
      germanLevel: input.germanLevel,
      performanceCount: input.performanceCount || 0,
      businessSector: input.businessSector || "your industry",
    };

    const allowConditional = !!(m.meta?.allowConditional === true);
    if (!candidate.disqualify || allowConditional) {
      candidates.push(candidate);
    }
  }

  candidates.sort((a, b) => b.score - a.score);

  return candidates;
}

/**
 * Choose top candidate
 */
export function chooseTopCandidate(
  candidates: VisaCandidate[],
): VisaCandidate | null {
  return candidates.length > 0 ? candidates[0]! : null;
}

/**
 * Choose up to two alternatives with category diversity
 */
export function chooseUpToTwoAlternatives(
  candidates: VisaCandidate[],
  recommended?: VisaCandidate,
): VisaCandidate[] {
  const alts: VisaCandidate[] = [];

  const available = candidates.filter((c) =>
    !recommended || c.code !== recommended.code
  );

  if (available.length === 0) return [];

  // First pass: diverse categories
  for (const candidate of available) {
    if (
      alts.length > 0 && alts.some((a) => a.category === candidate.category)
    ) {
      continue;
    }

    if (
      recommended && candidate.category === recommended.category &&
      alts.length < 2
    ) {
      continue;
    }

    alts.push(candidate);
    if (alts.length >= 2) break;
  }

  // Second pass: fill remaining slots
  if (alts.length < 2) {
    for (const candidate of available) {
      if (alts.some((a) => a.code === candidate.code)) continue;

      alts.push(candidate);
      if (alts.length >= 2) break;
    }
  }

  return alts;
}
