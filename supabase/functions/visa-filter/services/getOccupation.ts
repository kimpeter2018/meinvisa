export async function getOccupation(codeOrId: string) {
  // try code then id
  let q = supabase.from("occupation").select("*").eq("code", codeOrId).maybeSingle();
  let { data, error } = await q;
  if (!data) {
    const res = await supabase.from("occupation").select("*").eq("id", codeOrId).single();
    data = res.data;
    error = res.error;
  }
  if (error || !data) throw new Error(`Occupation not found: ${codeOrId}`);
  return data;
}