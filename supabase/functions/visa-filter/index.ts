// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// index.ts (Supabase Edge Function - Deno / TypeScript)
//
// Required environment variables:
// - SUPABASE_URL
// - SUPABASE_SERVICE_ROLE_KEY  (use service role for secure DB access)

// =============================================
// Supabase Edge Function: Visa Eligibility
// =============================================

// Enable Supabase Edge Runtime types

import { } from "https://deno.land/std@0.203.0/http/server.ts";
import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm";

// Environment variables (set these in Supabase Edge Function)
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// Utility: check if parent_condition matches submitted answers
function matchesCondition(
  condition: string | null,
  answers: Record<string, any>
): boolean {
  if (!condition) return false;
  const [field, value] = condition.split("=");

  // Make sure 'field' is a string and exists in answers
  if (!field || !(field in answers)) return false;

  return answers[field] === value;
}

Deno.serve(async (req) => {
  try {
    const body = await req.json();
    const answers = body.answers as Record<string, any>;
    if (!answers) {
      return new Response(JSON.stringify({ error: "Missing answers" }), { status: 400 });
    }

    // Fetch all visa info questions
    const { data: questions, error } = await supabase
      .from("visa_question")
      .select("id, category, field_key, question_text, parent_condition, question_type")
      .not("question_type", "eq", "select"); // only info questions

    if (error) {
      console.error(error);
      return new Response(JSON.stringify({ error: "Database fetch failed" }), { status: 500 });
    }

    if (!questions) {
      return new Response(JSON.stringify({ visas: {} }), { status: 200 });
    }

    // Filter eligible questions based on answers
    const eligibleQuestions = questions.filter((q: any) => matchesCondition(q.parent_condition, answers));

    // Group by category
    const groupedVisas: Record<string, any[]> = {};
      
    eligibleQuestions.forEach((q: any) => {
      const category = q.category ?? "uncategorized"; // fallback if undefined
      if (!groupedVisas[category]) groupedVisas[category] = [];
      groupedVisas[category].push({
        id: q.id,
        field_key: q.field_key,
        text: q.question_text
      });
    });

    return new Response(JSON.stringify({ visas: groupedVisas }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });

  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: "Invalid request" }), { status: 400 });
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
