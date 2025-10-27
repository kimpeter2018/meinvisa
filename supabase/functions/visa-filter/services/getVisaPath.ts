export async function getVisaPaths(occupation_id: string) {
  const { data, error } = await supabase
    .from("visa_path")
    .select("*, visa_type(*)")
    .eq("occupation_id", occupation_id);
  if (error) throw new Error(`Visa paths not found for occupation: ${occupation_id}`);
  return data ?? [];
}
