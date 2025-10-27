import { getVisaRecommendations } from "../services/visaService.ts";
import { logInfo } from "../_shared/utils/logger.ts";
import { VisaRequest } from "../models/visaModels.ts";

export async function recommendationHandler(data: VisaRequest) {
  logInfo("Received visa recommendation request", data);
  const recommendations = await getVisaRecommendations(data);
  return { success: true, recommendations };
}
