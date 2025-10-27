# Visa Recommendation Function

This function handles visa recommendation logic for the MeinVisa app.

### 📦 Run locally

```bash
supabase functions serve visa-recommendation
```

Test with:
```
POST http://localhost:54321/functions/v1/visa-recommendation
Content-Type: application/json

{
  "userId": "1234-5678"
}
```

### 🚀 Deploy
```bash
supabase functions deploy visa-recommendation
```