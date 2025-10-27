export function validateInput(data: any) {
  if (!data || !data.userId) {
    throw new Error("Missing userId in request payload.");
  }
}