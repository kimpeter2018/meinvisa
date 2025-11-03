const visaFreeCountries = ["Korea", "Australia", "Brazil", "Canada", "Hong Kong", "Japan", "Macao", "Mexico", "Taiwan", "United Kingdom", "United States"];
const workingHolidayCountries = ["Korea", "Australia", "New Zealand", "Canada", "Japan", "Argentina", "Chile", "Israel", "Uruguay"];

export function isVisaFreeNationality(nat?: string): boolean {
  if (!nat) return false;
  return visaFreeCountries.some(c => nat.toLowerCase().includes(c.toLowerCase()));
}

export function isWorkingHolidayEligible(nat?: string): boolean {
  if (!nat) return false;
  return workingHolidayCountries.some(c => nat.toLowerCase().includes(c.toLowerCase()));
}
