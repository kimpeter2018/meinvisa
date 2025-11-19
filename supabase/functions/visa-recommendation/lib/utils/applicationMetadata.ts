import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";
import type { VisaQuestionnaireInput } from "../types.ts";
import {
  getEstimatedProcessingTime as getNationalityProcessingTime,
  isVisaFreeNationality,
} from "./nationality.ts";

export interface ApplicationMetadata {
  cityPortals: CityPortal[];
  requiredDocuments: RequiredDocument[];
  additionalQuestions: ApplicationQuestion[];
  preFilledFields: PreFilledField[];
  estimatedProcessingTime: string;
  appointmentBookingUrl?: string;
  specialInstructions: string[];
}

export interface CityPortal {
  id: string;
  city: string;
  state?: string;
  portalUrl: string;
  appointmentRequired: boolean;
  appointmentBookingUrl?: string;
  contactEmail?: string;
  contactPhone?: string;
  address?: string;
  operatingHours?: string;
  specialInstructions?: string;
  averageWaitTimeDays?: number;
}

export interface RequiredDocument {
  id: string;
  documentType: string;
  documentName: string;
  description?: string;
  required: boolean;
  canGenerate: boolean;
  instructions?: string;
  orderIndex: number;
}

export interface ApplicationQuestion {
  id: string;
  fieldKey: string;
  question: string;
  questionType: string;
  required: boolean;
  options?: string[];
  validationRules?: Record<string, any>;
  helpText?: string;
  placeholder?: string;
  section: string;
  orderIndex: number;
}

export interface PreFilledField {
  formFieldKey: string;
  formFieldLabel: string;
  formSection?: string;
  sourceFieldKey: string;
  value: any;
  confidence: "high" | "medium" | "low";
  requiresVerification: boolean;
}

/**
 * FIXED: Main function to get all application metadata with proper error handling
 */
export async function getApplicationMetadata(
  visaCode: string,
  input: VisaQuestionnaireInput,
  supabase: SupabaseClient,
): Promise<ApplicationMetadata> {
  console.log(`📋 Fetching application metadata for visa: ${visaCode}`);

  try {
    // Run all queries in parallel for better performance
    const [
      cityPortals,
      requiredDocuments,
      additionalQuestions,
      preFilledFields,
    ] = await Promise.all([
      fetchCityPortals(supabase).catch((e) => {
        console.error("Error fetching city portals:", e);
        return [];
      }),
      fetchRequiredDocuments(visaCode, supabase).catch((e) => {
        console.error("Error fetching required documents:", e);
        return [];
      }),
      fetchAdditionalQuestions(visaCode, input, supabase).catch((e) => {
        console.error("Error fetching additional questions:", e);
        return [];
      }),
      fetchPreFilledFields(visaCode, input, supabase).catch((e) => {
        console.error("Error fetching pre-filled fields:", e);
        return [];
      }),
    ]);

    const estimatedProcessingTime = getProcessingTime(
      visaCode,
      input.nationality,
    );
    const appointmentBookingUrl = getAppointmentUrl(
      input.currentLocation,
      visaCode,
    );
    const specialInstructions = getSpecialInstructions(visaCode, input);

    console.log(
      `✅ Metadata fetched: ${requiredDocuments.length} docs, ${additionalQuestions.length} questions, ${preFilledFields.length} pre-filled`,
    );

    return {
      cityPortals,
      requiredDocuments,
      additionalQuestions,
      preFilledFields,
      estimatedProcessingTime,
      appointmentBookingUrl,
      specialInstructions,
    };
  } catch (error) {
    console.error("❌ Critical error in getApplicationMetadata:", error);

    // FIXED: Return empty metadata instead of throwing
    return {
      cityPortals: [],
      requiredDocuments: [],
      additionalQuestions: [],
      preFilledFields: [],
      estimatedProcessingTime: "6-12 weeks",
      specialInstructions: [
        "Please contact the German embassy for more information.",
      ],
    };
  }
}

