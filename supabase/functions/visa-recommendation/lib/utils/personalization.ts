import { VisaCandidate } from "../types.ts";

/** Confidence label derived from normalized score */
function confidenceLabel(score: number): string {
  if (score >= 85) return "High";
  if (score >= 70) return "Medium";
  return "Low";
}

/** Simple templating function that replaces {{field}} with values from context */
function fillTemplate(template: string, context: Record<string, any>): string {
  return template.replace(/\{\{(.*?)\}\}/g, (_, key) => {
    const val = context[key.trim()];
    return val !== undefined && val !== null ? String(val) : "(unspecified)";
  });
}

/** Converts matched/missing requirement lists into user-friendly descriptions */
function buildRequirementLists(candidate: VisaCandidate) {
  // Matched requirements might be string keys, so map them safely
  const met = candidate.matched.map((k) => readableLabel(k));

  const missing = candidate.missing.map((m) => {
    const base = readableLabel(m.key);
    const extra = m.detail ? ` – ${m.detail}` : "";
    const tag =
      m.severity === "critical"
        ? " (critical)"
        : m.severity === "important"
        ? " (important)"
        : "";
    return `${base}${extra}${tag}`;
  });

  return { met, missing };
}

/** Utility for mapping technical requirement keys to friendly labels */
function readableLabel(key: string): string {
  const dictionary: Record<string, string> = {
    jobOffer: "Valid job offer from a German employer",
    degree: "Recognized university degree",
    germanLevel: "German language level",
    englishLevel: "English proficiency",
    salary: "Salary requirement",
    proofFunds: "Proof of sufficient funds",
    hasInsurance: "Health insurance coverage",
    default: key,
  };
  return dictionary[key] || key;
}

/** Generates contextual notes based on candidate and missing requirements */
function generateNotes(candidate: VisaCandidate): string[] {
  const { meta, missing, context } = candidate;
  const notes: string[] = [];

  const nationality = context?.nationality;
  const hasFamily = context?.hasFamilyInGermany;

  if (nationality && meta.canApplyInCountry?.includes(nationality)) {
    notes.push("You can apply from your home country or directly within Germany.");
  }

  if (missing.some((m) => m.key === "germanLevel")) {
    notes.push("You might consider applying for a language course visa first.");
  }

  if (hasFamily) {
    notes.push("Since you have family in Germany, family reunification visas may also be relevant.");
  }

  return notes;
}

/** Main export: converts a VisaCandidate into a personalized recommendation JSON */
export function personalizeCandidate(candidate: VisaCandidate) {
  const { meta, score, context } = candidate;

  const confidence = confidenceLabel(score);
  const summary = fillTemplate(meta.explanationTemplate, {
    ...context,
    name: meta.name,
  });

  const { met, missing } = buildRequirementLists(candidate);
  const notes = generateNotes(candidate);

  return {
    code: meta.code,
    name: meta.name,
    confidence,
    summary,
    requirements: { met, missing },
    notes,
  };
}
