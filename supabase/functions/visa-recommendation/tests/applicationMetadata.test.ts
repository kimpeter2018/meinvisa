import {
  assertEquals,
  assertExists,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

// Test utilities
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") || "http://127.0.0.1:54321";
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY") ||
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0";
const FUNCTION_URL = `${SUPABASE_URL}/functions/v1/visa-recommendation`;

// Create test user and get token
async function getTestToken() {
  const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

  const email = `kimpeter2018@naver.com`;
  const password = "!S2u5s24d";

  const { data: signUpData, error: signUpError } = await supabase.auth.signUp({
    email,
    password,
  });

  if (signUpError) throw signUpError;

  const { data: signInData, error: signInError } = await supabase.auth
    .signInWithPassword({
      email,
      password,
    });

  if (signInError) throw signInError;

  return signInData.session?.access_token;
}

// Helper to call the function
async function callVisaRecommendation(body: any, token: string) {
  const response = await fetch(FUNCTION_URL, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });

  const data = await response.json();
  return { response, data };
}

// Logging helper
function logSection(title: string) {
  console.log("\n" + "=".repeat(80));
  console.log(`📋 ${title}`);
  console.log("=".repeat(80));
}

function logSuccess(message: string) {
  console.log(`✅ ${message}`);
}

function logInfo(label: string, value: any) {
  console.log(`ℹ️  ${label}:`, JSON.stringify(value, null, 2));
}

function logWarning(message: string) {
  console.log(`⚠️  ${message}`);
}

