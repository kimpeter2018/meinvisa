// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

// index.ts (Supabase Edge Function - Deno / TypeScript)
//
// Required environment variables:
// - SUPABASE_URL
// - SUPABASE_SERVICE_ROLE_KEY  (use service role for secure DB access)


// =============================================
// Supabase Edge Function: Visa Eligibility
// =============================================

// Enable Supabase Edge Runtime types
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { serve } from "https://deno.land/std@0.203.0/http/server.ts";

// Supabase client for Edge Functions
import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm";

// Replace with your Supabase URL & anon key
 const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "http://localhost:54321";
  const SUPABASE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0e";

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY env vars");
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// Input payload type
interface VisaRequest {
  occupation_code: string;    // ex: 'software_engineer'
  nationality: string;        // ex: 'IN'
  current_salary?: number;    // optional
  has_recognition?: boolean;  // optional
  age?: number;               // optional
  location_applied_from?: string; // optional
}

// Output types
interface EligibleVisa {
  visa_type: string;
  reason: string;
  next_steps?: string[];
}

interface VisaResponse {
  eligible_visas: EligibleVisa[];
  ineligible_reasons: string[];
  confidence: "high" | "medium" | "low";
}

// Helper: fetch occupation by code
async function getOccupation(code: string) {
  const { data, error } = await supabase
    .from("occupation")
    .select("*")
    .eq("code", code)
    .single();

  if (error) throw new Error(`Occupation not found: ${code}`);
  return data;
}

// Helper: fetch visa paths for an occupation
async function getVisaPaths(occupation_id: string) {
  const { data, error } = await supabase
    .from("visa_path")
    .select("*, visa_type(*)")
    .eq("occupation_id", occupation_id);

  if (error) throw new Error(`Visa paths not found for occupation: ${occupation_id}`);
  return data;
}

// Helper: fetch country info
async function getCountry(iso_code: string) {
  const { data, error } = await supabase
    .from("country")
    .select("*")
    .eq("iso_code", iso_code)
    .single();

  if (error) throw new Error(`Country not found: ${iso_code}`);
  return data;
}

// Core evaluation logic
function evaluateVisaPaths(
  visaPaths: any[],
  occupation: any,
  request: VisaRequest
): VisaResponse {
  const eligible_visas: EligibleVisa[] = [];
  const ineligible_reasons: string[] = [];

  for (const vp of visaPaths) {
    const visa = vp.visa_type;

    // 1️⃣ Check recognition requirement
    if (vp.required_recognition && !request.has_recognition) {
      ineligible_reasons.push(
        `${visa.title} requires professional recognition for ${occupation.title}.`
      );
      continue; // skip this visa
    }

    // 2️⃣ Check salary thresholds
    const minSalary = vp.min_salary ?? visa.min_salary ?? 0;
    if (request.current_salary && request.current_salary < minSalary) {
      ineligible_reasons.push(
        `${visa.title} requires minimum salary of ${minSalary}, your salary is ${request.current_salary}.`
      );
      continue;
    }

    // 3️⃣ Additional conditional logic (example: shortage flag)
    let reason = `Eligible for ${visa.title}`;
    if (occupation.shortage_flag) reason += " (shortage occupation)";

    // 4️⃣ Determine next steps
    const next_steps: string[] = [];
    if (vp.required_recognition && !request.has_recognition) {
      next_steps.push("Apply for recognition certificate");
    }

    eligible_visas.push({
      visa_type: visa.code,
      reason,
      next_steps: next_steps.length > 0 ? next_steps : undefined,
    });
  }

  const confidence: "high" | "medium" | "low" =
    eligible_visas.length > 0 ? "high" : ineligible_reasons.length > 0 ? "medium" : "low";

  return { eligible_visas, ineligible_reasons, confidence };
}

// =============================================
// HTTP Handler
// =============================================
serve(async (req: Request) => {
  try {
    const body: VisaRequest = await req.json();

    if (!body.occupation_code || !body.nationality) {
      return new Response(
        JSON.stringify({ error: "occupation_code and nationality are required" }),
        { status: 400 }
      );
    }

    // Fetch occupation
    const occupation = await getOccupation(body.occupation_code);

    // Fetch visa paths
    const visaPaths = await getVisaPaths(occupation.id);

    // Optional: fetch country (to extend rules, e.g., visa-free)
    const country = await getCountry(body.nationality);

    // Evaluate eligibility
    const result = evaluateVisaPaths(visaPaths, occupation, body);

    // Optional: add note if country allows visa-free entry
    if (country.visa_free_for_visit) {
      result.ineligible_reasons.push(
        `Note: Your nationality (${country.name}) allows visa-free short-term visits.`
      );
    }

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});


/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/visa-filter' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{
  "nationality": "South Korea",
  "destination": "Germany",
  "purpose": "Work",
  "duration": 36,
  "hasOffer": true,
  "salary_amount": 62000,
  "salary_currency": "EUR",
  "salary_period": "year",
  "educationLevel": "Master's",
  "occupation_code": "SE-ENG-01",
  "age": 29
}'

*/