/**
 * Fetch city portals from database
 */
async function fetchCityPortals(
  supabase: SupabaseClient,
): Promise<CityPortal[]> {
  const { data, error } = await supabase
    .from("city_visa_portals")
    .select("*")
    .order("city", { ascending: true });

  if (error) {
    console.error("Error fetching city portals:", error);
    return [];
  }

  return (data || []).map((portal) => ({
    id: portal.id,
    city: portal.city,
    state: portal.state,
    portalUrl: portal.portal_url,
    appointmentRequired: portal.appointment_required,
    appointmentBookingUrl: portal.appointment_booking_url,
    contactEmail: portal.contact_email,
    contactPhone: portal.contact_phone,
    address: portal.address,
    operatingHours: portal.operating_hours,
    specialInstructions: portal.special_instructions,
    averageWaitTimeDays: portal.average_wait_time_days,
  }));
}

/**
 * Fetch required documents for visa type
 */
async function fetchRequiredDocuments(
  visaCode: string,
  supabase: SupabaseClient,
): Promise<RequiredDocument[]> {
  const { data, error } = await supabase
    .from("visa_required_documents")
    .select("*")
    .eq("visa_code", visaCode)
    .order("order_index", { ascending: true });

  if (error) {
    console.error("Error fetching required documents:", error);
    return [];
  }

  return (data || []).map((doc) => ({
    id: doc.id,
    documentType: doc.document_type,
    documentName: doc.document_name,
    description: doc.description,
    required: doc.required,
    canGenerate: doc.can_generate,
    instructions: doc.instructions,
    orderIndex: doc.order_index,
  }));
}

/**
 * Fetch additional application questions with conditional logic
 */
async function fetchAdditionalQuestions(
  visaCode: string,
  input: VisaQuestionnaireInput,
  supabase: SupabaseClient,
): Promise<ApplicationQuestion[]> {
  // First, get all questions for this visa type
  const { data, error } = await supabase
    .from("visa_application_questions")
    .select("*")
    .eq("visa_code", visaCode)
    .order("order_index", { ascending: true });

  if (error) {
    console.error("Error fetching application questions:", error);
    return [];
  }

  if (!data) return [];

  // Filter questions based on conditional logic
  const filteredQuestions = data.filter((q) => {
    // If no dependency, include the question
    if (!q.depends_on_field) return true;

    // Check if the dependent field exists in input
    const dependentFieldValue =
      (input as any)[snakeToCamel(q.depends_on_field)];

    // If depends_on_value is specified, check exact match
    if (q.depends_on_value) {
      return String(dependentFieldValue) === q.depends_on_value;
    }

    // Otherwise, just check if the field has a truthy value
    return !!dependentFieldValue;
  });

  return filteredQuestions.map((q) => ({
    id: q.id,
    fieldKey: q.field_key,
    question: q.question,
    questionType: q.question_type,
    required: q.required,
    options: q.options,
    validationRules: q.validation_rules,
    helpText: q.help_text,
    placeholder: q.placeholder,
    section: q.section,
    orderIndex: q.order_index,
  }));
}

/**
 * Fetch and generate pre-filled fields using stored mappings
 */
