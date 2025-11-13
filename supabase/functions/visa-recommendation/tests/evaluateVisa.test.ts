/// <reference lib="deno.ns" />
/// <reference lib="deno.unstable" />

import { evaluateVisa } from "../lib/evaluateVisa.ts";
import {
  assert,
  assertArrayIncludes,
  assertEquals,
  assertExists,
} from "https://deno.land/std@0.224.0/assert/mod.ts";

// === HELPER FUNCTIONS ===

function validateRecommendationShape(rec: any) {
  assertExists(rec, "Recommendation object should exist");
  assertExists(rec.recommended, "Recommended visa must exist");

  const recommended = rec.recommended!;
  assert(typeof recommended.code === "string", "code must be string");
  assert(typeof recommended.name === "string", "name must be string");
  assert(typeof recommended.summary === "string", "summary must be string");

  if (rec.alternatives) {
    assert(Array.isArray(rec.alternatives), "alternatives must be array");
  }
  if (rec.notes) {
    assert(Array.isArray(rec.notes), "notes must be array");
  }
}

function runAndValidate(input: any) {
  const result = evaluateVisa(input);
  validateRecommendationShape(result);
  return result;
}

// === WORK VISA TESTS ===

Deno.test("Work: Perfect EU Blue Card candidate", () => {
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
  assertEquals(rec.recommended!.code, "blue_card");
});

Deno.test("Work: Blue Card with shortage occupation salary", () => {
  const input = {
    purpose: "work",
    nationality: "India",
    hasJobOffer: true,
    hasDegree: true,
    degreeField: "Computer Science",
    hasAnerkennung: true,
    salary: 46000,
    germanLevel: "B1",
    experienceYears: 3,
    isItField: true,
  };

  const rec = runAndValidate(input);
  const allowed = ["blue_card", "skilled_worker", "it_specialist"];
  assertArrayIncludes(allowed, [rec.recommended!.code]);
});

Deno.test("Work: IT Specialist without degree", () => {
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
  assertEquals(rec.recommended!.code, "it_specialist");
});

Deno.test("Work: IT Specialist with low experience should fail", () => {
  const input = {
    purpose: "work",
    nationality: "Poland",
    hasJobOffer: true,
    hasDegree: false,
    isItField: true,
    salary: 52000,
    germanLevel: "A2",
    experienceYears: 2,
  };

  const rec = runAndValidate(input);
  assert(rec.recommended!.code !== "it_specialist");
});

Deno.test("Work: Job Seeker Visa - no job offer", () => {
  const input = {
    purpose: "work",
    nationality: "India",
    hasJobOffer: false,
    hasDegree: true,
    hasAnerkennung: true,
    germanLevel: "B1",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  const allowed = ["job_seeker", "preparation_needed"];
  assertArrayIncludes(allowed, [rec.recommended!.code]);
});

Deno.test("Work: Skilled Worker with degree but no Anerkennung", () => {
  const input = {
    purpose: "work",
    nationality: "Turkey",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: false,
    salary: 48000,
    germanLevel: "B1",
    experienceYears: 4,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) =>
      n.includes("Anerkennung") || n.includes("recognition")
    ),
  );
});

