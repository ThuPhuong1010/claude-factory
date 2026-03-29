---
name: nextjs-app-router
description: "Next.js 15 App Router patterns. Trigger khi tạo pages, layouts, API routes, quyết định Server vs Client component."
---

# Next.js 15 App Router

## Khi nào cần đọc skill này
- Tạo page hoặc layout mới
- Phân vân Server vs Client Component
- Fetch data trong component
- Tạo API route

---

## Phân tích — Server vs Client Component

**Quyết định nhanh:**
```
Component này có cần:
  → useState / useEffect / hooks?        → 'use client'
  → onClick, onChange, event handler?    → 'use client'
  → browser API (localStorage, window)?  → 'use client'
  → Fetch data từ DB / external API?     → Server Component (default)
  → SEO-critical content?                → Server Component (default)
  → Không cần gì ở trên?                → Server Component (default)
```

**Rule:** Default Server Component. Chỉ thêm `'use client'` khi thật sự cần.

**Tại sao quan trọng:**
- Server Component: không gửi JS xuống client, nhanh hơn, bảo mật hơn
- Client Component: tăng bundle size, không access trực tiếp DB

---

## Design — File Convention

```
app/
├── layout.tsx          ← Root layout (html, body) — chạy một lần
├── page.tsx            ← Route /
├── loading.tsx         ← Streaming loading UI (Suspense tự động)
├── error.tsx           ← Error boundary cho route ('use client' bắt buộc)
├── not-found.tsx       ← 404 handler
├── (auth)/             ← Route group — nhóm mà không ảnh hưởng URL
│   ├── login/page.tsx  ← Route /login
│   └── layout.tsx      ← Layout chỉ cho nhóm này
└── api/
    └── users/route.ts  ← API endpoint GET/POST /api/users
```

---

## Design — Data Fetching Pattern

```typescript
// Server Component — fetch trực tiếp, không cần hook
export default async function UsersPage() {
  const users = await db.user.findMany()  // trực tiếp gọi DB
  return <UserList users={users} />
}

// Client Component — dùng TanStack Query
'use client'
export function UserList() {
  const { data, isLoading } = useQuery({
    queryKey: ['users'],
    queryFn: () => fetch('/api/users').then(r => r.json())
  })
}

// API Route — Next.js 15
export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url)
  // params là Promise trong Next.js 15:
  // const { id } = await params  ← nếu có dynamic segment
}
```

---

## Design — Component Tree Strategy

```
app/page.tsx (Server)          ← fetch data, pass xuống
  └── DashboardLayout (Server) ← layout, no state
       ├── Sidebar (Server)    ← static nav
       └── MainContent (Server)
            └── InteractiveWidget ('use client') ← chỉ phần cần interaction
```

**Pattern:** Đẩy `'use client'` boundary xuống càng sâu càng tốt.

---

## Implementation Rules

- `params` và `searchParams` là Promise trong Next.js 15 — phải `await`.
- `error.tsx` bắt buộc thêm `'use client'` (React constraint).
- Không fetch trong `layout.tsx` nếu data đó cũng cần ở `page.tsx` — sẽ fetch 2 lần.
- Dùng `loading.tsx` thay vì tự viết loading state cho page-level.
- API route: export named function (`GET`, `POST`, `PUT`, `DELETE`) — không default export.

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| Thêm 'use client' cho mọi component | Chỉ khi thật sự cần interactivity |
| `const { id } = params` (Next.js 15) | `const { id } = await params` |
| Fetch data trong Client Component khi không cần | Fetch trong Server Component |
| `export default function handler()` trong route.ts | `export async function GET()` |
| Bỏ qua `loading.tsx` | Luôn tạo loading.tsx cho page có async data |