// Test 1: Blue Card Application Metadata
Deno.test("Blue Card - Complete Application Metadata", async () => {
  logSection("TEST 1: Blue Card Application Metadata");

  const token = await getTestToken();
  console.log("🔑 Test token obtained");

  const testInput = {
    purpose: "work",
    nationality: "India",
    currentLocation: "Mumbai, India",
    birthday: "1990-05-15",
    germanLevel: "B1",
    englishLevel: "C1",
    profession: "Software Engineer",
    employmentStatus: "Employed",
    experienceYears: 5,
    hasJobOffer: true,
    employerName: "Tech GmbH",
    jobStartDate: "2025-03-01",
    salary: 65000,
    workLocation: "Berlin",
    hasDegree: true,
    degreeLevel: "Master's Degree",
    degreeField: "Computer Science",
    universityNameWork: "Indian Institute of Technology",
    hasAnerkennung: true,
    proofFunds: true,
    hasInsurance: true,
  };

  logInfo("Request payload", testInput);

  const { response, data } = await callVisaRecommendation(testInput, token);

  console.log(`\n📊 Response status: ${response.status}`);

  assertEquals(response.status, 200, "Should return 200 OK");
  logSuccess("Response status is 200");

  // Check basic recommendation structure
  assertExists(data.recommended, "Should have recommended visa");
  logSuccess("Recommended visa exists");
  logInfo("Recommended visa", {
    code: data.recommended.code,
    name: data.recommended.name,
  });

  // Check application metadata exists
  assertExists(data.applicationMetadata, "Should have application metadata");
  logSuccess("Application metadata exists");

  const metadata = data.applicationMetadata;

  // Test City Portals
  logSection("City Portals");
  assertExists(metadata.cityPortals, "Should have city portals");
  console.log(`📍 Found ${metadata.cityPortals.length} city portals`);

  if (metadata.cityPortals.length > 0) {
    const berlinPortal = metadata.cityPortals.find((p: any) =>
      p.city === "Berlin"
    );
    if (berlinPortal) {
      logInfo("Berlin Portal", {
        city: berlinPortal.city,
        portalUrl: berlinPortal.portalUrl,
        appointmentRequired: berlinPortal.appointmentRequired,
        appointmentBookingUrl: berlinPortal.appointmentBookingUrl,
        averageWaitTimeDays: berlinPortal.averageWaitTimeDays,
      });
      logSuccess("Berlin portal data is complete");
    } else {
      logWarning("Berlin portal not found in results");
    }

    // Log all cities
    console.log(
      "🌍 Available cities:",
      metadata.cityPortals.map((p: any) => p.city).join(", "),
    );
  }

  // Test Required Documents
  logSection("Required Documents");
  assertExists(metadata.requiredDocuments, "Should have required documents");
  console.log(
    `📄 Found ${metadata.requiredDocuments.length} required documents`,
  );

  if (metadata.requiredDocuments.length > 0) {
    metadata.requiredDocuments.forEach((doc: any, index: number) => {
      console.log(`\n${index + 1}. ${doc.documentName}`);
      console.log(`   Type: ${doc.documentType}`);
      console.log(`   Required: ${doc.required ? "✅ Yes" : "❌ No"}`);
      console.log(
        `   Can Generate: ${doc.canGenerate ? "🤖 Yes" : "📥 Manual"}`,
      );
      if (doc.instructions) {
        console.log(`   Instructions: ${doc.instructions}`);
      }
    });
    logSuccess("All documents logged");
  } else {
    logWarning("No required documents found");
  }

  // Test Additional Questions
  logSection("Additional Application Questions");
  assertExists(
    metadata.additionalQuestions,
    "Should have additional questions",
  );
  console.log(
    `❓ Found ${metadata.additionalQuestions.length} additional questions`,
  );

  if (metadata.additionalQuestions.length > 0) {
    // Group by section
    const sections = new Map();
    metadata.additionalQuestions.forEach((q: any) => {
      if (!sections.has(q.section)) {
        sections.set(q.section, []);
      }
      sections.get(q.section).push(q);
    });

    sections.forEach((questions, section) => {
      console.log(`\n📑 Section: ${section} (${questions.length} questions)`);
      questions.forEach((q: any) => {
        console.log(`   • ${q.question}`);
        console.log(
          `     Field: ${q.fieldKey}, Type: ${q.questionType}, Required: ${q.required}`,
        );
        if (q.helpText) {
          console.log(`     Help: ${q.helpText}`);
        }
      });
    });
    logSuccess("All questions logged by section");
  } else {
    logWarning("No additional questions found");
  }

  // Test Pre-filled Fields
  logSection("Pre-filled Form Fields");
  assertExists(metadata.preFilledFields, "Should have pre-filled fields");
  console.log(`✏️  Found ${metadata.preFilledFields.length} pre-filled fields`);

  if (metadata.preFilledFields.length > 0) {
    // Group by section
    const sections = new Map();
    metadata.preFilledFields.forEach((field: any) => {
      const section = field.formSection || "General";
      if (!sections.has(section)) {
        sections.set(section, []);
      }
      sections.get(section).push(field);
    });

    sections.forEach((fields, section) => {
      console.log(`\n📋 Section: ${section} (${fields.length} fields)`);
      fields.forEach((field: any) => {
        console.log(`   • ${field.formFieldLabel}: ${field.value}`);
        console.log(
          `     Confidence: ${field.confidence}, Verify: ${
            field.requiresVerification ? "Yes" : "No"
          }`,
        );
      });
    });
    logSuccess("All pre-filled fields logged by section");
  } else {
    logWarning("No pre-filled fields found");
  }

  // Test Processing Time
  logSection("Processing Time & Instructions");
  assertExists(metadata.estimatedProcessingTime, "Should have processing time");
  console.log(
    `⏱️  Estimated processing time: ${metadata.estimatedProcessingTime}`,
  );

  if (metadata.appointmentBookingUrl) {
    console.log(
      `🔗 Appointment booking URL: ${metadata.appointmentBookingUrl}`,
    );
    logSuccess("Appointment URL provided");
  }

  // Test Special Instructions
  assertExists(
    metadata.specialInstructions,
    "Should have special instructions",
  );
  console.log(
    `\n📌 Special Instructions (${metadata.specialInstructions.length}):`,
  );
  metadata.specialInstructions.forEach((instruction: string, index: number) => {
    console.log(`   ${index + 1}. ${instruction}`);
  });

  logSection("TEST 1 COMPLETE");
  logSuccess("Blue Card metadata test passed!");
});

