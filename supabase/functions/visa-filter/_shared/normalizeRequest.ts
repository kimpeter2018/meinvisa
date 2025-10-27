export function normalizeAnswers(body: any) {
  // Convert Yes/No strings to booleans; guard missing fields
  return {
    ...body,
    job_offer: body.job_offer === "Yes",
    shortage_field: body.shortage_field === "Yes",
    regulated_in_germany: body.regulated_in_germany === "Yes",
    has_sufficient_funds: body.has_sufficient_funds === "Yes",
    financial_proof: body.financial_proof === "Yes",
    sponsored: body.sponsored === "Yes",
    // keep monthly_income numeric as-is; convert yearly to monthly if needed here
  };
}
