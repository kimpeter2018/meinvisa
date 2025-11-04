import { evaluateVisa } from "../lib/evaluateVisa.ts";

// Test 1: Work - Perfect Blue Card
console.log("=== Test 1: Perfect Blue Card ===");
const test1 = {
  purpose: "work",
  nationality: "United States",
  hasJobOffer: true,
  hasDegree: true,
  hasAnerkennung: true,
  salary: 65000,
  germanLevel: "B1",
  experienceYears: 4
};
console.log(JSON.stringify(evaluateVisa(test1), null, 2));

// Test 2: Work - No job offer (should suggest Job Seeker)
console.log("\n=== Test 2: No Job Offer ===");
const test2 = {
  purpose: "work",
  nationality: "India",
  hasJobOffer: false,
  hasDegree: true,
  hasAnerkennung: true,
  germanLevel: "A1",
  experienceYears: 2
};
console.log(JSON.stringify(evaluateVisa(test2), null, 2));

// Test 3: Work - IT without degree
console.log("\n=== Test 3: IT Specialist ===");
const test3 = {
  purpose: "work",
  nationality: "Brazil",
  hasJobOffer: true,
  hasDegree: false,
  isItField: true,
  itExperience: true,
  salary: 55000,
  germanLevel: "A2",
  experienceYears: 5
};
console.log(JSON.stringify(evaluateVisa(test3), null, 2));

// Test 4: Education - Student visa
console.log("\n=== Test 4: Student ===");
const test4 = {
  purpose: "education",
  nationality: "China",
  admitted: true,
  eduLevel: "university",
  studyField: "Computer Science",
  proofFunds: true,
  germanLevel: "B2",
  hasInsurance: true
};
console.log(JSON.stringify(evaluateVisa(test4), null, 2));

// Test 5: Specialized - Researcher
console.log("\n=== Test 5: Researcher ===");
const test5 = {
  purpose: "research",
  nationality: "United States",
  hasHostAgreement: true,
  researchFunded: true,
  hasDegree: true,
  hasInsurance: true
};
console.log(JSON.stringify(evaluateVisa(test5), null, 2));

// Test 6: Specialized - Artist
console.log("\n=== Test 6: Artist ===");
const test6 = {
  purpose: "culture",
  nationality: "France",
  hasPerformance: true,
  performanceCount: 3,
  hasHostContract: true,
  proofFunds: true
};
console.log(JSON.stringify(evaluateVisa(test6), null, 2));

// Test 7: Personal - Family Reunion
console.log("\n=== Test 7: Family Reunion ===");
const test7 = {
  purpose: "personal",
  nationality: "Turkey",
  hasFamilyInGermany: true,
  personalRoute: "spouse",
  germanLevel: "A1",
  proofFunds: true,
  hasInsurance: true
};
console.log(JSON.stringify(evaluateVisa(test7), null, 2));

// Test 8: Personal - Au Pair
console.log("\n=== Test 8: Au Pair ===");
const test8 = {
  purpose: "personal",
  nationality: "Colombia",
  personalRoute: "au pair",
  hasHostContract: true,
  age: 22,
  germanLevel: "A2"
};
console.log(JSON.stringify(evaluateVisa(test8), null, 2));