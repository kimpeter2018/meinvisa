// services/visaService.ts
import { supabase } from "../_shared/supabaseClient.ts";
import { EligibilityResult, Visa, VisaRequest } from "../models/visaModels.ts";

export async function getVisaRecommendations(request: VisaRequest) {
  // 1️⃣ fetch occupation
  const occupation = await supabase
    .from("occupation")
    .select("*")
    .eq("code", request.occupation)
    .single()
    .then((res) => {
      if (res.error) {
        throw new Error(`Occupation not found: ${request.occupation}`);
      }
      return res.data;
    });

  // 2️⃣ fetch visa paths
  const visaPaths = await supabase
    .from("visa_path")
    .select("*, visa_type(*)")
    .eq("occupation_id", occupation.id);

  if (visaPaths.error) throw new Error("Visa paths not found");

  // 3️⃣ fetch country info if needed
  const country = request.citizenship_country
    ? await supabase
      .from("country")
      .select("*")
      .eq("iso_code", request.citizenship_country)
      .single()
      .then((res) => {
        if (res.error) throw new Error("Country not found");
        return res.data;
      })
    : null;

  // 4️⃣ Evaluate eligibility
  const eligibleVisas: any[] = [];
  const ineligibleReasons: string[] = [];

  for (const vp of visaPaths.data) {
    const visa = vp.visa_type;

    // Example checks
    if (vp.required_recognition && !request.regulated_in_germany) {
      ineligibleReasons.push(`${visa.name} requires professional recognition.`);
      continue;
    }

    if (
      request.monthly_income &&
      request.monthly_income < (vp.min_salary ?? visa.min_salary ?? 0)
    ) {
      ineligibleReasons.push(
        `${visa.name} requires minimum salary of ${vp.min_salary}`,
      );
      continue;
    }

    eligibleVisas.push({
      visa_type: visa.id,
      reason: `Eligible for ${visa.name}`,
    });
  }

  return { eligibleVisas, ineligibleReasons };
}