Deno.test("Work: Low salary below threshold", () => {
  const input = {
    purpose: "work",
    nationality: "Philippines",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 35000,
    germanLevel: "A2",
    experienceYears: 2,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(rec.notes!.some((n) => n.includes("salary") || n.includes("Salary")));
});

Deno.test("Work: No degree, no IT field - preparation needed", () => {
  const input = {
    purpose: "work",
    nationality: "Nigeria",
    hasJobOffer: false,
    hasDegree: false,
    isItField: false,
    germanLevel: "A1",
    experienceYears: 1,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "preparation_needed");
});

Deno.test("Work: High experience + high salary", () => {
  const input = {
    purpose: "work",
    nationality: "Canada",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 80000,
    germanLevel: "C1",
    experienceYears: 10,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "blue_card");
});

Deno.test("Work: Borderline Blue Card salary", () => {
  const input = {
    purpose: "work",
    nationality: "Ukraine",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 58400,
    germanLevel: "B1",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  const allowed = ["blue_card", "skilled_worker"];
  assertArrayIncludes(allowed, [rec.recommended!.code]);
});

// === EDUCATION VISA TESTS ===

Deno.test("Education: Student visa - perfect case", () => {
  const input = {
    purpose: "education",
    nationality: "China",
    eduLevel: "University (Bachelor/Master)",
    admitted: true,
    studyField: "Computer Science",
    proofFunds: true,
    germanLevel: "B2",
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "student");
});

Deno.test("Education: Student visa - not admitted yet", () => {
  const input = {
    purpose: "education",
    nationality: "Vietnam",
    eduLevel: "University (Bachelor/Master)",
    admitted: false,
    germanLevel: "B1",
    proofFunds: true,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) => n.includes("admission") || n.includes("Secure")),
  );
});

Deno.test("Education: Language course visa", () => {
  const input = {
    purpose: "education",
    nationality: "Morocco",
    eduLevel: "Language Course",
    isLanguageCourse: true,
    fulltimeGerman: true,
    proofFunds: true,
    germanLevel: "A1",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "language_course");
});

Deno.test("Education: Part-time language course - should fail", () => {
  const input = {
    purpose: "education",
    nationality: "Egypt",
    eduLevel: "Language Course",
    isLanguageCourse: true,
    fulltimeGerman: false,
    germanLevel: "A1",
  };

  const rec = runAndValidate(input);
  assert(rec.recommended!.code !== "language_course");
});

Deno.test("Education: Ausbildung (vocational training)", () => {
  const input = {
    purpose: "education",
    nationality: "Serbia",
    eduLevel: "Ausbildung (Vocational Training)",
    isAusbildung: true,
    hasVocational: true,
    germanLevel: "B1",
    proofFunds: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "ausbildung");
});

Deno.test("Education: PhD student with funding", () => {
  const input = {
    purpose: "education",
    nationality: "United States",
    eduLevel: "PhD/Doctorate",
    admitted: true,
    hasDegree: true,
    proofFunds: true,
    germanLevel: "B2",
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "student");
});

Deno.test("Education: No funds - should note requirement", () => {
  const input = {
    purpose: "education",
    nationality: "Pakistan",
    eduLevel: "University (Bachelor/Master)",
    admitted: true,
    proofFunds: false,
    germanLevel: "B1",
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) => n.includes("fund") || n.includes("blocked account")),
  );
});

Deno.test("Education: English-taught program", () => {
  const input = {
    purpose: "education",
    nationality: "India",
    eduLevel: "University (Bachelor/Master)",
    admitted: true,
    studyField: "Engineering",
    proofFunds: true,
    germanLevel: "A1",
    englishLevel: "C1",
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "student");
});

Deno.test("Education: Nursing Ausbildung", () => {
  const input = {
    purpose: "education",
    nationality: "Philippines",
    eduLevel: "Ausbildung (Vocational Training)",
    isAusbildung: true,
    isNursing: true,
    germanLevel: "B2",
    proofFunds: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "ausbildung");
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) =>
      n.includes("Nursing") || n.includes("nursing") ||
      n.includes("Anerkennung")
    ),
  );
});

// === RESEARCH VISA TESTS ===

Deno.test("Research: Researcher with host agreement", () => {
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

Deno.test("Research: No host agreement - not ready", () => {
  const input = {
    purpose: "research",
    nationality: "Brazil",
    hasHostAgreement: false,
    hasDegree: true,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) =>
      n.includes("hosting agreement") || n.includes("host")
    ),
  );
});

Deno.test("Research: Postdoc position", () => {
  const input = {
    purpose: "research",
    nationality: "Japan",
    hasHostAgreement: true,
    researchFunded: true,
    hasDegree: true,
    hasInsurance: true,
    germanLevel: "B1",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "researcher");
});

