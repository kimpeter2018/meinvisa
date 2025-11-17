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
}

function runAndValidate(input: any) {
    const result = evaluateVisa(input);
    validateRecommendationShape(result);
    return result;
}

// === BIRTHDAY/AGE CALCULATION TESTS ===

Deno.test("Birthday: Calculate age from birthday string", () => {
    const input = {
        purpose: "personal",
        nationality: "Colombia",
        personalRoute: "au pair",
        birthday: "2001-05-15",
        hasHostContract: true,
        germanLevel: "A2",
    };

    const rec = runAndValidate(input);
    // Should calculate age ~23 and allow au pair
    assertEquals(rec.recommended!.code, "au_pair");
});

Deno.test("Birthday: Age from birthday - too young for au pair", () => {
    const input = {
        purpose: "personal",
        nationality: "Mexico",
        personalRoute: "au pair",
        birthday: "2008-01-01",
        hasHostContract: true,
        germanLevel: "A2",
    };

    const rec = runAndValidate(input);
    // Should be under 18, fail au pair requirement
    assert(rec.recommended!.code !== "au_pair");
});

Deno.test("Birthday: Age from birthday - too old for au pair", () => {
    const input = {
        purpose: "personal",
        nationality: "Argentina",
        personalRoute: "au pair",
        birthday: "1992-01-01",
        hasHostContract: true,
        germanLevel: "A2",
    };

    const rec = runAndValidate(input);
    // Should be over 26, fail au pair
    assert(rec.recommended!.code !== "au_pair");
});

Deno.test("Birthday: Working Holiday - exact age boundary (30)", () => {
    const input = {
        purpose: "personal",
        nationality: "Australia",
        birthday: "1994-06-15",
        proofFunds: true,
        hasInsurance: true,
    };

    const rec = runAndValidate(input);
    // Should be eligible if under 31
    const allowed = ["working_holiday", "personal_job_seeker"];
    assertArrayIncludes(allowed, [rec.recommended!.code]);
});

// === PART-TIME STUDY VALIDATION TESTS ===

Deno.test("Part-time: Student visa with part-time study - should fail", () => {
    const input = {
        purpose: "study",
        nationality: "India",
        eduLevel: "University (Bachelor/Master)",
        studyMode: "part-time",
        admitted: true,
        proofFunds: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "part_time_study_ineligible");
});

Deno.test("Part-time: Full-time study mode - should pass", () => {
    const input = {
        purpose: "study",
        nationality: "China",
        eduLevel: "University (Bachelor/Master)",
        studyMode: "full-time",
        admitted: true,
        proofFunds: true,
        germanLevel: "B2",
        hasInsurance: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "student");
});

Deno.test("Part-time: Language course part-time - should fail", () => {
    const input = {
        purpose: "education",
        nationality: "Brazil",
        isLanguageCourse: true,
        fulltimeGerman: false,
        proofFunds: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "part_time_language_ineligible");
});

// === STUDIENKOLLEG TESTS ===

Deno.test("Studienkolleg: High school graduate needs preparatory course", () => {
    const input = {
        purpose: "education",
        nationality: "Nigeria",
        eduLevel: "High School",
        previousEducationLevel: "High School",
        admitted: false,
        germanLevel: "B1",
        proofFunds: true,
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) =>
            n.includes("Studienkolleg") || n.includes("preparatory")
        ),
    );
});

Deno.test("Studienkolleg: Needs preparatory course flag set", () => {
    const input = {
        purpose: "education",
        nationality: "Egypt",
        needsStudienkolleg: true,
        germanLevel: "B1",
        proofFunds: true,
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) =>
            n.includes("Studienkolleg") || n.includes("preparatory")
        ),
    );
});

// === CHILDREN AND FAMILY TESTS ===

Deno.test("Children: Family reunion with children under 18", () => {
    const input = {
        purpose: "personal",
        nationality: "Syria",
        hasFamilyInGermany: true,
        relationship: "spouse",
        hasChildren: true,
        childrenCount: 2,
        childrenAges: "8, 12",
        germanLevel: "A1",
        proofFunds: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "family_reunion");
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) => n.includes("children") || n.includes("child")),
    );
});

