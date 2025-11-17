// lib/utils/matchHelpers.ts

/**
 * Language levels in order (CEFR standard)
 */
const LEVELS = ["NONE", "A1", "A2", "B1", "B2", "C1", "C2"];

/**
 * Compare two language levels
 *
 * @param level - User's current level (e.g., "B1")
 * @param target - Required level (e.g., "B2")
 * @returns negative if below target, 0 if equal, positive if above target
 *
 * @example
 * compareLanguageLevel("B2", "B1") // returns 1 (above target)
 * compareLanguageLevel("A2", "B1") // returns -1 (below target)
 * compareLanguageLevel("B1", "B1") // returns 0 (equal)
 */
export function compareLanguageLevel(
  level: string | undefined,
  target: string,
): number {
  if (!level) return -1;

  const a = LEVELS.indexOf(level.toUpperCase());
  const b = LEVELS.indexOf(target.toUpperCase());

  if (a === -1 || b === -1) return -1;

  return a - b; // negative = lower, 0 = equal, positive = higher
}

/**
 * Check if language level meets or exceeds target
 *
 * @param level - User's current level
 * @param target - Required level
 * @returns true if level >= target, false otherwise
 */
export function meetsLanguageRequirement(
  level: string | undefined,
  target: string,
): boolean {
  return compareLanguageLevel(level, target) >= 0;
}

/**
 * Get distance between two language levels (in steps)
 *
 * @param level - User's current level
 * @param target - Target level
 * @returns Number of steps between levels (always positive)
 *
 * @example
 * getLanguageLevelDistance("A2", "B2") // returns 2 (A2 → B1 → B2)
 */
export function getLanguageLevelDistance(
  level: string | undefined,
  target: string,
): number {
  const comparison = compareLanguageLevel(level, target);
  return Math.abs(comparison);
}

/**
 * Get next language level
 *
 * @param level - Current level
 * @returns Next level or null if already at max
 *
 * @example
 * getNextLanguageLevel("B1") // returns "B2"
 * getNextLanguageLevel("C2") // returns null
 */
export function getNextLanguageLevel(level: string | undefined): string | null {
  if (!level) return "A1";

  const idx = LEVELS.indexOf(level.toUpperCase());
  if (idx === -1 || idx >= LEVELS.length - 1) return null;

  return LEVELS[idx + 1] ?? null;
}

/**
 * Get language level recommendation based on target
 *
 * @param current - Current level
 * @param target - Target level
 * @returns Recommendation message
 */
export function getLanguageLevelRecommendation(
  current: string | undefined,
  target: string,
): string {
  const comparison = compareLanguageLevel(current, target);

  if (comparison >= 0) {
    return `✓ Your ${current} level meets the ${target} requirement.`;
  }

  if (!current || current === "NONE") {
    return `You need at least ${target} level. Consider starting with intensive courses (3-6 months to reach A1-A2).`;
  }

  const distance = getLanguageLevelDistance(current, target);
  const estimatedMonths = distance * 3; // Rough estimate: 3 months per level

  return `Your ${current} level is ${distance} level(s) below ${target}. Estimated time to reach target: ${estimatedMonths}-${
    estimatedMonths + 3
  } months with regular study.`;
}

/**
 * Validate language level format
 *
 * @param level - Level string to validate
 * @returns true if valid CEFR level, false otherwise
 */
export function isValidLanguageLevel(level: string | undefined): boolean {
  if (!level) return false;
  return LEVELS.includes(level.toUpperCase());
}

/**
 * Normalize language level input (handle common variations)
 *
 * @param level - Raw input (e.g., "b1", "B-1", "b 1")
 * @returns Normalized level (e.g., "B1") or null if invalid
 */
export function normalizeLanguageLevel(
  level: string | undefined,
): string | null {
  if (!level) return null;

  // Remove spaces, dashes, underscores
  const cleaned = level.replace(/[\s\-_]/g, "").toUpperCase();

  // Check if it's a valid level
  if (LEVELS.includes(cleaned)) {
    return cleaned === "NONE" ? null : cleaned;
  }

  return null;
}

/**
 * Calculate salary match percentage
 *
 * @param offered - Offered salary
 * @param required - Required minimum salary
 * @returns Percentage (0-100+) of requirement met
 *
 * @example
 * calculateSalaryMatch(60000, 58400) // returns ~103 (exceeds requirement)
 * calculateSalaryMatch(52000, 58400) // returns ~89 (below requirement)
 */
export function calculateSalaryMatch(
  offered: number,
  required: number,
): number {
  if (required === 0) return 100;
  return Math.round((offered / required) * 100);
}

/**
 * Check if salary meets requirement with tolerance
 *
 * @param offered - Offered salary
 * @param required - Required minimum
 * @param tolerancePercent - Allowed percentage below requirement (default 5%)
 * @returns true if within tolerance, false otherwise
 */
export function meetsSalaryRequirement(
  offered: number,
  required: number,
  tolerancePercent: number = 5,
): boolean {
  const percentage = calculateSalaryMatch(offered, required);
  return percentage >= (100 - tolerancePercent);
}

/**
 * Calculate experience match percentage
 *
 * @param years - Years of experience
 * @param required - Required minimum years
 * @returns Percentage (0-100+) of requirement met
 */
export function calculateExperienceMatch(
  years: number,
  required: number,
): number {
  if (required === 0) return 100;
  return Math.round((years / required) * 100);
}

/**
 * Validate and normalize salary input
 *
 * Handles different formats:
 * - Monthly to yearly conversion
 * - Currency normalization
 * - Range handling (takes midpoint)
 *
 * @param salary - Raw salary value
 * @param period - "year" | "month" (default: "year")
 * @returns Normalized annual salary in EUR
 */
