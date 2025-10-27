// models/visaModels.ts

export interface EligibilityResult {
  id: string;
  user_id: string;
  visa_id: string;
  score: number;
  created_at: string;
}

export interface Visa {
  id: string;
  code: string;
  title: string;
  description: string;
  min_salary?: number;
  duration_months: number;
  renewable: boolean;
}
export interface VisaResponse {
  eligible_visas: EligibilityResult[];
  ineligible_reasons: string[];
  confidence: "high" | "medium" | "low";
}

export interface VisaRequest {
  // Work
  job_offer?: boolean;
  shortage_field?: boolean;
  occupation: string;
  work_experience_years?: number;
  is_employed?: boolean;
  regulated_in_germany?: boolean;

  // Travel
  family_in_germany?: boolean;
  schengen_visa?: boolean;
  visa_refusal_history?: boolean;
  visited_germany?: boolean;

  // Purpose
  purpose_of_stay?: "Study" | "Work" | "Family Reunion" | "Research" | "Other";
  intended_duration?: string;
  has_accommodation?: boolean;
  has_sufficient_funds?: boolean;

  // Personal
  birth_date?: string;
  gender?: string;
  marital_status?: string;
  citizenship_country?: string;
  second_citizenship?: string;
  residence_country?: string;

  // Financial
  monthly_income?: number;
  financial_proof?: boolean;
  sponsored?: boolean;

  // Education
  university_admission?: boolean;
  education_level?: "High School" | "Bachelor" | "Master" | "PhD";
  study_in_germany?: boolean;
  field_of_study?: string;
}

export interface User {
  id: string;
  email: string;
  created_at: string;
}
