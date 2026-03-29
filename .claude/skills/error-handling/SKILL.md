---
name: error-handling
description: "Error handling patterns. Trigger khi viết async code, API calls, thiết kế error flow."
---

# Error Handling

## Khi nào cần đọc skill này
- Viết bất kỳ async function nào
- Thiết kế API response format
- Code có thể throw (file I/O, network, DB)
- Muốn user thấy error message hữu ích thay vì crash

---

## Phân tích — Error Taxonomy

Phân loại error trước khi code để handle đúng:

| Loại | Ví dụ | HTTP | Xử lý |
|------|-------|------|-------|
| **Business rule** | Email đã tồn tại, số dư không đủ | 400/409 | Return error, user có thể fix |
| **Validation** | Field thiếu, sai format | 400 | Message cụ thể từng field |
| **Auth** | Chưa login, không có quyền | 401/403 | Redirect login |
| **Not Found** | Record không tồn tại | 404 | Graceful empty state |
| **External failure** | API timeout, DB down | 503 | Retry hoặc fallback |
| **Programming bug** | Null reference, wrong type | 500 | Log đầy đủ, generic message |

---

## Design — Error Flow

```
User Action
    ↓
Client Validation (form rules) ← fail fast, no network
    ↓
API Call → try/catch
    ↓
Server Validation (Zod) ← 400 nếu fail
    ↓
Business Logic ← throw AppError nếu rule fail
    ↓
DB / External API ← try/catch, wrap → AppError
    ↓
Response: { success: false, error: { code, message } }
    ↓
Client handler ← Ant Design message.error() hoặc Result component
```

---

## Design — Custom Error Class

```typescript
// lib/errors.ts
export class AppError extends Error {
  constructor(
    public code: string,       // machine-readable: 'EMAIL_TAKEN'
    public message: string,    // user-facing: 'Email đã được sử dụng'
    public statusCode = 400,
    public context?: Record<string, unknown>  // debug only, không expose
  ) {
    super(message)
    this.name = 'AppError'
  }
}
```

---

## Design — Centralized API Error Handler

```typescript
// lib/api-handler.ts
export function withErrorHandler(handler: (req: NextRequest) => Promise<NextResponse>) {
  return async (req: NextRequest) => {
    try {
      return await handler(req)
    } catch (error) {
      if (error instanceof AppError) {
        return NextResponse.json(
          { success: false, error: { code: error.code, message: error.message } },
          { status: error.statusCode }
        )
      }
      console.error('[API Error]', error)  // log đầy đủ internally
      return NextResponse.json(
        { success: false, error: { code: 'INTERNAL_ERROR', message: 'Đã có lỗi xảy ra.' } },
        { status: 500 }
      )
    }
  }
}
```

---

## Implementation Rules

- Mọi async → try-catch. Không bao giờ để unhandled promise rejection.
- Không empty catch: `catch(e) {}` — log + re-throw hoặc handle rõ ràng.
- Log format: `[ModuleName] description { key: 'value' }` — không log password/token.
- ErrorBoundary bao mọi page/route.
- Client: `message.error()` cho action errors, `Result` component cho page-level errors.

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| `catch(e) {}` | Log + re-throw hoặc return error |
| `res.json({ error: error.stack })` | Generic message cho user, log stack internally |
| Continue sau catch mà không xử lý | Propagate hoặc handle rõ ràng |
| Một error message cho mọi case | Code + message cụ thể theo loại |
