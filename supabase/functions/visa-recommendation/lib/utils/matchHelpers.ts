const LEVELS = ["A1", "A2", "B1", "B2", "C1", "C2"];

export function compareLanguageLevel(level: string | undefined, target: string): number {
  if (!level) return -1;
  const a = LEVELS.indexOf(level.toUpperCase());
  const b = LEVELS.indexOf(target.toUpperCase());
  if (a === -1 || b === -1) return -1;
  return a - b; // negative = lower, 0 = equal, positive = higher
}