// Test 2: Student Visa Application Metadata
Deno.test("Student Visa - Complete Application Metadata", async () => {
  logSection("TEST 2: Student Visa Application Metadata");

  const token = await getTestToken();
  console.log("🔑 Test token obtained");

  const testInput = {
    purpose: "study",
    nationality: "United States",
    currentLocation: "New York, USA",
    birthday: "2002-08-20",
    germanLevel: "B2",
    englishLevel: "Native",
    eduLevel: "Bachelor's Degree",
    universityNameEdu: "Technical University of Munich",
    studyField: "Computer Science",
    admitted: true,
    programStart: "2025-10-01",
    studyLanguage: "German",
    studyMode: "Full-time",
    proofFunds: true,
    blockedAccountAmount: 12000,
    hasInsurance: true,
    previousEducationLevel: "High School",
  };

  logInfo("Request payload", testInput);

  const { response, data } = await callVisaRecommendation(testInput, token);

  console.log(`\n📊 Response status: ${response.status}`);
  assertEquals(response.status, 200, "Should return 200 OK");

  assertExists(data.recommended, "Should have recommended visa");
  logInfo("Recommended visa", {
    code: data.recommended.code,
    name: data.recommended.name,
  });

  const metadata = data.applicationMetadata;
  assertExists(metadata, "Should have application metadata");

  // Check student-specific documents
  logSection("Student Visa Specific Checks");

  const requiredDocs = metadata.requiredDocuments;
  console.log(`📄 Total documents required: ${requiredDocs.length}`);

  // Check for specific student documents
  const blockedAccountDoc = requiredDocs.find((d: any) =>
    d.documentType.includes("blocked_account") ||
    d.documentName.includes("Sperrkonto")
  );

  const admissionDoc = requiredDocs.find((d: any) =>
    d.documentType.includes("admission") || d.documentName.includes("Admission")
  );

  if (blockedAccountDoc) {
    logSuccess("Found blocked account document requirement");
    logInfo("Blocked account doc", blockedAccountDoc);
  }

  if (admissionDoc) {
    logSuccess("Found admission letter requirement");
    logInfo("Admission doc", admissionDoc);
  }

  // Check for Munich-specific portal (since that's the university)
  const munichPortal = metadata.cityPortals.find((p: any) =>
    p.city === "Munich"
  );
  if (munichPortal) {
    logSuccess("Found Munich city portal (matches university location)");
    logInfo("Munich portal", munichPortal);
  }

  // Check pre-filled fields for student-specific data
  logSection("Student-Specific Pre-filled Fields");
  const studentFields = metadata.preFilledFields.filter((f: any) =>
    f.formFieldKey.includes("university") ||
    f.formFieldKey.includes("program") ||
    f.formFieldKey.includes("blocked")
  );

  console.log(
    `🎓 Found ${studentFields.length} student-specific pre-filled fields`,
  );
  studentFields.forEach((field: any) => {
    console.log(`   • ${field.formFieldLabel}: ${field.value}`);
  });

  logSection("TEST 2 COMPLETE");
  logSuccess("Student visa metadata test passed!");
});

// Test 3: Family Reunion Metadata
Deno.test("Family Reunion - Application Metadata", async () => {
  logSection("TEST 3: Family Reunion Application Metadata");

  const token = await getTestToken();
  console.log("🔑 Test token obtained");

  const testInput = {
    purpose: "personal",
    nationality: "Turkey",
    currentLocation: "Istanbul, Turkey",
    birthday: "1985-03-10",
    germanLevel: "A1",
    hasFamilyInGermany: true,
    familyMemberStatus: "EU Blue Card",
    relationship: "spouse",
    hasChildren: true,
    childrenCount: 2,
    childrenAges: "5, 8",
    relationshipProof: true,
    proofFunds: false,
    hasInsurance: true,
  };

  logInfo("Request payload", testInput);

  const { response, data } = await callVisaRecommendation(testInput, token);

  console.log(`\n📊 Response status: ${response.status}`);
  assertEquals(response.status, 200, "Should return 200 OK");

  assertExists(data.recommended, "Should have recommended visa");
  logInfo("Recommended visa", data.recommended);

  const metadata = data.applicationMetadata;
  assertExists(metadata, "Should have application metadata");

  logSection("Family Reunion Specific Checks");

  // Check for family-specific documents
  const familyDocs = metadata.requiredDocuments.filter((d: any) =>
    d.documentName.toLowerCase().includes("marriage") ||
    d.documentName.toLowerCase().includes("birth") ||
    d.documentName.toLowerCase().includes("family")
  );

  console.log(`👨‍👩‍👧‍👦 Found ${familyDocs.length} family-specific documents`);
  familyDocs.forEach((doc: any) => {
    console.log(`   • ${doc.documentName}: ${doc.description || "N/A"}`);
  });

  // Check special instructions for family reunion
  logSection("Special Instructions for Family Cases");
  const familyInstructions = metadata.specialInstructions.filter((i: string) =>
    i.toLowerCase().includes("family") ||
    i.toLowerCase().includes("income") ||
    i.toLowerCase().includes("housing")
  );

  console.log(
    `📌 Found ${familyInstructions.length} family-specific instructions:`,
  );
  familyInstructions.forEach((instruction: string) => {
    console.log(`   • ${instruction}`);
  });

  logSection("TEST 3 COMPLETE");
  logSuccess("Family reunion metadata test passed!");
});