async function fetchPreFilledFields(
  visaCode: string,
  input: VisaQuestionnaireInput,
  supabase: SupabaseClient,
): Promise<PreFilledField[]> {
  // Get field mappings from database
  const { data, error } = await supabase.from("visa_field_mappings").select("*")
    .eq("visa_code", visaCode);

  if (error) {
    console.error("Error fetching field mappings:", error);
    return [];
  }

  if (!data) return [];

  const preFilledFields: PreFilledField[] = [];

  for (const mapping of data) {
    const sourceValue = (input as any)[snakeToCamel(mapping.source_field_key)];

    // Skip if source value doesn't exist (unless it's a constant)
    if (
      sourceValue === undefined && mapping.transformation_type !== "constant"
    ) {
      continue;
    }

    let transformedValue: any;

    // Apply transformation based on type
    switch (mapping.transformation_type) {
      case "direct":
        transformedValue = sourceValue;
        break;

      case "constant":
        transformedValue = mapping.transformation_rule?.value;
        break;

      case "format":
        transformedValue = applyFormatTransformation(
          sourceValue,
          mapping.transformation_rule,
        );
        break;

      case "calculate":
        transformedValue = applyCalculateTransformation(
          sourceValue,
          mapping.transformation_rule,
        );
        break;

      case "lookup":
        transformedValue = applyLookupTransformation(
          sourceValue,
          mapping.transformation_rule,
        );
        break;

      default:
        transformedValue = sourceValue;
    }

    // Only include if we have a value
    if (transformedValue !== undefined && transformedValue !== null) {
      preFilledFields.push({
        formFieldKey: mapping.form_field_key,
        formFieldLabel: mapping.form_field_label,
        formSection: mapping.form_section,
        sourceFieldKey: mapping.source_field_key,
        value: transformedValue,
        confidence: mapping.confidence as "high" | "medium" | "low",
        requiresVerification: mapping.requires_verification,
      });
    }
  }

  return preFilledFields;
}

/**
 * Apply format transformation (e.g., date formatting)
 */
function applyFormatTransformation(value: any, rule: any): any {
  if (!rule) return value;

  const outputFormat = rule.output_format;

  // Date formatting
  if (outputFormat === "DD.MM.YYYY" && value) {
    try {
      const date = new Date(value);
      const day = String(date.getDate()).padStart(2, "0");
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const year = date.getFullYear();
      return `${day}.${month}.${year}`;
    } catch (e) {
      console.error("Date formatting error:", e);
      return value;
    }
  }

  // International phone format
  if (outputFormat === "international" && value) {
    return value.startsWith("+") ? value : `+${value}`;
  }

  return value;
}

/**
 * Apply calculation transformation (e.g., monthly to annual)
 */
function applyCalculateTransformation(value: any, rule: any): any {
  if (!rule || value === undefined) return value;

  const operation = rule.operation;
  const numValue = Number(value);

  if (isNaN(numValue)) return value;

  switch (operation) {
    case "monthly_to_annual":
      return Math.round(numValue * (rule.multiply || 12));

    case "annual_to_monthly":
      return Math.round(numValue / (rule.divide || 12));

    case "semesters_to_years":
      return Math.round(numValue / (rule.divide || 2));

    default:
      return value;
  }
}

/**
 * Apply lookup transformation (mapping values)
 */
function applyLookupTransformation(value: any, rule: any): any {
  if (!rule || !rule.mappings) return value;

  const mappedValue = rule.mappings[String(value)];
  if (mappedValue !== undefined) return mappedValue;

  if (rule.default !== undefined) return rule.default;

  return value;
}

/**
 * Get estimated processing time based on visa type and nationality
 */
function getProcessingTime(visaCode: string, nationality?: string): string {
  const baseTimes: Record<string, string> = {
    blue_card: "6-12 weeks",
    skilled_worker: "6-12 weeks",
    it_specialist: "6-10 weeks",
    job_seeker: "4-8 weeks",
    student: "6-10 weeks",
    language_course: "4-8 weeks",
    ausbildung: "8-12 weeks",
    researcher: "6-10 weeks",
    family_reunion: "8-16 weeks",
    au_pair: "4-8 weeks",
    volunteer_service: "6-10 weeks",
    working_holiday: "2-6 weeks",
    freelance: "12-20 weeks",
    artist: "8-12 weeks",
    athlete: "6-10 weeks",
  };

  let baseTime = baseTimes[visaCode] || "6-12 weeks";

  if (nationality) {
    const nationalityInfo = getNationalityProcessingTime(nationality);
    if (nationalityInfo && nationalityInfo.note.includes("longer")) {
      baseTime += " (may be longer for high-volume countries)";
    }
  }

  return baseTime;
}

