import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { recommendationHandler } from "./handlers/recommendationHandler.ts";
import { handleError } from "./_shared/utils/errorHandler.ts";

serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method Not Allowed", { status: 405 });
    }

    const payload = await req.json();
    const result = await recommendationHandler(payload);

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0",
      },
    });
  } catch (err) {
    return handleError(err);
  }
});

// // Follow this setup guide to integrate the Deno language server with your editor:
// // https://deno.land/manual/getting_started/setup_your_environment
// // This enables autocomplete, go to definition, etc.

// // index.ts (Supabase Edge Function - Deno / TypeScript)
// //
// // Required environment variables:
// // - SUPABASE_URL
// // - SUPABASE_SERVICE_ROLE_KEY  (use service role for secure DB access)

// // =============================================
// // Supabase Edge Function: Visa Eligibility
// // =============================================

// // Enable Supabase Edge Runtime types

// import "jsr:@supabase/functions-js/edge-runtime.d.ts";
// import { serve } from "https://deno.land/std@0.203.0/http/server.ts";
// import { supabase } from "./lib/supabaseClient.ts";
// import { logInfo, logError } from "./lib/logger.ts";
// import { normalizeAnswers } from "./_shared/utils/normalizeRequest.ts";

// // Supabase client for Edge Functions
// import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm";

// // Replace with your Supabase URL & anon key
//  const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "http://localhost:54321";
//   const SUPABASE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
//     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0e";

// if (!SUPABASE_URL || !SUPABASE_KEY) {
//   console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY env vars");
// }

// const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// // ----- Types: request + response -----
// interface VisaRequest {
//   // fields mapped from your questionnaire
//   purpose_of_stay?: string;         // "Work", "Study", ...
//   occupation?: string;              // occupation code or id (from options "occupation")
//   regulated_in_germany?: string;    // "Yes" | "No"
//   work_experience_years?: number;
//   shortage_field?: string;          // "Yes" | "No"
//   job_offer?: string;               // "Yes" | "No"
//   is_employed?: string;             // "Yes" | "No"
//   education_level?: string;         // "High School" | "Bachelor" | ...
//   citizenship_country?: string;     // ISO code or db key
//   residence_country?: string;
//   has_sufficient_funds?: string;    // "Yes" | "No"
//   financial_proof?: string;         // "Yes" | "No"
//   sponsored?: string;               // "Yes" | "No"
//   monthly_income?: number;          // numeric (EUR)
//   age?: number;
// }

// // Output types
// interface EligibleVisa {
//   visa_type: string;
//   reason: string;
//   next_steps?: string[];
// }

// interface VisaResponse {
//   eligible_visas: EligibleVisa[];
//   ineligible_reasons: string[];
//   confidence: "high" | "medium" | "low";
// }

// // ----- Helpers: DB lookups -----
// async function getOccupation(codeOrId: string) {
//   // try code then id
//   let q = supabase.from("occupation").select("*").eq("code", codeOrId).maybeSingle();
//   let { data, error } = await q;
//   if (!data) {
//     const res = await supabase.from("occupation").select("*").eq("id", codeOrId).single();
//     data = res.data;
//     error = res.error;
//   }
//   if (error || !data) throw new Error(`Occupation not found: ${codeOrId}`);
//   return data;
// }

// async function getVisaPaths(occupation_id: string) {
//   const { data, error } = await supabase
//     .from("visa_path")
//     .select("*, visa_type(*)")
//     .eq("occupation_id", occupation_id);
//   if (error) throw new Error(`Visa paths not found for occupation: ${occupation_id}`);
//   return data ?? [];
// }

// async function getCountry(iso_code: string) {
//   const { data, error } = await supabase
//     .from("country")
//     .select("*")
//     .ilike("iso_code", iso_code)
//     .maybeSingle();
//   if (error) throw new Error(`Country lookup error: ${iso_code}`);
//   return data ?? null;
// }

// // Core evaluation logic
// function evaluateVisaPaths(
//   visaPaths: any[],
//   occupation: any,
//   request: VisaRequest
// ): VisaResponse {
//   const eligible_visas: EligibleVisa[] = [];
//   const ineligible_reasons: string[] = [];

//   for (const vp of visaPaths) {
//     const visa = vp.visa_type;

//     // 1️⃣ Check recognition requirement
//     if (vp.required_recognition && !request.has_recognition) {
//       ineligible_reasons.push(
//         `${visa.title} requires professional recognition for ${occupation.title}.`
//       );
//       continue; // skip this visa
//     }

//     // 2️⃣ Check salary thresholds
//     const minSalary = vp.min_salary ?? visa.min_salary ?? 0;
//     if (request.current_salary && request.current_salary < minSalary) {
//       ineligible_reasons.push(
//         `${visa.title} requires minimum salary of ${minSalary}, your salary is ${request.current_salary}.`
//       );
//       continue;
//     }

//     // 3️⃣ Additional conditional logic (example: shortage flag)
//     let reason = `Eligible for ${visa.title}`;
//     if (occupation.shortage_flag) reason += " (shortage occupation)";

//     // 4️⃣ Determine next steps
//     const next_steps: string[] = [];
//     if (vp.required_recognition && !request.has_recognition) {
//       next_steps.push("Apply for recognition certificate");
//     }

//     eligible_visas.push({
//       visa_type: visa.code,
//       reason,
//       next_steps: next_steps.length > 0 ? next_steps : undefined,
//     });
//   }

//   const confidence: "high" | "medium" | "low" =
//     eligible_visas.length > 0 ? "high" : ineligible_reasons.length > 0 ? "medium" : "low";

//   return { eligible_visas, ineligible_reasons, confidence };
// }

// // =============================================
// // HTTP Handler
// // =============================================
// serve(async (req: Request) => {
//   try {
//     const body: VisaRequest = await req.json();

//     if (!body.occupation_code || !body.nationality) {
//       return new Response(
//         JSON.stringify({ error: "occupation_code and nationality are required" }),
//         { status: 400 }
//       );
//     }

//     // Fetch occupation
//     const occupation = await getOccupation(body.occupation_code);

//     // Fetch visa paths
//     const visaPaths = await getVisaPaths(occupation.id);

//     // Optional: fetch country (to extend rules, e.g., visa-free)
//     const country = await getCountry(body.nationality);

//     // Evaluate eligibility
//     const result = evaluateVisaPaths(visaPaths, occupation, body);

//     // Optional: add note if country allows visa-free entry
//     if (country.visa_free_for_visit) {
//       result.ineligible_reasons.push(
//         `Note: Your nationality (${country.name}) allows visa-free short-term visits.`
//       );
//     }

//     return new Response(JSON.stringify(result), {
//       status: 200,
//       headers: { "Content-Type": "application/json" },
//     });
//   } catch (err: any) {
//     return new Response(JSON.stringify({ error: err.message }), {
//       status: 500,
//       headers: { "Content-Type": "application/json" },
//     });
//   }
// });

// /* To invoke locally:

//   1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
//   2. Make an HTTP request:

//   curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/visa-filter' \
//     --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//     --header 'Content-Type: application/json' \
//     --data '{
//   "nationality": "South Korea",
//   "destination": "Germany",
//   "purpose": "Work",
//   "duration": 36,
//   "hasOffer": true,
//   "salary_amount": 62000,
//   "salary_currency": "EUR",
//   "salary_period": "year",
//   "educationLevel": "Master's",
//   "occupation_code": "SE-ENG-01",
//   "age": 29
// }'

// */
