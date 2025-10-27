import { supabase } from "../lib/supabaseClient.ts";
import type { User } from "../models/User.ts";

export async function getUserById(userId: string): Promise<User | null> {
  const { data, error } = await supabase.from("users").select("*").eq("id", userId).single();
  if (error) throw new Error(error.message);
  return data;
}