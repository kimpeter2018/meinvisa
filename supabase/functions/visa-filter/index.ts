// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

// index.ts (Supabase Edge Function - Deno / TypeScript)
// Place under: /supabase/functions/visa-filter/index.ts
//
// Required environment variables:
// - SUPABASE_URL
// - SUPABASE_SERVICE_ROLE_KEY  (use service role for secure DB access)
// - OPTIONAL: FX_RATES as JSON string ({"KRW":0.00068,"TRY":0.033,"USD":0.92,"EUR":1})
//
// Note: In production, replace the simple FX converter with a proper FX API.

import { } from "https://deno.land/std@0.201.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type UserInput = {
  nationality: string;         // e.g. "South Korea"
  residence?: string;
  destination: string;         // e.g. "Germany"
  purpose: "Work" | "Study" | "Tourism" | "Family" | string;
  duration?: number;           // months
  hasOffer?: boolean;
  salary_amount?: number;      // numeric salary value
  salary_currency?: string;    // "KRW" | "TRY" | "EUR" | "USD"
  salary_period?: "year" | "month";
  age?: number;
  educationLevel?: string;     // "High school", "Bachelor’s", "Master’s", "PhD"
  occupation_code?: string;    // optional occupation code / label
  contract_type?: string;      // "Permanent","Fixed-term","Seasonal","Internship","Part-time","Full-time","Remote"
  license_documented?: boolean;
  preferred_subtype?: string;  // e.g. "EU Blue Card", "Freelancer"
  hasFunds?: boolean;
  hasInsurance?: boolean;
  intend_family_reunion?: boolean;
  [k: string]: any;
};

  const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "http://localhost:54321";
  const SUPABASE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0e";

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY env vars");
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY, {
  auth: { persistSession: false },
});

const DEFAULT_FX = { KRW: 0.00068, TRY: 0.033, USD: 0.92, EUR: 1 };
const FX_RATES = (() => {
  const env = Deno.env.get("FX_RATES");
  if (!env) return DEFAULT_FX;
  try {
    return { ...DEFAULT_FX, ...JSON.parse(env) };
  } catch {
    return DEFAULT_FX;
  }
})();

function convertToAnnualEUR(amount: number, currency: string | undefined, period: "year" | "month" | undefined) {
  if (!amount || !currency || !period) return null;
  const rate = FX_RATES[currency] ?? null;
  if (!rate) return null;
  const eur = amount * rate;
  return period === "month" ? eur * 12 : eur;
}

function safeNumber(value: any) {
  if (value === undefined || value === null) return null;
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
}

function reasonsAdd(arr: string[], reason: string) {
  if (!arr.includes(reason)) arr.push(reason);
}

