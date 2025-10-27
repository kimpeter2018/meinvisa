import { supabase } from "../lib/supabaseClient.ts";
import type { Visa } from "../models/Visa.ts";

export async function getVisaRecommendations(data: any): Promise<Visa[]> {
  const { userId } = data;
  const { data: visas, error } = await supabase
    .from("visa_eligibility_result")
    .select("*")
    .eq("user_id", userId);

  if (error) throw new Error(error.message);
  return visas || [];
}