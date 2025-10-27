// _shared/utils/errorHandler.ts
import { logError } from "../utils/logger.ts";

/**
 * Handles errors in Supabase Edge Functions.
 * Logs the error and returns a JSON response.
 *
 * @param error - The error object or message
 * @returns Response - HTTP response with error message
 */
export function handleError(error: unknown): Response {
  // Log the error for debugging
  if (error instanceof Error) {
    logError("Unhandled error occurred", error);
  } else {
    logError("Unhandled error occurred", error);
  }

  // Prepare a user-friendly message
  const message = error instanceof Error
    ? error.message
    : "Unknown error occurred";

  return new Response(JSON.stringify({ success: false, error: message }), {
    status: 500,
    headers: { "Content-Type": "application/json" },
  });
}
