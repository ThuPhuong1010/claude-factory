---
name: api-design
description: "API design patterns. Trigger khi tạo API routes, services."
---

# API Design

## Response Format
Success: { success: true, data: T, meta?: { page, total } }
Error: { success: false, error: { code: string, message: string } }

## Next.js App Router API
- Validate input with Zod
- try-catch every handler
- HTTP status: 200, 201, 400, 401, 404, 500

## Layer Architecture
UI → Hooks → Services → API Routes → Database
Each layer only calls the one directly below.
