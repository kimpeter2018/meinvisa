import { evaluateVisa } from "../lib/evaluateVisa.ts";

// Test Case 1: Perfect Blue Card candidate
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

console.log("Test 1: Perfect Blue Card");
console.log(JSON.stringify(evaluateVisa(test1), null, 2));

// Test Case 2: No job offer
const test2 = {
  purpose: "work",
  nationality: "India",
  hasJobOffer: false,
  hasDegree: true,
  hasAnerkennung: true,
  germanLevel: "A1",
  experienceYears: 2
};

console.log("\nTest 2: No job offer");
console.log(JSON.stringify(evaluateVisa(test2), null, 2));

// Test Case 3: IT without degree
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

console.log("\nTest 3: IT without degree");
console.log(JSON.stringify(evaluateVisa(test3), null, 2));