Deno.test("Children: Mixed ages - minors and adults", () => {
    const input = {
        purpose: "personal",
        nationality: "Pakistan",
        hasFamilyInGermany: true,
        hasChildren: true,
        childrenCount: 3,
        childrenAges: "15, 19, 22",
        germanLevel: "A1",
        proofFunds: true,
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    // Should mention different requirements for minors vs adults
    assert(rec.notes!.some((n) => n.includes("18") || n.includes("adult")));
});

Deno.test("Children: Adult children reunion - more restrictive", () => {
    const input = {
        purpose: "personal",
        nationality: "India",
        hasFamilyInGermany: true,
        relationship: "child",
        age: 22,
        germanLevel: "A1",
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) =>
            n.includes("Adult children") || n.includes("18+")
        ),
    );
});

// === BLOCKED ACCOUNT AMOUNT TESTS ===

Deno.test("Blocked Account: Sufficient amount for student", () => {
    const input = {
        purpose: "education",
        nationality: "Vietnam",
        eduLevel: "University (Bachelor/Master)",
        admitted: true,
        blockedAccountAmount: 12000,
        germanLevel: "B1",
        hasInsurance: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "student");
});

Deno.test("Blocked Account: Insufficient amount warning", () => {
    const input = {
        purpose: "education",
        nationality: "Bangladesh",
        eduLevel: "University (Bachelor/Master)",
        admitted: true,
        blockedAccountAmount: 8000,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    // Should warn about insufficient funds
    assert(
        rec.notes!.some((n) =>
            n.includes("fund") || n.includes("11,904") || n.includes("blocked")
        ),
    );
});

// === TRAINING/INTERNSHIP TESTS ===

Deno.test("Training: Paid internship strengthens application", () => {
    const input = {
        purpose: "training",
        nationality: "Mexico",
        trainingType: "internship",
        trainingCompany: "German Corp",
        trainingDurationMonths: 6,
        trainingCompensation: true,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) => n.includes("Paid") || n.includes("strengthen")),
    );
});

Deno.test("Training: Unpaid internship requires funds", () => {
    const input = {
        purpose: "training",
        nationality: "Turkey",
        trainingType: "internship",
        trainingCompany: "Tech Startup",
        trainingDurationMonths: 12,
        trainingCompensation: false,
        proofFunds: false,
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) =>
            n.includes("Unpaid") || n.includes("proof of funds")
        ),
    );
});

Deno.test("Training: Long duration internship (18 months)", () => {
    const input = {
        purpose: "training",
        nationality: "Brazil",
        trainingDurationMonths: 18,
        trainingCompany: "Engineering Firm",
        trainingCompensation: true,
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    // Should note that 18 months may need special justification
    assert(rec.notes!.some((n) => n.includes("18") || n.includes("12 months")));
});

// === BUSINESS/ENTREPRENEUR TESTS ===

Deno.test("Business: Low investment amount warning", () => {
    const input = {
        purpose: "business",
        nationality: "Russia",
        businessType: "freelance",
        hasBusinessPlan: true,
        businessInvestment: 5000,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(rec.notes!.some((n) => n.includes("5000") || n.includes("low")));
});

Deno.test("Business: High investment strengthens application", () => {
    const input = {
        purpose: "business",
        nationality: "United States",
        businessType: "startup",
        hasBusinessPlan: true,
        businessInvestment: 50000,
        hasDegree: true,
        germanLevel: "B2",
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(rec.notes!.some((n) => n.includes("50000") || n.includes("Strong")));
});

Deno.test("Business: No business plan - preparation needed", () => {
    const input = {
        purpose: "business",
        nationality: "China",
        businessType: "restaurant",
        hasBusinessPlan: false,
        businessInvestment: 30000,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "business_preparation_needed");
});

Deno.test("Business: Freelance vs trade business distinction", () => {
    const input = {
        purpose: "business",
        nationality: "India",
        businessType: "consulting",
        hasBusinessPlan: true,
        businessInvestment: 15000,
        hasDegree: true,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) =>
            n.includes("Freelance") || n.includes("Freiberufler")
        ),
    );
});

// === REMOTE WORK TESTS ===

Deno.test("Remote: Remote work guidance", () => {
    const input = {
        purpose: "work",
        nationality: "United Kingdom",
        remoteWork: true,
        hasJobOffer: true,
        salary: 55000,
        hasDegree: true,
        germanLevel: "A2",
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) => n.includes("Remote") || n.includes("remote")),
    );
});

