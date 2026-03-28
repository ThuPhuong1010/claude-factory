When editing API route files (src/app/api/):
- Always validate input with Zod
- Consistent response: { success, data/error }
- try-catch every handler
- Never expose internal errors to client
