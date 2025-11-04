// lib/utils/nationality.ts

/**
 * List of visa-free countries for Germany (90 days without visa)
 * 
 * These nationals can enter Germany without a visa and apply for
 * residence permits from within the country for certain visa types.
 * 
 * Source: Schengen visa-free countries + select others
 */
const visaFreeCountries = [
  // EU/EEA (not technically "visa-free" but similar privileges)
  "Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic",
  "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary",
  "Iceland", "Ireland", "Italy", "Latvia", "Liechtenstein", "Lithuania",
  "Luxembourg", "Malta", "Netherlands", "Norway", "Poland", "Portugal",
  "Romania", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland",
  
  // Americas
  "United States", "Canada", "Mexico", "Brazil", "Argentina", "Chile",
  "Uruguay", "Costa Rica", "Panama", "Venezuela",
  
  // Asia-Pacific
  "Japan", "South Korea", "Korea", "Singapore", "Hong Kong", "Taiwan",
  "Australia", "New Zealand", "Brunei", "Malaysia", "Israel",
  
  // Middle East
  "United Arab Emirates", "Kuwait", "Bahrain", "Qatar",
  
  // Other
  "United Kingdom", "Macao", "Macau", "Monaco", "San Marino", "Vatican"
];

/**
 * Countries eligible for Working Holiday Visa with Germany
 * 
 * Working Holiday agreements allow young people (18-30/35) to work
 * and travel in Germany for up to 12 months.
 * 
 * Source: Official German Working Holiday agreements
 */
const workingHolidayCountries = [
  "Australia",
  "New Zealand", 
  "Canada",
  "Japan",
  "South Korea", "Korea",
  "Israel",
  "Argentina",
  "Chile",
  "Uruguay",
  "Hong Kong",
  "Taiwan"
];

/**
 * EU/EEA countries with freedom of movement
 * 
 * These nationals have unrestricted right to live and work in Germany
 * without needing residence permits (though registration required).
 */
const euEeaCountries = [
  "Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic",
  "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary",
  "Iceland", "Ireland", "Italy", "Latvia", "Liechtenstein", "Lithuania",
  "Luxembourg", "Malta", "Netherlands", "Norway", "Poland", "Portugal",
  "Romania", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland"
];

/**
 * Countries with Blue Card salary reduction (shortage occupations)
 * 
 * Nationals from these countries often face lower Blue Card salary
 * thresholds for shortage occupations.
 */
const priorityCountries = [
  "India", "China", "Turkey", "Russia", "Brazil", "Mexico",
  "Philippines", "Vietnam", "Egypt", "Morocco", "Tunisia"
];

/**
 * Check if nationality is visa-free for Germany entry
 * 
 * @param nat - Nationality string (e.g., "United States", "Japan")
 * @returns true if visa-free, false otherwise
 */
export function isVisaFreeNationality(nat?: string): boolean {
  if (!nat) return false;
  return visaFreeCountries.some(c => 
    nat.toLowerCase().includes(c.toLowerCase())
  );
}

/**
 * Check if nationality is eligible for Working Holiday Visa
 * 
 * @param nat - Nationality string
 * @returns true if eligible, false otherwise
 */
export function isWorkingHolidayEligible(nat?: string): boolean {
  if (!nat) return false;
  return workingHolidayCountries.some(c => 
    nat.toLowerCase().includes(c.toLowerCase())
  );
}

/**
 * Check if nationality is EU/EEA (freedom of movement)
 * 
 * @param nat - Nationality string
 * @returns true if EU/EEA, false otherwise
 */
export function isEuEea(nat?: string): boolean {
  if (!nat) return false;
  return euEeaCountries.some(c => 
    nat.toLowerCase().includes(c.toLowerCase())
  );
}

/**
 * Check if nationality is from priority/high-volume country
 * 
 * These countries often have specialized consular services and
 * potentially different processing procedures.
 * 
 * @param nat - Nationality string
 * @returns true if priority country, false otherwise
 */
export function isPriorityCountry(nat?: string): boolean {
  if (!nat) return false;
  return priorityCountries.some(c => 
    nat.toLowerCase().includes(c.toLowerCase())
  );
}