// === EMPLOYMENT STATUS TESTS ===

Deno.test("Employment: Currently employed in Germany", () => {
    const input = {
        purpose: "work",
        nationality: "India",
        employmentStatus: "Employed",
        currentLocation: "Berlin, Germany",
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 60000,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) => n.includes("Germany") || n.includes("within")),
    );
});

Deno.test("Employment: Self-employed seeking business visa", () => {
    const input = {
        purpose: "business",
        nationality: "Australia",
        employmentStatus: "Self-Employed",
        hasBusinessPlan: true,
        businessInvestment: 25000,
        experienceYears: 5,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    const allowed = [
        "freelance",
        "business_preparation_needed",
        // "working_holiday",
    ];
    assertArrayIncludes(allowed, [rec.recommended!.code]);
});

// === JOB SEARCH TIMELINE TESTS ===

Deno.test("Job Search: 6+ months timeline suggests job seeker visa", () => {
    const input = {
        purpose: "work",
        nationality: "Turkey",
        hasJobOffer: false,
        jobSearchTimeline: "6+ months",
        hasDegree: true,
        hasAnerkennung: true,
        germanLevel: "B1",
        experienceYears: 4,
    };

    const rec = runAndValidate(input);
    assertExists(rec.notes);
    assert(
        rec.notes!.some((n) =>
            n.includes("6+ months") || n.includes("Job Seeker")
        ),
    );
});

// === SCHOLARSHIP TESTS ===

Deno.test("Scholarship: Has scholarship for studies", () => {
    const input = {
        purpose: "education",
        nationality: "Kenya",
        eduLevel: "University (Bachelor/Master)",
        admitted: true,
        hasScholarship: true,
        scholarshipName: "DAAD Scholarship",
        germanLevel: "B1",
        hasInsurance: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "student");
});

// === PREVIOUS VISA HISTORY TESTS ===

Deno.test("Previous Visa: Has previous visa history", () => {
    const input = {
        purpose: "work",
        nationality: "China",
        previousVisa: true,
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 65000,
        germanLevel: "B2",
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "blue_card");
});

Deno.test("Visa Refusal: Has refusal history", () => {
    const input = {
        purpose: "work",
        nationality: "Pakistan",
        visaRefusalHistory: true,
        hasJobOffer: true,
        hasDegree: true,
        salary: 55000,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    // Should still process but may add warnings
    assertExists(rec.recommended);
});

// === PROFESSIONAL CERTIFICATION TESTS ===

Deno.test("Certification: Has professional certification", () => {
    const input = {
        purpose: "work",
        nationality: "India",
        hasJobOffer: true,
        hasDegree: true,
        hasProfessionalCertification: true,
        isItField: true,
        salary: 58000,
        germanLevel: "B1",
        experienceYears: 5,
    };

    const rec = runAndValidate(input);
    const allowed = ["blue_card", "skilled_worker"];
    assertArrayIncludes(allowed, [rec.recommended!.code]);
});

// === COMPANY SIZE TESTS ===

Deno.test("Company: Startup company", () => {
    const input = {
        purpose: "work",
        nationality: "Brazil",
        hasJobOffer: true,
        companySize: "Startup",
        isItField: true,
        salary: 52000,
        experienceYears: 3,
        germanLevel: "A2",
    };

    const rec = runAndValidate(input);
    assertExists(rec.recommended);
});

Deno.test("Company: Large corporation", () => {
    const input = {
        purpose: "work",
        nationality: "Japan",
        hasJobOffer: true,
        companySize: "Large",
        hasDegree: true,
        hasAnerkennung: true,
        salary: 70000,
        germanLevel: "B2",
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "blue_card");
});

// === ENGINEERING SPECIFIC TESTS ===

Deno.test("Engineering: Professional engineer", () => {
    const input = {
        purpose: "work",
        nationality: "India",
        isEngineer: true,
        engineeringField: "Mechanical Engineering",
        professionalEngineer: true,
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 62000,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "blue_card");
});

// === GERMAN MEDICAL EXAM TESTS ===

Deno.test("Healthcare: Passed German medical exam", () => {
    const input = {
        purpose: "work",
        nationality: "Syria",
        isHealthcare: true,
        healthcareProfession: "Doctor",
        hasMedicalLicense: true,
        germanMedicalExam: true,
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 68000,
        germanLevel: "C1",
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "blue_card");
});

// === PHD SPECIFIC TESTS ===

Deno.test("PhD: Has supervisor and funding", () => {
    const input = {
        purpose: "education",
        nationality: "Iran",
        eduLevel: "PhD/Doctorate",
        phdUniversity: "Technical University Munich",
        phdField: "Physics",
        hasPhDSupervisor: true,
        phdFunding: "Research Grant",
        admitted: true,
        germanLevel: "B2",
        hasInsurance: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "student");
});

// === RESEARCH POSITION TYPE TESTS ===

Deno.test("Research: Postdoc position", () => {
    const input = {
        purpose: "research",
        nationality: "United States",
        hasHostAgreement: true,
        researchPositionType: "Postdoc",
        researchFunded: true,
        hasDegree: true,
        hasPublications: true,
        hasInsurance: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "researcher");
});

Deno.test("Research: Visiting researcher", () => {
    const input = {
        purpose: "research",
        nationality: "Japan",
        hasHostAgreement: true,
        researchPositionType: "Visiting Researcher",
        researchDurationMonths: 6,
        researchFunded: true,
        hasDegree: true,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "researcher");
});

// === IT SPECIALIZATION TESTS ===

Deno.test("IT: Specific specialization - DevOps", () => {
    const input = {
        purpose: "work",
        nationality: "Ukraine",
        isItField: true,
        itSpecialization: "DevOps",
        hasItCertifications: true,
        hasJobOffer: true,
        salary: 58000,
        experienceYears: 5,
        germanLevel: "A2",
    };

    const rec = runAndValidate(input);
    const allowed = ["blue_card", "skilled_worker", "it_specialist"];
    assertArrayIncludes(allowed, [rec.recommended!.code]);
});

Deno.test("IT: Programming languages specified", () => {
    const input = {
        purpose: "work",
        nationality: "India",
        isItField: true,
        programmingLanguages: "Python, JavaScript, Go",
        hasJobOffer: true,
        hasDegree: false,
        itExperience: true,
        salary: 54000,
        experienceYears: 6,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "it_specialist");
});

// === MULTIPLE NATIONALITIES EDGE CASES ===

Deno.test("Nationality: Dual citizen with working holiday eligible", () => {
    const input = {
        purpose: "personal",
        nationality: "Australia",
        age: 26,
        proofFunds: true,
        hasInsurance: true,
    };

    const rec = runAndValidate(input);
    // Should recommend working holiday or at least mention it
    const isWorkingHoliday = rec.recommended!.code === "working_holiday";
    const mentionsWorkingHoliday = rec.notes?.some((n) =>
        n.includes("Working Holiday") || n.includes("working holiday")
    );
    assert(isWorkingHoliday || mentionsWorkingHoliday);
});

// === EMPTY/NULL VALUES TESTS ===

Deno.test("Empty: Empty string values handled gracefully", () => {
    const input = {
        purpose: "work",
        nationality: "",
        germanLevel: "",
        hasJobOffer: false,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "job_seeker");
});

Deno.test("Null: Null values handled gracefully", () => {
    const input = {
        purpose: "work",
        nationality: null,
        germanLevel: null,
        salary: null,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "job_seeker");
});

// === EXTREME VALUES TESTS ===

Deno.test("Extreme: Very high salary", () => {
    const input = {
        purpose: "work",
        nationality: "United States",
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 150000,
        germanLevel: "C2",
        experienceYears: 15,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "blue_card");
});

Deno.test("Extreme: Very long experience (30+ years)", () => {
    const input = {
        purpose: "work",
        nationality: "Canada",
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 85000,
        germanLevel: "B2",
        experienceYears: 35,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "blue_card");
});

Deno.test("Extreme: Senior age applicant (65 years old)", () => {
    const input = {
        purpose: "work",
        nationality: "United Kingdom",
        age: 65,
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 70000,
        germanLevel: "B1",
        experienceYears: 40,
    };

    const rec = runAndValidate(input);
    // Should still process normally
    const allowed = ["blue_card", "skilled_worker"];
    assertArrayIncludes(allowed, [rec.recommended!.code]);
});

// === COMBINATION OF MULTIPLE ISSUES ===

Deno.test("Multiple Issues: Part-time study + no funds + low German", () => {
    const input = {
        purpose: "education",
        nationality: "Bangladesh",
        eduLevel: "University (Bachelor/Master)",
        studyMode: "part-time",
        proofFunds: false,
        germanLevel: "A1",
    };

    const rec = runAndValidate(input);
    // Should catch the part-time issue first
    assertEquals(rec.recommended!.code, "part_time_study_ineligible");
});

Deno.test("Multiple Issues: Au pair too old + no contract + low German", () => {
    const input = {
        purpose: "personal",
        nationality: "Philippines",
        personalRoute: "au pair",
        age: 32,
        hasHostContract: false,
        germanLevel: "None",
    };

    const rec = runAndValidate(input);
    // Should fail on age requirement
    assert(rec.recommended!.code !== "au_pair");
});

// === LANGUAGE LEVEL EDGE CASES ===

Deno.test("Language: C2 German level (native-like)", () => {
    const input = {
        purpose: "work",
        nationality: "Poland",
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 58000,
        germanLevel: "C2",
        experienceYears: 5,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "blue_card");
    assertExists(rec.notes);
    // assert(
    //     rec.notes!.some((n) => n.includes("C2") || n.includes("proficiency")),
    // );
});

Deno.test("Language: Both German and English proficient", () => {
    const input = {
        purpose: "work",
        nationality: "Netherlands",
        hasJobOffer: true,
        hasDegree: true,
        hasAnerkennung: true,
        salary: 62000,
        germanLevel: "B2",
        englishLevel: "C1",
        experienceYears: 4,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "blue_card");
});

// === SPECIAL CHARACTERS IN INPUT ===

Deno.test("Special: Umlauts in German names", () => {
    const input = {
        purpose: "education",
        nationality: "Turkey",
        eduLevel: "University (Bachelor/Master)",
        universityNameEdu: "Ludwig-Maximilians-Universität München",
        admitted: true,
        proofFunds: true,
        germanLevel: "B2",
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "student");
});

// === DATE FORMAT EDGE CASES ===

Deno.test("Date: Future program start date", () => {
    const input = {
        purpose: "education",
        nationality: "Mexico",
        eduLevel: "University (Bachelor/Master)",
        admitted: true,
        programStart: "2026-10-01",
        proofFunds: true,
        germanLevel: "B1",
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "student");
    // Should provide timeline guidance
    assertExists(rec.notes);
});

Deno.test("Date: Very near program start (2 months)", () => {
    const futureDate = new Date();
    futureDate.setMonth(futureDate.getMonth() + 2);
    const dateString = futureDate.toISOString().split("T")[0];

    const input = {
        purpose: "education",
        nationality: "India",
        eduLevel: "University (Bachelor/Master)",
        admitted: true,
        programStart: dateString,
        proofFunds: true,
        germanLevel: "B1",
        hasInsurance: true,
    };

    const rec = runAndValidate(input);
    assertEquals(rec.recommended!.code, "student");
    assertExists(rec.notes);
    // Should urgently recommend applying
    assert(
        rec.notes!.some((n) => n.includes("NOW") || n.includes("immediately")),
    );
});