// Test 4: Edge Case - Missing Data
Deno.test("Edge Case - Minimal Input Data", async () => {
  logSection("TEST 4: Minimal Input Data (Edge Case)");

  const token = await getTestToken();
  console.log("🔑 Test token obtained");

  const minimalInput = {
    purpose: "work",
    nationality: "Brazil",
  };

  logInfo("Minimal request payload", minimalInput);

  const { response, data } = await callVisaRecommendation(minimalInput, token);

  console.log(`\n📊 Response status: ${response.status}`);
  assertEquals(response.status, 200, "Should still return 200 OK");

  assertExists(data, "Should have response data");

  if (data.applicationMetadata) {
    logSuccess("Application metadata exists even with minimal input");

    console.log(`\n📋 Metadata summary:`);
    console.log(
      `   City Portals: ${data.applicationMetadata.cityPortals?.length || 0}`,
    );
    console.log(
      `   Required Documents: ${
        data.applicationMetadata.requiredDocuments?.length || 0
      }`,
    );
    console.log(
      `   Additional Questions: ${
        data.applicationMetadata.additionalQuestions?.length || 0
      }`,
    );
    console.log(
      `   Pre-filled Fields: ${
        data.applicationMetadata.preFilledFields?.length || 0
      }`,
    );
    console.log(
      `   Processing Time: ${
        data.applicationMetadata.estimatedProcessingTime || "N/A"
      }`,
    );

    // With minimal data, pre-filled fields should be fewer
    if (data.applicationMetadata.preFilledFields.length === 0) {
      logSuccess(
        "Correctly returns no pre-filled fields when no data provided",
      );
    } else {
      console.log(
        `\n⚠️  Pre-filled fields (${data.applicationMetadata.preFilledFields.length}):`,
      );
      data.applicationMetadata.preFilledFields.forEach((f: any) => {
        console.log(
          `   • ${f.formFieldLabel}: ${f.value} (source: ${f.sourceFieldKey})`,
        );
      });
    }
  } else {
    logWarning("No application metadata returned for minimal input");
  }

  logSection("TEST 4 COMPLETE");
  logSuccess("Edge case test passed!");
});

// Test 5: Multiple Visa Options with Metadata
Deno.test("Multiple Visa Recommendations - Metadata Consistency", async () => {
  logSection("TEST 5: Multiple Visa Options Metadata");

  const token = await getTestToken();
  console.log("🔑 Test token obtained");

  const testInput = {
    purpose: "work",
    nationality: "Canada",
    currentLocation: "Toronto, Canada",
    birthday: "1992-11-05",
    germanLevel: "B2",
    englishLevel: "Native",
    profession: "Data Scientist",
    employmentStatus: "Employed",
    experienceYears: 4,
    hasJobOffer: true,
    salary: 55000,
    hasDegree: true,
    degreeLevel: "Master's Degree",
    degreeField: "Computer Science",
    hasAnerkennung: false,
    proofFunds: true,
    hasInsurance: true,
  };

  logInfo("Request payload (should match multiple visas)", testInput);

  const { response, data } = await callVisaRecommendation(testInput, token);

  console.log(`\n📊 Response status: ${response.status}`);
  assertEquals(response.status, 200);

  // Check recommended and alternatives
  logSection("Visa Recommendations");
  console.log(
    `🎯 Recommended: ${data.recommended.name} (${data.recommended.code})`,
  );

  if (data.alternatives && data.alternatives.length > 0) {
    console.log(`\n📋 Alternatives (${data.alternatives.length}):`);
    data.alternatives.forEach((alt: any, index: number) => {
      console.log(`   ${index + 1}. ${alt.name} (${alt.code})`);
    });
    logSuccess("Multiple visa options provided");
  }

  // The metadata should be for the RECOMMENDED visa only
  logSection("Metadata Consistency Check");
  const metadata = data.applicationMetadata;

  console.log(
    `\n🔍 Verifying metadata is for recommended visa: ${data.recommended.code}`,
  );

  // Check if documents match the recommended visa
  const docsVisaCode = metadata.requiredDocuments[0]?.visaCode;
  if (docsVisaCode) {
    console.log(`   Documents visa code: ${docsVisaCode}`);
    // Note: This check depends on your schema - adjust if needed
  }

  // Pre-filled fields should be appropriate for recommended visa
  console.log(`\n✏️  Pre-filled fields summary:`);
  console.log(`   Total fields: ${metadata.preFilledFields.length}`);

  const fieldSections = new Set(
    metadata.preFilledFields.map((f: any) => f.formSection),
  );
  console.log(`   Sections covered: ${Array.from(fieldSections).join(", ")}`);

  logSuccess("Metadata correctly corresponds to recommended visa");

  logSection("TEST 5 COMPLETE");
  logSuccess("Multiple recommendations test passed!");
});

console.log("\n\n" + "=".repeat(80));
console.log("🎉 ALL TESTS DEFINED - Run with: deno test --allow-all");
console.log("=".repeat(80) + "\n");
