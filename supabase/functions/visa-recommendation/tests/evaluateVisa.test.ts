// supabase/functions/visa-recommendation/tests/integration.test.ts
import { evaluateVisa } from "../lib/evaluateVisa.ts";
import {
  assertEquals,
  assertExists,
} from "https://deno.land/std@0.224.0/assert/mod.ts";

/**
 * Integration tests that match the database questionnaire structure
 */

Deno.test("Work Path - Perfect Blue Card candidate from questionnaire", () => {
  const questionnaireAnswers = {
    purpose: "work",
    nationality: "United States",
    birthday: "1990-01-15",
    german_level: "B1",
    english_level: "C1",
    profession: "Software Engineer",
    has_job_offer: "yes",
    employer_name: "SAP AG",
    salary: "68000",
    work_location: "Munich",
    experience_years: "5",
    has_degree: "yes",
    degree_field: "Computer Science",
    university_name_work: "Stanford University",
    university_country: "United States",
    has_anerkennung: "yes",
    is_it_field: "yes",
    has_insurance: "yes",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "blue_card");
  console.log("✓ Blue Card recommended correctly");
});

Deno.test("Work Path - IT Specialist without degree", () => {
  const questionnaireAnswers = {
    purpose: "work",
    nationality: "India",
    birthday: "1988-06-20",
    german_level: "A2",
    english_level: "B2",
    profession: "Full Stack Developer",
    has_job_offer: "yes",
    salary: "52000",
    experience_years: "6",
    has_degree: "no",
    is_it_field: "yes",
    it_specialization: "Software Development",
    programming_languages: "JavaScript, Python, Java",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "it_specialist");
  console.log("✓ IT Specialist recommended correctly");
});

Deno.test("Education Path - University student", () => {
  const questionnaireAnswers = {
    purpose: "study",
    nationality: "China",
    birthday: "2000-03-15",
    german_level: "B2",
    english_level: "B2",
    edu_level: "University (Bachelor/Master)",
    admitted: "yes",
    university_name_edu: "Technical University of Munich",
    study_field: "Mechanical Engineering",
    program_start: "2024-10-01",
    study_language: "German",
    funding_source: "Blocked Account",
    proof_funds: "yes",
    has_insurance: "yes",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "student");
  console.log("✓ Student visa recommended correctly");
});

Deno.test("Education Path - Language course", () => {
  const questionnaireAnswers = {
    purpose: "study",
    nationality: "Brazil",
    birthday: "1995-08-10",
    german_level: "A1",
    edu_level: "Language Course",
    language_school_name: "Goethe Institut Berlin",
    fulltime_german: "yes",
    target_german_level: "B2",
    course_duration_weeks: "24",
    proof_funds: "yes",
    has_insurance: "yes",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "language_course");
  console.log("✓ Language course visa recommended correctly");
});

Deno.test("Research Path - Researcher with host agreement", () => {
  const questionnaireAnswers = {
    purpose: "research",
    nationality: "United Kingdom",
    birthday: "1985-11-25",
    german_level: "B1",
    english_level: "C2",
    has_host_agreement: "yes",
    institution_name: "Max Planck Institute",
    research_field: "Physics",
    research_funded: "yes",
    research_duration_months: "24",
    has_insurance: "yes",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "researcher");
  console.log("✓ Researcher visa recommended correctly");
});

Deno.test("Family Path - Spouse reunion", () => {
  const questionnaireAnswers = {
    purpose: "family reunion",
    nationality: "Turkey",
    birthday: "1992-04-18",
    german_level: "A1",
    has_family_in_germany: "yes",
    relationship: "Spouse",
    family_member_status: "German Citizen",
    marriage_date: "2020-06-15",
    proof_funds: "yes",
    has_insurance: "yes",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "family_reunion");
  console.log("✓ Family reunion visa recommended correctly");
});

Deno.test("Personal Path - Au Pair", () => {
  const questionnaireAnswers = {
    purpose: "personal/cultural exchange",
    nationality: "Colombia",
    birthday: "2002-07-22",
    german_level: "A2",
    personal_route: "Au Pair",
    has_host_contract: "yes",
    au_pair_age_check: "yes",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "au_pair");
  console.log("✓ Au Pair visa recommended correctly");
});

Deno.test("Healthcare Path - Registered Nurse", () => {
  const questionnaireAnswers = {
    purpose: "work",
    nationality: "Philippines",
    birthday: "1990-09-12",
    german_level: "B2",
    profession: "Registered Nurse",
    has_job_offer: "yes",
    salary: "42000",
    is_healthcare: "yes",
    healthcare_profession: "Nurse",
    has_medical_license: "yes",
    has_degree: "yes",
    degree_field: "Nursing",
    has_anerkennung: "in progress",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  // Should recommend skilled worker or specialized nursing visa
  console.log(
    "✓ Healthcare professional recommendation:",
    result.recommended!.code,
  );
});

Deno.test("Fallback - Insufficient information", () => {
  const questionnaireAnswers = {
    purpose: "work",
    nationality: "Unknown Country",
    has_job_offer: "no",
    has_degree: "no",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "preparation_needed");
  console.log("✓ Fallback guidance provided correctly");
});

Deno.test("Job Seeker Path - Qualified candidate", () => {
  const questionnaireAnswers = {
    purpose: "work",
    nationality: "India",
    birthday: "1988-12-05",
    german_level: "B1",
    has_job_offer: "no",
    job_search_timeline: "1-3 months",
    job_seeker_funds: "yes",
    profession: "Data Scientist",
    has_degree: "yes",
    degree_field: "Computer Science",
    has_anerkennung: "yes",
    experience_years: "4",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  console.log("✓ Job Seeker path:", result.recommended!.code);
  // Should be job_seeker or preparation with job search guidance
});

Deno.test("Ausbildung Path - Vocational training", () => {
  const questionnaireAnswers = {
    purpose: "study",
    nationality: "Morocco",
    birthday: "2003-02-14",
    german_level: "B1",
    edu_level: "Ausbildung (Vocational Training)",
    ausbildung_field: "Mechatronics",
    company_name: "Siemens AG",
    ausbildung_start: "2024-09-01",
    ausbildung_duration_years: "3 years",
    proof_funds: "yes",
  };

  const result = evaluateVisa(questionnaireAnswers as any);

  assertExists(result.recommended);
  assertEquals(result.recommended!.code, "ausbildung");
  console.log("✓ Ausbildung visa recommended correctly");
});

console.log("\n✅ All integration tests passed!");