// scoring helper that returns {score, reasons[], passedStrict}
function evaluateVisaAgainstUser(visa: any, ui: UserInput, shortages: Record<string, number> | null) {
  // visa is a DB row
  const reasons: string[] = [];
  let score = 0;
  let passedStrict = true;

  const elig = visa.eligibility ?? {};
  const cond = visa.conditions ?? {};

  // 1) nationality allowance / restriction
  if (elig.allowedNationalities && Array.isArray(elig.allowedNationalities)) {
    if (elig.allowedNationalities.length > 0) {
      if (elig.allowedNationalities.includes(ui.nationality)) {
        score += 20;
        reasonsAdd(reasons, "Nationality allowed specifically for this visa.");
      } else {
        // not explicitly allowed; soft-penalize rather than reject, since many visas allow any nationality
        score -= 5;
        reasonsAdd(reasons, "Visa not specifically targeted for your nationality.");
      }
    }
  }

  // 2) purpose / category match
  if (visa.category && ui.purpose && visa.category.toLowerCase() === ui.purpose.toLowerCase()) {
    score += 30;
    reasonsAdd(reasons, `Purpose matches visa category (${visa.category}).`);
  } else {
    // if user is applying for Work but visa is Study, penalize strongly (strict mismatch)
    if (ui.purpose && ui.purpose.toLowerCase() !== (visa.category ?? "").toLowerCase()) {
      score -= 30;
      reasonsAdd(reasons, `Purpose mismatch: you selected ${ui.purpose} but this visa is ${visa.category}.`);
      passedStrict = false;
    }
  }

  // 3) duration checks
  const desiredMonths = safeNumber(ui.duration);
  if (visa.duration_months && desiredMonths != null) {
    if (desiredMonths <= visa.duration_months) {
      score += 5;
      reasonsAdd(reasons, `Requested duration (${desiredMonths}m) fits visa duration (${visa.duration_months}m).`);
    } else {
      score -= 10;
      reasonsAdd(reasons, `Requested duration (${desiredMonths}m) exceeds typical visa duration (${visa.duration_months}m).`);
      // not necessarily strict fail; e.g., ask for longer initially but could extend.
    }
  }

  // 4) Offer / sponsorship
  const requiresOffer = !!elig.requiresOffer || !!visa.sponsorship_required || false;
  if (requiresOffer) {
    if (ui.hasOffer) {
      score += 20;
      reasonsAdd(reasons, "You have a job/university offer required by this visa.");
    } else {
      score -= 40;
      reasonsAdd(reasons, "Visa requires an offer/sponsorship which you do not have.");
      passedStrict = false; // strict
    }
  } else {
    // visa not requiring offer: good for freelancers, job seeker, etc.
    score += 5;
  }

  // 5) salary threshold (work-related)
  if (visa.min_salary_year) {
    const userAnnual = convertToAnnualEUR(ui.salary_amount ?? 0, ui.salary_currency ?? "EUR", ui.salary_period ?? "year");
    if (userAnnual == null) {
      // Can't compute — penalize but not strict fail
      score -= 10;
      reasonsAdd(reasons, "Cannot verify salary against threshold (missing currency/period).");
    } else {
      if (userAnnual >= Number(visa.min_salary_year)) {
        score += 30;
        reasonsAdd(reasons, `Salary meets threshold (€${Math.round(userAnnual)}/year >= €${visa.min_salary_year}).`);
      } else {
        // If visa subtype has shortage threshold (minSalary_shortage) handle
        const shortageThreshold = (visa.eligibility && visa.eligibility.minSalary_shortage) ?? null;
        if (shortageThreshold && userAnnual >= shortageThreshold) {
          score += 20;
          reasonsAdd(reasons, `Salary meets shortage/discounted threshold (€${Math.round(userAnnual)}/year >= €${shortageThreshold}).`);
        } else {
          score -= 40;
          reasonsAdd(reasons, `Salary below required threshold (€${Math.round(userAnnual)}/year < €${visa.min_salary_year}).`);
          passedStrict = false;
        }
      }
    }
  }

  // 6) degree / education requirements
  if (elig.degreeRequired || visa.degreeRequired) {
    const degreesAccept = ["Bachelor", "Master", "PhD", "Bachelor’s", "Master’s"];
    const level = ui.educationLevel ?? "";
    if (degreesAccept.some(d => level.includes(d))) {
      score += 15;
      reasonsAdd(reasons, "Education level meets degree requirement.");
    } else {
      score -= 25;
      reasonsAdd(reasons, "Visa requires recognized degree which you did not indicate.");
      passedStrict = false;
    }
  }

  // 7) regulated professions (doctors, nurses, lawyers, etc.)
  if (visa.regulated_profession) {
    if (ui.license_documented) {
      score += 20;
      reasonsAdd(reasons, "You have documented the profession-specific license required.");
    } else {
      score -= 50;
      reasonsAdd(reasons, "Regulated profession requires license/recognition which is missing.");
      passedStrict = false;
    }
  }

  // 8) occupation match and shortages
  if (ui.occupation_code && Array.isArray(visa.occupation_codes) && visa.occupation_codes.length > 0) {
    if (visa.occupation_codes.includes(ui.occupation_code)) {
      score += 20;
      reasonsAdd(reasons, "Your occupation matches the visa's listed occupations.");
    } else {
      // no direct match; check country-level shortages (passed in shortages map)
      if (shortages && ui.occupation_code && shortages[ui.occupation_code]) {
        score += 12;
        reasonsAdd(reasons, "Occupation is listed as a shortage occupation in destination country.");
      } else {
        score -= 5;
        reasonsAdd(reasons, "Occupation does not match listed occupation codes for this visa.");
      }
    }
  } else if (shortages && ui.occupation_code && shortages[ui.occupation_code]) {
    score += 12;
    reasonsAdd(reasons, "Occupation is listed as a shortage occupation in destination country.");
  }

  // 9) age and working holidays
  if (visa.subcategory && visa.subcategory.toLowerCase().includes("working holiday")) {
    if (elig.maxAge && ui.age && ui.age <= elig.maxAge) {
      score += 15;
      reasonsAdd(reasons, "Age is within working holiday limits.");
    } else {
      score -= 40;
      reasonsAdd(reasons, "Age exceeds the maximum for Working Holiday visa.");
      passedStrict = false;
    }
  }

  // 10) Self-employment / freelancer handling
  if (visa.subcategory && /freelancer|self/i.test(String(visa.subcategory))) {
    if (ui.self_employed_plan || ui.business_plan_uploaded) {
      score += 20;
      reasonsAdd(reasons, "You indicated a self-employment plan / business plan.");
    } else {
      score -= 20;
      reasonsAdd(reasons, "Freelancer visa expects a business plan or proof of clients.");
      // not always strict fail — user could prepare documents
    }
  }

  // 11) funds and insurance (study/tourism)
  if (visa.category === "Study" || visa.category === "Tourism") {
    if (ui.hasFunds || (elig.minFunds && ui.hasFunds)) {
      score += 10;
      reasonsAdd(reasons, "Financial means indicated.");
    } else if (elig.minFunds) {
      score -= 20;
      reasonsAdd(reasons, "Required proof of funds missing.");
      passedStrict = false;
    }
    if (ui.hasInsurance !== false && (ui.hasInsurance || ui.hasInsurance === true)) {
      score += 5;
      reasonsAdd(reasons, "Health insurance confirmed.");
    } else if (elig.requiresInsurance && !ui.hasInsurance) {
      score -= 10;
      reasonsAdd(reasons, "Health insurance required but not indicated.");
    }
  }

  // 12) employer sponsorship/license checks (if present in eligibility)
  if (elig.employerMustBeMultinational && ui.employer_registered !== true) {
    score -= 50;
    reasonsAdd(reasons, "This visa requires multinational employer registration; employer not registered.");
    passedStrict = false;
  }

  // 13) family reunion preference
  if (ui.intend_family_reunion && visa.conditions?.family_reunion) {
    score += 10;
    reasonsAdd(reasons, "Visa supports family reunion.");
  }

  // 14) small bonus for matching preferred subtype
  if (ui.preferred_subtype && visa.subcategory && ui.preferred_subtype === visa.subcategory) {
    score += 8;
    reasonsAdd(reasons, `Matches your preferred subtype (${ui.preferred_subtype}).`);
  }

  // Ensure score bounded
  if (score < -100) score = -100;
  if (score > 200) score = 200;

  return { score, reasons, passedStrict };
}

