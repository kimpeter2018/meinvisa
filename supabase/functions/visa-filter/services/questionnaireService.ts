import { supabase } from "../lib/supabaseClient.ts";

export async function getQuestionnaireResponses(userId: string) {
  const { data, error } = await supabase
    .from("visa_questionnaire")
    .select("*")
    .eq("user_id", userId);

  if (error) throw new Error(error.message);
  return data;
}