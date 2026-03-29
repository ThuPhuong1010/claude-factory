# Preset: API / Service

Load khi solution type = REST API, Microservice, Webhook handler, Backend service.

## Stack gợi ý

| Use case | Stack |
|---------|-------|
| REST API general | Node.js + Express/Fastify + TypeScript |
| Next.js backend | Next.js App Router API routes |
| Python API | FastAPI + Pydantic |
| High-perf / typed | Go + chi/gin |

## Structure (Node.js/FastAPI)

```
src/
├── routes/          # Route definitions
├── controllers/     # Request handlers (thin — delegate to services)
├── services/        # Business logic
├── middleware/      # Auth, validation, logging, rate limit
├── models/          # DB models / Pydantic schemas
├── lib/             # Utilities, DB connection
└── types/           # TypeScript types / Pydantic models
```

## Rules

**Response format — luôn nhất quán:**
```json
{ "success": true, "data": {}, "meta": {} }
{ "success": false, "error": { "code": "SNAKE_CASE", "message": "user-facing" } }
```

**HTTP status:**
- 200 GET/PUT success | 201 POST created | 204 DELETE success
- 400 validation fail | 401 unauthenticated | 403 forbidden
- 404 not found | 409 conflict | 422 unprocessable | 500 server error

**Bắt buộc:**
- Validate request body với Zod (Node) hoặc Pydantic (Python)
- Auth middleware trước mọi protected route
- Rate limiting trên auth + public endpoints
- Structured JSON logging — không plain console.log
- `GET /health` endpoint: trả về `{ "status": "ok", "version": "..." }`
- CORS: explicit origins, không `*` trên production

## Testing

- Unit test service layer (mock DB/external)
- Integration test routes với test DB hoặc in-memory DB
- Coverage > 70% trên service + controller layer
- Contract test nếu API có nhiều consumers

## Versioning

- URL versioning: `/api/v1/`, `/api/v2/`
- Breaking change = version mới — không break existing clients
- Deprecation: thêm `Deprecation` header trước khi remove