Deno.test("Research: Unfunded research", () => {
  const input = {
    purpose: "research",
    nationality: "South Korea",
    hasHostAgreement: true,
    researchFunded: false,
    hasDegree: true,
    proofFunds: true,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(rec.notes!.some((n) => n.includes("funding") || n.includes("fund")));
});

// === SPECIALIZED VISA TESTS ===

Deno.test("Specialized: Artist with performances", () => {
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

Deno.test("Specialized: Artist without performances", () => {
  const input = {
    purpose: "culture",
    nationality: "Italy",
    hasPerformance: false,
    proofFunds: true,
  };

  const rec = runAndValidate(input);
  assert(rec.recommended!.code !== "artist");
});

Deno.test("Specialized: Professional athlete", () => {
  const input = {
    purpose: "sports",
    nationality: "Argentina",
    isAthlete: true,
    hasHostContract: true,
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "athlete");
});

Deno.test("Specialized: Esports professional", () => {
  const input = {
    purpose: "sports",
    nationality: "Korea",
    isEsports: true,
    hasHostContract: true,
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "esports");
});

Deno.test("Specialized: Language teacher", () => {
  const input = {
    purpose: "work",
    nationality: "United Kingdom",
    isLanguageTeacher: true,
    hasJobOffer: true,
    hasDegree: true,
    germanLevel: "B1",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "language_teacher");
});

Deno.test("Specialized: Freelancer with business plan", () => {
  const input = {
    purpose: "freelance",
    nationality: "Australia",
    isSelfEmployed: true,
    hasDegree: true,
    proofFunds: true,
    germanLevel: "B1",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "freelance");
});

// === FAMILY VISA TESTS ===

Deno.test("Family: Spouse reunion", () => {
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

Deno.test("Family: No family in Germany", () => {
  const input = {
    purpose: "personal",
    nationality: "Morocco",
    hasFamilyInGermany: false,
    germanLevel: "A1",
  };

  const rec = runAndValidate(input);
  assert(rec.recommended!.code !== "family_reunion");
});

Deno.test("Family: Au Pair - correct age", () => {
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

Deno.test("Family: Au Pair - age too high", () => {
  const input = {
    purpose: "personal",
    nationality: "Colombia",
    personalRoute: "au pair",
    hasHostContract: true,
    age: 28,
    germanLevel: "A2",
  };

  const rec = runAndValidate(input);
  assert(rec.recommended!.code !== "au_pair");
});

Deno.test("Family: Volunteer service", () => {
  const input = {
    purpose: "personal",
    nationality: "Mexico",
    personalRoute: "volunteer",
    hasHostContract: true,
    proofFunds: true,
    germanLevel: "A2",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "volunteer_service");
});

Deno.test("Family: Working Holiday - eligible country", () => {
  const input = {
    purpose: "personal",
    nationality: "Australia",
    personalRoute: "working holiday",
    age: 25,
    proofFunds: true,
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "working_holiday");
});

Deno.test("Family: Working Holiday - ineligible country", () => {
  const input = {
    purpose: "personal",
    nationality: "India",
    personalRoute: "working holiday",
    age: 25,
    proofFunds: true,
  };

  const rec = runAndValidate(input);
  assert(rec.recommended!.code !== "working_holiday");
});

// === EDGE CASES & ERROR HANDLING ===

Deno.test("Edge: No purpose specified", () => {
  const input = {
    nationality: "Germany",
    germanLevel: "C2",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "unspecified_purpose");
});

Deno.test("Edge: Unknown purpose", () => {
  const input = {
    purpose: "tourism",
    nationality: "United States",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "unknown_purpose");
});

Deno.test("Edge: Minimal input - should return fallback", () => {
  const input = {
    purpose: "work",
    nationality: "Unknown",
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "preparation_needed");
});

Deno.test("Edge: Conflicting information (degree but no Anerkennung)", () => {
  const input = {
    purpose: "work",
    nationality: "India",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: false,
    salary: 50000,
    germanLevel: "A2",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) =>
      n.includes("Anerkennung") || n.includes("recognition")
    ),
  );
});

Deno.test("Edge: Very low German level for work", () => {
  const input = {
    purpose: "work",
    nationality: "China",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 60000,
    germanLevel: "None",
    experienceYears: 4,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) => n.includes("German") || n.includes("language")),
  );
});

Deno.test("Edge: Alternatives should be provided", () => {
  const input = {
    purpose: "work",
    nationality: "Brazil",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 52000,
    germanLevel: "B1",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  assertExists(rec.alternatives);
  assert(rec.alternatives!.length > 0, "Should provide alternatives");
});

Deno.test("Edge: Notes array is populated", () => {
  const input = {
    purpose: "work",
    nationality: "India",
    hasJobOffer: false,
    hasDegree: true,
    hasAnerkennung: false,
    germanLevel: "A1",
    experienceYears: 1,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  assert(rec.notes!.length > 0, "Should provide guidance notes");
});

// === CROSS-CATEGORY TESTS ===

Deno.test("Cross: IT professional with degree - Blue Card vs IT Specialist", () => {
  const input = {
    purpose: "work",
    nationality: "India",
    hasJobOffer: true,
    hasDegree: true,
    isItField: true,
    hasAnerkennung: true,
    salary: 60000,
    germanLevel: "B1",
    experienceYears: 5,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "blue_card");
  // Should mention IT Specialist as alternative
  if (rec.alternatives) {
    assert(
      rec.alternatives.some((alt) =>
        alt.code === "it_specialist" || alt.code === "skilled_worker"
      ),
    );
  }
});

Deno.test("Cross: Work experience but studying - should prioritize study", () => {
  const input = {
    purpose: "education",
    nationality: "China",
    eduLevel: "University (Bachelor/Master)",
    admitted: true,
    proofFunds: true,
    germanLevel: "B2",
    hasJobOffer: false,
    experienceYears: 2,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "student");
});

Deno.test("Cross: Language course as bridge to work", () => {
  const input = {
    purpose: "work",
    nationality: "Vietnam",
    hasJobOffer: false,
    hasDegree: true,
    hasAnerkennung: false,
    germanLevel: "A1",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  assertExists(rec.notes);
  // Should suggest language course or job seeker visa
  assert(
    rec.notes!.some((n) => n.includes("language") || n.includes("German")) ||
      rec.alternatives?.some((alt) => alt.code === "language_course"),
  );
});

// === NATIONALITY-SPECIFIC TESTS ===

Deno.test("Nationality: Visa-free entry (US citizen)", () => {
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
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) => n.includes("visa-free") || n.includes("entry")),
  );
});

Deno.test("Nationality: Working Holiday eligible", () => {
  const input = {
    purpose: "personal",
    nationality: "New Zealand",
    age: 24,
    proofFunds: true,
    hasInsurance: true,
  };

  const rec = runAndValidate(input);
  // Should mention or recommend working holiday
  assert(
    rec.recommended!.code === "working_holiday" ||
      rec.notes!.some((n) =>
        n.includes("Working Holiday") || n.includes("working holiday")
      ),
  );
});

// === HEALTHCARE PROFESSION TESTS ===

Deno.test("Healthcare: Medical doctor with license", () => {
  const input = {
    purpose: "work",
    nationality: "Egypt",
    hasJobOffer: true,
    hasDegree: true,
    isHealthcare: true,
    hasAnerkennung: true,
    hasMedicalLicense: true,
    salary: 70000,
    germanLevel: "C1",
    experienceYears: 8,
  };

  const rec = runAndValidate(input);
  const allowed = ["blue_card", "skilled_worker"];
  assertArrayIncludes(allowed, [rec.recommended!.code]);
  assertExists(rec.notes);
  assert(
    rec.notes!.some((n) =>
      n.includes("medical") || n.includes("health") || n.includes("Anerkennung")
    ),
  );
});

Deno.test("Healthcare: Nurse with experience", () => {
  const input = {
    purpose: "work",
    nationality: "Philippines",
    hasJobOffer: true,
    hasDegree: true,
    isHealthcare: true,
    isNursing: true,
    hasAnerkennung: true,
    salary: 48000,
    germanLevel: "B2",
    experienceYears: 5,
  };

  const rec = runAndValidate(input);
  const allowed = ["blue_card", "skilled_worker"];
  assertArrayIncludes(allowed, [rec.recommended!.code]);
});

// === SALARY THRESHOLD TESTS ===

Deno.test("Salary: Just below general Blue Card threshold", () => {
  const input = {
    purpose: "work",
    nationality: "Russia",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 58000,
    germanLevel: "B1",
    experienceYears: 4,
  };

  const rec = runAndValidate(input);
  // Should recommend skilled worker or note salary gap
  assert(
    rec.recommended!.code === "skilled_worker" ||
      rec.notes!.some((n) => n.includes("salary") || n.includes("58,400")),
  );
});

Deno.test("Salary: Exactly at shortage occupation threshold", () => {
  const input = {
    purpose: "work",
    nationality: "India",
    hasJobOffer: true,
    hasDegree: true,
    degreeField: "Computer Science",
    hasAnerkennung: true,
    isItField: true,
    salary: 45600,
    germanLevel: "B1",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  const allowed = ["blue_card", "skilled_worker", "it_specialist"];
  assertArrayIncludes(allowed, [rec.recommended!.code]);
});

// === AGE-DEPENDENT TESTS ===

Deno.test("Age: Young professional (25) - more options", () => {
  const input = {
    purpose: "work",
    nationality: "Canada",
    age: 25,
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: true,
    salary: 55000,
    germanLevel: "B1",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  const allowed = ["blue_card", "skilled_worker"];
  assertArrayIncludes(allowed, [rec.recommended!.code]);
});

Deno.test("Age: Au Pair age limit (27) - should fail", () => {
  const input = {
    purpose: "personal",
    nationality: "Mexico",
    personalRoute: "au pair",
    age: 27,
    hasHostContract: true,
    germanLevel: "A2",
  };

  const rec = runAndValidate(input);
  assert(rec.recommended!.code !== "au_pair");
  assertExists(rec.notes);
  assert(rec.notes!.some((n) => n.includes("age") || n.includes("18-26")));
});

// === COMPREHENSIVE COMBINATION TESTS ===

Deno.test("Combo: Strong candidate with everything", () => {
  const input = {
    purpose: "work",
    nationality: "United States",
    hasJobOffer: true,
    hasDegree: true,
    degreeLevel: "PhD/Doctorate",
    degreeField: "Artificial Intelligence",
    hasAnerkennung: true,
    isItField: true,
    salary: 90000,
    germanLevel: "C1",
    englishLevel: "C2",
    experienceYears: 12,
    hasInsurance: true,
    hasAccommodation: true,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "blue_card");
  assertExists(rec.alternatives);
  assertExists(rec.notes);
});

Deno.test("Combo: Weak candidate with gaps", () => {
  const input = {
    purpose: "work",
    nationality: "Bangladesh",
    hasJobOffer: false,
    hasDegree: false,
    hasVocational: false,
    isItField: false,
    germanLevel: "None",
    experienceYears: 0,
  };

  const rec = runAndValidate(input);
  assertEquals(rec.recommended!.code, "preparation_needed");
  assertExists(rec.notes);
  assert(rec.notes!.length > 2, "Should provide multiple improvement steps");
});

Deno.test("Combo: Mid-level candidate with mixed signals", () => {
  const input = {
    purpose: "work",
    nationality: "Ukraine",
    hasJobOffer: true,
    hasDegree: true,
    hasAnerkennung: false,
    salary: 48000,
    germanLevel: "A2",
    experienceYears: 3,
  };

  const rec = runAndValidate(input);
  const allowed = ["skilled_worker", "preparation_needed"];
  assertArrayIncludes(allowed, [rec.recommended!.code]);
  assertExists(rec.notes);
  assert(rec.notes!.some((n) =>
    n.includes("Anerkennung") ||
    n.includes("German") ||
    n.includes("language")
  ));
});

console.log("\n✅ All test cases completed!");
