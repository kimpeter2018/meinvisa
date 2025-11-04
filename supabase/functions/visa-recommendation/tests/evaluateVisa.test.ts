import { evaluateVisa } from "../lib/evaluateVisa.ts";
import {
  assert,
  assertEquals,
  assertExists,
  assertArrayIncludes,
} from "https://deno.land/std@0.224.0/assert/mod.ts";

// --- Helpers ---

function validateRecommendationShape(rec: any) {
  assertExists(rec, "Recommendation object should be returned");
  assertExists(rec.recommended, "Recommended visa must exist");

  const recommended = rec.recommended!;
  assert(typeof recommended.code === "string", "recommended.code must be a string");
  assert(typeof recommended.name === "string", "recommended.name must be a string");
  assert(typeof recommended.summary === "string", "recommended.summary must be a string");

  if (rec.alternatives) {
    assert(Array.isArray(rec.alternatives), "alternatives must be an array if present");
  }
  if (rec.notes) {
    assert(Array.isArray(rec.notes), "notes must be an array if present");
  }
}

function runAndValidate(input: any) {
  const result = evaluateVisa(input);
  validateRecommendationShape(result);
  return result;
}

// --- TEST CASES ---

Deno.test("Work — EU Blue Card (clear match)", () => {
  const input = {
    purpose: "work",
    nationality: "United States",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 65000,
    germanLevel: "B1",
    experienceYears: 4,
  };

  const rec = runAndValidate(input);
  assertExists(rec.recommended);
  assertEquals(rec.recommended!.code, "blue_card");
});

Deno.test("Work — No job offer should suggest Job Seeker or preparation", () => {
  const input = {
    purpose: "work",
    nationality: "India",
    hasJobOffer: false,
    hasDegree: true,
    hasAnerkennung: true,
    germanLevel: "A1",
    experienceYears: 2,
  };

  const rec = runAndValidate(input);
  const allowed = ["job_seeker", "preparation_needed"];
  assertExists(rec.recommended);
  assertArrayIncludes(allowed, [rec.recommended!.code]);
});

Deno.test("Work — IT Specialist without degree but with experience and salary", () => {
  const input = {
    purpose: "work",
    nationality: "Brazil",
    hasJobOffer: true,
    hasDegree: false,
    isItField: true,
    itExperience: true,
    salary: 55000,
    germanLevel: "A2",
    experienceYears: 5,
  };

  const rec = runAndValidate(input);
  assertExists(rec.recommended);
  assertEquals(rec.recommended!.code, "it_specialist");
});

Deno.test("Work — borderline Blue Card salary (shortage threshold)", () => {
  const input = {
    purpose: "work",
    nationality: "Ukraine",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 45600,
    germanLevel: "B1",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  const allowed = ["blue_card", "skilled_worker"];
  assertExists(rec.recommended);
  assertArrayIncludes(allowed, [rec.recommended!.code]);
});

Deno.test("Education — Student visa happy path", () => {
  const input = {
    purpose: "education",
    nationality: "China",
    admitted: true,
    eduLevel: "university",
    studyField: "Computer Science",
    proofFunds: true,
    germanLevel: "B2",
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "student");
});

Deno.test("Education — Language course for low German level", () => {
  const input = {
    purpose: "education",
    nationality: "Morocco",
    isLanguageCourse: true,
    fulltime_german: true,
    proofFunds: true,
    germanLevel: "A1",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "language_course");
});

Deno.test("Specialized — Researcher with host agreement", () => {
  const input = {
    purpose: "research",
    nationality: "United States",
    hasHostAgreement: true,
    researchFunded: true,
    hasDegree: true,
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "researcher");
});

Deno.test("Specialized — Artist with performances and host contract", () => {
  const input = {
    purpose: "culture",
    nationality: "France",
    hasPerformance: true,
    performanceCount: 3,
    hasHostContract: true,
    proofFunds: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "artist");
});

Deno.test("Personal — Family reunion happy path", () => {
  const input = {
    purpose: "personal",
    nationality: "Turkey",
    hasFamilyInGermany: true,
    personalRoute: "spouse",
    germanLevel: "A1",
    proofFunds: true,
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "family_reunion");
});

Deno.test("Personal — Au pair valid case", () => {
  const input = {
    purpose: "personal",
    nationality: "Colombia",
    personalRoute: "au pair",
    hasHostContract: true,
    age: 22,
    germanLevel: "A2",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "au_pair");
});

Deno.test("Fallback — Insufficient data returns preparation guidance", () => {
  const input = {
    purpose: "work",
    nationality: "Unknown",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "preparation_needed");
});

Deno.test("Robustness — returns alternatives and notes arrays", () => {
  const input = {
    purpose: "work",
    nationality: "India",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: false,
    salary: 48000,
    germanLevel: "A2",
    experienceYears: 4,
  };

  const rec = runAndValidate(input);
  assert(Array.isArray(rec.alternatives), "alternatives should be an array");
  assert(Array.isArray(rec.notes), "notes should be an array");
});
