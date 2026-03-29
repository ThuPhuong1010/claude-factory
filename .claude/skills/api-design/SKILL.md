---
name: api-design
description: "API design patterns. Trigger khi tạo API routes, services, thiết kế request/response format."
---

# API Design

## Khi nào cần đọc skill này
- Tạo API endpoint mới
- Thiết kế request/response format
- Phân vân REST vs RPC vs GraphQL
- Cần versioning strategy

---

## Phân tích — Chọn API Style

| Style | Dùng khi | Tránh khi |
|-------|---------|-----------|
| **REST** | CRUD resource-based, public API, team nhiều người | Action-heavy (không phải resource) |
| **RPC (tRPC)** | Full-stack TypeScript, type-safe end-to-end | Public API cần document |
| **GraphQL** | Client cần flexible queries, mobile + web khác nhau | Simple CRUD, over-engineering |
| **Server Actions** | Next.js form mutation, admin tool | Public API endpoint |

**Default choice:** REST cho web app thông thường. tRPC nếu full-stack TypeScript.

**Tự hỏi khi thiết kế endpoint:**
```
Đây là resource (noun) hay action (verb)?
  → Resource: /users, /orders           → REST GET/POST/PUT/DELETE
  → Action: /send-email, /calculate-tax → POST với action name rõ ràng

Ai gọi API này?
  → Internal only: ít cần versioning
  → External/public: cần /api/v1/, changelog, deprecation policy
```

---

## Design — URL & Method Convention

```
GET    /api/users          ← List (collection)
GET    /api/users/:id      ← Single resource
POST   /api/users          ← Create
PUT    /api/users/:id      ← Replace (full update)
PATCH  /api/users/:id      ← Partial update
DELETE /api/users/:id      ← Delete

Nested resource:
GET    /api/users/:id/orders     ← Orders của user
POST   /api/users/:id/orders     ← Tạo order cho user

Action (không fit REST):
POST   /api/orders/:id/cancel    ← Action rõ ràng hơn DELETE
POST   /api/auth/refresh-token   ← Không phải resource
```

---

## Design — Request/Response Format

```typescript
// Success response
{
  "success": true,
  "data": T,              // single object hoặc array
  "meta": {               // optional, khi có pagination
    "page": 1,
    "pageSize": 20,
    "total": 150
  }
}

// Error response
{
  "success": false,
  "error": {
    "code": "USER_NOT_FOUND",     // machine-readable, SCREAMING_SNAKE_CASE
    "message": "Không tìm thấy user"  // user-facing
  }
}

// HTTP Status mapping:
200 OK          ← GET thành công, PUT/PATCH thành công
201 Created     ← POST tạo resource mới
204 No Content  ← DELETE thành công (không có body)
400 Bad Request ← Validation fail
401 Unauthorized← Chưa login
403 Forbidden   ← Đã login nhưng không có quyền
404 Not Found   ← Resource không tồn tại
409 Conflict    ← Duplicate (email đã tồn tại)
500 Server Error← Lỗi không mong đợi
```

---

## Design — Layer Architecture

```
UI Component
    ↓ (gọi)
Custom Hook (useUsers, useOrders)
    ↓ (gọi)
Service Layer (userService.ts) ← Business logic, data transform
    ↓ (gọi)
API Route (route.ts)          ← HTTP, validation, auth check
    ↓ (gọi)
Database / External API
```

**Quy tắc:** Mỗi layer chỉ gọi layer ngay bên dưới. Không skip layer.

---

## Implementation Rules

- Validate input với Zod tại API route trước khi xử lý.
- Mọi handler có try-catch. Không để unhandled rejection.
- Dùng `withErrorHandler` wrapper để centralize error response.
- Không expose internal error detail (`error.stack`) trong response.
- Idempotent: PUT/DELETE gọi nhiều lần = cùng kết quả.

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| POST /getUsers | GET /users |
| Return 200 cho mọi response kể cả lỗi | HTTP status đúng theo loại lỗi |
| `{ error: "Something went wrong" }` | `{ success: false, error: { code, message } }` |
| Business logic trong API route handler | Tách ra service layer |
| Không validate input | Zod schema cho mọi request body |
| Expose stack trace | Log internal, trả về generic message |