export function normalizeSalary(
  salary: number | string,
  period: "year" | "month" = "year",
): number {
  let amount: number;

  // Parse string to number if needed
  if (typeof salary === "string") {
    // Remove currency symbols and commas
    const cleaned = salary.replace(/[€$,\s]/g, "");
    amount = parseFloat(cleaned);

    if (isNaN(amount)) return 0;
  } else {
    amount = salary;
  }

  // Convert monthly to annual
  if (period === "month") {
    amount = amount * 12;
  }

  return Math.round(amount);
}

/**
 * Format salary for display
 *
 * @param salary - Salary amount
 * @param currency - Currency symbol (default: "€")
 * @returns Formatted string (e.g., "€58,400")
 */
export function formatSalary(salary: number, currency: string = "€"): string {
  return `${currency}${salary.toLocaleString("en-US")}`;
}

/**
 * Calculate age from birthdate
 *
 * @param birthDate - Birth date string (YYYY-MM-DD)
 * @returns Age in years
 */
export function calculateAge(birthDate: string | Date): number {
  const birth = typeof birthDate === "string" ? new Date(birthDate) : birthDate;
  const today = new Date();

  let age = today.getFullYear() - birth.getFullYear();
  const monthDiff = today.getMonth() - birth.getMonth();

  // Adjust if birthday hasn't occurred this year
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
    age--;
  }

  return age;
}

/**
 * Check if age falls within range
 *
 * @param age - Age to check
 * @param min - Minimum age (inclusive)
 * @param max - Maximum age (inclusive)
 * @returns true if within range, false otherwise
 */
export function isAgeInRange(age: number, min: number, max: number): boolean {
  return age >= min && age <= max;
}

/**
 * Fuzzy match for occupation/field names
 *
 * @param input - User's field/occupation
 * @param target - Target field/occupation to match
 * @returns Similarity score (0-100)
 */
export function fuzzyMatchField(
  input: string | undefined,
  target: string,
): number {
  if (!input || !target) return 0;

  const inputLower = input.toLowerCase().trim();
  const targetLower = target.toLowerCase().trim();

  // Exact match
  if (inputLower === targetLower) return 100;

  // Contains match
  if (inputLower.includes(targetLower) || targetLower.includes(inputLower)) {
    return 80;
  }

  // Word overlap
  const inputWords = inputLower.split(/\s+/);
  const targetWords = targetLower.split(/\s+/);
  const overlap = inputWords.filter((w) => targetWords.includes(w)).length;
  const maxWords = Math.max(inputWords.length, targetWords.length);

  if (overlap > 0) {
    return Math.round((overlap / maxWords) * 60);
  }

  // No match
  return 0;
}

/**
 * Check if field is IT/Tech related
 *
 * @param field - Field or occupation name
 * @returns true if IT/Tech field, false otherwise
 */
export function isItField(field: string | undefined): boolean {
  if (!field) return false;

  const itKeywords = [
    "software",
    "developer",
    "programmer",
    "engineer",
    "it",
    "computer",
    "data",
    "analyst",
    "scientist",
    "web",
    "mobile",
    "frontend",
    "backend",
    "fullstack",
    "devops",
    "cloud",
    "cybersecurity",
    "security",
    "network",
    "database",
    "system",
    "admin",
    "architect",
    "tech",
    "digital",
    "ai",
    "machine learning",
    "ml",
    "artificial intelligence",
  ];

  const fieldLower = field.toLowerCase();
  return itKeywords.some((keyword) => fieldLower.includes(keyword));
}

/**
 * Check if field is healthcare related
 *
 * @param field - Field or occupation name
 * @returns true if healthcare field, false otherwise
 */
export function isHealthcareField(field: string | undefined): boolean {
  if (!field) return false;

  const healthcareKeywords = [
    "nurse",
    "nursing",
    "doctor",
    "physician",
    "medical",
    "health",
    "therapist",
    "therapy",
    "care",
    "clinical",
    "hospital",
    "patient",
    "medicine",
    "surgery",
    "dental",
    "pharmacy",
    "pharmacist",
  ];

  const fieldLower = field.toLowerCase();
  return healthcareKeywords.some((keyword) => fieldLower.includes(keyword));
}

/**
 * Check if field is STEM related
 *
 * @param field - Field or occupation name
 * @returns true if STEM field, false otherwise
 */
export function isStemField(field: string | undefined): boolean {
  if (!field) return false;

  const stemKeywords = [
    "engineering",
    "engineer",
    "science",
    "mathematics",
    "math",
    "physics",
    "chemistry",
    "biology",
    "technology",
    "research",
    "data",
    "statistics",
    "computer",
    "software",
    "electrical",
    "mechanical",
    "civil",
    "chemical",
  ];

  const fieldLower = field.toLowerCase();
  return stemKeywords.some((keyword) => fieldLower.includes(keyword));
}

/**
 * Get field-specific guidance
 *
 * @param field - Field or occupation name
 * @returns Array of guidance notes
 */
export function getFieldGuidance(field: string | undefined): string[] {
  if (!field) return [];

  const guidance: string[] = [];

  if (isItField(field)) {
    guidance.push(
      "💻 IT field: Germany has high demand for tech professionals. Consider IT Specialist visa if you lack formal degree.",
    );
  }

  if (isHealthcareField(field)) {
    guidance.push(
      "🏥 Healthcare field: You'll need professional recognition (Anerkennung) and often B2-C1 German proficiency.",
    );
  }

  if (isStemField(field)) {
    guidance.push(
      "🔬 STEM field: Strong demand in Germany. You may qualify for lower Blue Card salary threshold (€45,600).",
    );
  }

  return guidance;
}