Deno.serve(async (req: Request) => {
  console.log("Function called");
  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "Only POST allowed. Send user data JSON." }), { status: 405 });
    }

    const body = await req.json().catch(() => null);
    console.log("Request body:", body);
    if (!body) {
      return new Response(JSON.stringify({ error: "Invalid or missing JSON body." }), { status: 400 });
    }

    const ui: UserInput = body as UserInput;

    // Basic validation
    const required = ["nationality", "destination", "purpose"];
    for (const k of required) {
      if (!ui[k]) {
        return new Response(JSON.stringify({ error: `Missing required field: ${k}` }), { status: 400 });
      }
    }

    // Fetch visa types for destination
    const { data: visas, error: visasErr } = await supabase
      .from("visa_types")
      .select("*")
      .eq("country", ui.destination);

    if (visasErr) throw visasErr;
    if (!Array.isArray(visas) || visas.length === 0) {
      return new Response(JSON.stringify({ error: "No visa types found for destination." }), { status: 404 });
    }

    // Fetch occupation shortages map (optional)
    const { data: shortagesArr } = await supabase
      .from("occupation_shortages")
      .select("occupation_code, priority")
      .eq("country", ui.destination);

    const shortageMap: Record<string, number> | null = Array.isArray(shortagesArr)
      ? shortagesArr.reduce((acc: any, row: any) => ({ ...acc, [row.occupation_code]: row.priority ?? 1 }), {})
      : null;

    // Optionally filter visas by category/purpose and preferred_subtype
    let candidateVisas = visas.filter((v: any) => {
      // keep visas with matching category OR keep everything (we'll penalize mismatches)
      return true; // we'll let scoring handle mismatches but could pre-filter by v.category === ui.purpose
    });

    if (ui.preferred_subtype) {
      const withPref = candidateVisas.filter((v: any) => v.subcategory === ui.preferred_subtype);
      if (withPref.length > 0) candidateVisas = withPref;
    }

    // Evaluate all candidates
    const evaluated = candidateVisas.map((v: any) => {
      const { score, reasons, passedStrict } = evaluateVisaAgainstUser(v, ui, shortageMap);
      // add metadata
      return {
        visa: {
          id: v.id,
          visa_name: v.visa_name,
          country: v.country,
          category: v.category,
          subcategory: v.subcategory,
          duration_months: v.duration_months,
          requirements: v.requirements,
          eligibility: v.eligibility,
          conditions: v.conditions,
          description: v.description,
          min_salary_year: v.min_salary_year ?? v.eligibility?.minSalary ?? null,
        },
        score,
        reasons,
        passedStrict,
      };
    });

    // Sort primarily by passedStrict descending, then by score desc
    evaluated.sort((a, b) => {
      if ((b.passedStrict === true) !== (a.passedStrict === true)) return (b.passedStrict === true ? 1 : 0) - (a.passedStrict === true ? 1 : 0);
      return b.score - a.score;
    });

    // Build response: best match + up to 4 alternatives + full candidate list
    const best = evaluated[0] ?? null;
    const alternatives = evaluated.slice(1, 5);

    const response = {
      query: ui,
      best_match: best,
      alternatives,
      all_candidates_count: evaluated.length,
      notes: [
        "Scores are indicative. Strict failures are flagged by passedStrict=false.",
        "Salary conversion uses built-in FX rates — replace with FX API in production.",
        "Admin-updatable thresholds (min_salary_year, occupation shortages) recommended in DB."
      ]
    };
    console.log("Result:", response);

    return new Response(JSON.stringify(response, null, 2), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });

  } catch (err: any) {
    console.error("Visa filter error:", err);
    return new Response(JSON.stringify({ error: err?.message ?? String(err) }), { status: 500 });
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
