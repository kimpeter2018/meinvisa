const TEST_URL = "http://127.0.0.1:54321/functions/v1/visa-filter";

// Example input payload
const payload1 = {
  occupation_code: "software_engineer",
  nationality: "IN",
  current_salary: 60000,
  has_recognition: false,
  age: 28,
  location_applied_from: "IN"
};

const payload2 = {
  occupation_code: "nurse",
  nationality: "KR",
  current_salary: 45000,
  has_recognition: false,
  age: 30,
  location_applied_from: "KR"
};

const payload3 = {
  occupation_code: "nurse",
  nationality: "VN",
  current_salary: 45000,
  has_recognition: true,
  age: 30,
  location_applied_from: "VN"
};

const payload4 = {
  occupation_code: "chef",
  nationality: "JP",
  current_salary: 20000,
  has_recognition: false,
  age: 25,
  location_applied_from: "JP"
};

const payload5 = {
  occupation_code: "mechanical_engineer",
  nationality: "CN",
  current_salary: 60000,
  has_recognition: false,
  age: 32,
  location_applied_from: "CN"
};

const testPayloads = [payload1, payload2, payload3, payload4, payload5];

async function testVisaEligibility() {
  for (const payload of testPayloads) {
    console.log("\n--- Testing:", payload.occupation_code, payload.nationality, "---");
    try {
      const res = await fetch(TEST_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"},
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      console.log(JSON.stringify(data, null, 2));
    } catch (err) {
      console.error("Error:", err);
    }
  }
}

testVisaEligibility();