/**
 * Get appointment booking URL based on location
 */
function getAppointmentUrl(
  location?: string,
  visaCode?: string,
): string | undefined {
  if (!location) return undefined;

  const cityMatch = location.match(
    /(Berlin|Munich|Frankfurt|Hamburg|Cologne|Stuttgart|Düsseldorf|Leipzig|Dresden|Karlsruhe)/i,
  );

  if (!cityMatch) return undefined;

  const city = cityMatch[1].toLowerCase();

  const appointmentUrls: Record<string, string> = {
    berlin: "https://otv.verwalt-berlin.de/ams/TerminBuchen",
    munich: "https://www22.muenchen.de/termin/",
    frankfurt: "https://termine.frankfurt.de/",
    hamburg: "https://www.hamburg.de/behoerdenfinder/terminvereinbarung/",
    cologne: "https://termine.stadt-koeln.de/",
    stuttgart: "https://service.stuttgart.de/termin/",
    düsseldorf: "https://www44.duesseldorf.de/online-dienste/",
    leipzig: "https://www.leipzig.de/buergerservice/termine/",
    dresden: "https://termine.dresden.de/",
    karlsruhe: "https://web1.karlsruhe.de/Termin/",
  };

  return appointmentUrls[city];
}

/**
 * Generate special instructions based on visa type and user data
 */
function getSpecialInstructions(
  visaCode: string,
  input: VisaQuestionnaireInput,
): string[] {
  const instructions: string[] = [];

  // Nationality-specific instructions
  if (input.nationality) {
    if (isVisaFreeNationality(input.nationality)) {
      instructions.push(
        "✈️ As a visa-free nationality, you can enter Germany first and apply for your residence permit from within the country.",
      );
    } else {
      instructions.push(
        "🛂 You must apply for a national visa (Type D) at the German embassy/consulate in your home country before travel.",
      );
    }
  }

  // Visa-specific instructions
  switch (visaCode) {
    case "blue_card":
      instructions.push(
        "💼 Bring your signed employment contract and degree certificates to your appointment.",
      );
      instructions.push(
        "📊 Your salary must meet the threshold (€58,400 general or €45,600 for shortage occupations).",
      );
      break;

    case "student":
      instructions.push(
        "💰 You must have opened a blocked account (Sperrkonto) with minimum €11,904 before applying.",
      );
      instructions.push(
        "🎓 All educational documents must be apostilled and officially translated to German.",
      );
      break;

    case "job_seeker":
      instructions.push(
        "⏱️ This visa allows 6 months in Germany to search for employment.",
      );
      instructions.push(
        "💼 You cannot start working until you switch to a work visa after finding a job.",
      );
      break;

    case "family_reunion":
      instructions.push(
        "👨‍👩‍👧‍👦 Your family member in Germany must prove sufficient income to support you.",
      );
      instructions.push(
        "🏠 Adequate housing space must be documented (typically 12-15 sqm per person).",
      );
      break;

    case "freelance":
      instructions.push(
        "📊 Prepare a detailed business plan showing economic benefit to Germany.",
      );
      instructions.push(
        "💰 You'll need proof of sufficient capital (typically €15,000-25,000).",
      );
      break;
  }

  // General instructions for all visa types
  instructions.push(
    "📅 Book your appointment as early as possible - wait times can be 4-8 weeks in major cities.",
  );
  instructions.push(
    "📸 Bring biometric passport photos meeting German standards (45mm x 35mm, white background).",
  );
  instructions.push(
    "🏥 Health insurance must be valid from your first day in Germany.",
  );

  return instructions;
}

/**
 * Convert snake_case to camelCase
 */
function snakeToCamel(str: string): string {
  return str.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase());
}
