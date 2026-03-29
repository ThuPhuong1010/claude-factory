---
name: security
description: "Security patterns. Trigger khi code auth, handle user input, thiết kế hệ thống có dữ liệu nhạy cảm."
---

# Security

## Khi nào cần đọc skill này
- Thiết kế authentication / authorization
- Xử lý input từ user hoặc external source
- Lưu trữ dữ liệu nhạy cảm (password, token, PII)
- Expose API ra internet
- Build bất kỳ thứ gì có nhiều người dùng

---

## Phân tích — Chọn Auth Strategy

| Tình huống | Strategy | Lý do |
|-----------|----------|-------|
| Web app có server | Session + httpOnly cookie | Không expose token ra client JS |
| SPA + separate API | JWT trong httpOnly cookie | Không dùng localStorage |
| API cho mobile / third-party | OAuth 2.0 + Bearer token | Standard, revocable |
| Internal tools (Google Workspace) | NextAuth + OAuth provider | Nhanh, không tự quản password |
| Multi-tenant SaaS | JWT + org/tenant claim | Phân biệt tenant trong token |

**Không dùng localStorage cho auth token** — XSS đọc được toàn bộ.

---

## Design — Threat Model Cơ Bản

Trước khi code, tự hỏi 4 câu:
1. **Ai có thể attack?** anonymous, authenticated user, admin bị compromise
2. **Attack surface nào?** form input, URL params, file upload, API endpoints
3. **Dữ liệu nào cần bảo vệ?** password, PII, payment info, session token
4. **Worst case nếu bị breach?** → Xác định mức độ bảo vệ cần thiết

---

## Design — Auth Flow

```
User → Login Form → POST /api/auth/login
           ↓
      Validate input (Zod)
           ↓
      Check credentials (bcrypt.compare)
           ↓
      Create session / sign JWT
           ↓
      Set httpOnly + Secure cookie (KHÔNG trả về body)
           ↓
      Redirect to app

Protected Route:
middleware.ts → check cookie → redirect /login nếu thiếu
```

---

## Design — Authorization (RBAC)

```typescript
type Role = 'admin' | 'member' | 'viewer'
type Permission = 'read' | 'write' | 'delete' | 'admin'

const rolePermissions: Record<Role, Permission[]> = {
  admin:  ['read', 'write', 'delete', 'admin'],
  member: ['read', 'write'],
  viewer: ['read'],
}

function can(user: User, action: Permission): boolean {
  return rolePermissions[user.role].includes(action)
}
```

Check permission ở **server side** (middleware / API route) — không chỉ hide UI.

---

## Implementation Rules

**Passwords:** bcrypt 12+ rounds. Không MD5/SHA1. Enforce min length cả client + server.

**Cookies:** httpOnly + Secure + SameSite=Lax. JWT secret ≥ 32 chars. Expire: access 15min, refresh 7 days.

**Input:** Validate mọi thứ tại server bằng Zod. Parameterized queries (ORM tự lo). Sanitize HTML nếu render user content.

**API:** Rate limit auth endpoints (5 attempts/min). CORS specific origins. Không expose stack trace.

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| Token trong localStorage | Token trong httpOnly cookie |
| Check permission chỉ ở frontend | Check ở server (middleware / API route) |
| Error: "Sai mật khẩu cho user X" | Error: "Email hoặc mật khẩu không đúng" |
| Log password khi debug | Log chỉ user ID, action, timestamp |
| CORS: `*` | CORS: list explicit origins |
