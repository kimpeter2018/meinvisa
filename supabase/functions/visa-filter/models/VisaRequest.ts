export interface VisaRequest {
  // fields mapped from your questionnaire
  purpose_of_stay?: string;         // "Work", "Study", ...
  occupation?: string;              // occupation code or id (from options "occupation")
  regulated_in_germany?: string;    // "Yes" | "No"
  work_experience_years?: number;
  shortage_field?: string;          // "Yes" | "No"
  job_offer?: string;               // "Yes" | "No"
  is_employed?: string;             // "Yes" | "No"
  education_level?: string;         // "High School" | "Bachelor" | ...
  citizenship_country?: string;     // ISO code or db key
  residence_country?: string;
  has_sufficient_funds?: string;    // "Yes" | "No"
  financial_proof?: string;         // "Yes" | "No"
  sponsored?: string;               // "Yes" | "No"
  monthly_income?: number;          // numeric (EUR)
  age?: number;
}