/**
 * Get nationality-specific guidance
 * 
 * Returns helpful notes based on nationality status
 * 
 * @param nat - Nationality string
 * @returns Array of guidance notes
 */
export function getNationalityGuidance(nat?: string): string[] {
  if (!nat) return [];
  
  const guidance: string[] = [];
  
  // EU/EEA - no visa needed
  if (isEuEea(nat)) {
    guidance.push("🇪🇺 As an EU/EEA citizen, you have freedom of movement. No residence permit needed - just register at local Bürgeramt within 2 weeks of arrival.");
    return guidance;
  }
  
  // Visa-free entry
  if (isVisaFreeNationality(nat)) {
    guidance.push("✈️ You can enter Germany visa-free for 90 days.");
    guidance.push("📋 Some visas (Blue Card, Student) can be applied for after arrival. Others require pre-arrival application.");
  } else {
    guidance.push("🛂 You'll need to apply for a national visa (Type D) from German embassy/consulate in your home country before travel.");
  }
  
  // Working Holiday
  if (isWorkingHolidayEligible(nat)) {
    guidance.push("🎒 You're eligible for Working Holiday Visa (age 18-30/35) - 12 months with work permission!");
  }
  
  // Priority country
  if (isPriorityCountry(nat)) {
    guidance.push("🌍 Your country has high volume of applications - consider applying early and expect potentially longer processing times.");
  }
  
  return guidance;
}

/**
 * Get recommended application location based on nationality
 * 
 * @param nat - Nationality string
 * @returns "in-country" | "home-country" | "either"
 */
export function getRecommendedApplicationLocation(nat?: string): "in-country" | "home-country" | "either" {
  if (!nat) return "home-country";
  
  // EU/EEA - register locally
  if (isEuEea(nat)) {
    return "in-country";
  }
  
  // Visa-free - can often apply in-country for certain visas
  if (isVisaFreeNationality(nat)) {
    return "either";
  }
  
  // All others - must apply from home country
  return "home-country";
}

/**
 * Get embassy wait time estimate based on nationality
 * 
 * Note: These are rough estimates. Actual times vary by season, location, visa type.
 * 
 * @param nat - Nationality string
 * @returns Estimated processing time in weeks
 */
export function getEstimatedProcessingTime(nat?: string): { min: number; max: number; note: string } {
  if (!nat) {
    return { 
      min: 6, 
      max: 12, 
      note: "Standard processing time"
    };
  }
  
  // EU/EEA - immediate (just registration)
  if (isEuEea(nat)) {
    return { 
      min: 0, 
      max: 1, 
      note: "Registration only, no visa needed"
    };
  }
  
  // Priority countries - often longer due to volume
  if (isPriorityCountry(nat)) {
    return { 
      min: 8, 
      max: 16, 
      note: "High volume country - expect longer processing"
    };
  }
  
  // Visa-free countries - typically faster
  if (isVisaFreeNationality(nat)) {
    return { 
      min: 4, 
      max: 10, 
      note: "Visa-free entry helps, but residence permit still takes time"
    };
  }
  
  // Standard processing
  return { 
    min: 6, 
    max: 12, 
    note: "Standard processing time"
  };
}

/**
 * Check if nationality requires additional documentation
 * 
 * Some countries require apostille, specific translations, etc.
 * 
 * @param nat - Nationality string
 * @returns Array of additional requirements
 */
export function getAdditionalDocRequirements(nat?: string): string[] {
  if (!nat) return [];
  
  const requirements: string[] = [];
  
  // Non-EU countries need document apostille/legalization
  if (!isEuEea(nat)) {
    requirements.push("📜 Documents must be apostilled (Hague Convention) or legalized by German embassy");
    requirements.push("🌐 All documents must be translated to German by certified translator");
  }
  
  // Specific country requirements
  if (nat.toLowerCase().includes("china")) {
    requirements.push("🇨🇳 Chinese documents require authentication by Chinese authorities before apostille");
  }
  
  if (nat.toLowerCase().includes("india")) {
    requirements.push("🇮🇳 Indian degrees should be verified through Anabin database or ZAB");
  }
  
  if (nat.toLowerCase().includes("turkey")) {
    requirements.push("🇹🇷 Turkish documents require notarization and Turkish consulate authentication");
  }
  
  return requirements;
}