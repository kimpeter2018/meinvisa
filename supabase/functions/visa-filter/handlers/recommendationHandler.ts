import { getVisaRecommendations } from "../services/visaService.ts";
import { logInfo } from "../_shared/utils/logger.ts";

export async function recommendationHandler(data: any) {
  logInfo("Received visa recommendation request", data);
  const recommendations = await getVisaRecommendations(data);
  return { success: true, recommendations };
}
