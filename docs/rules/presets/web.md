# Preset: Web App

Load khi solution type = Web App / Web Service / SaaS.

## Stack mặc định (có thể override trong context/techstack.md)
- Framework: Next.js 15 App Router
- UI: Ant Design 5.x (không mix với UI lib khác)
- Language: TypeScript strict (no any)
- State: Zustand (shared) + TanStack Query (server) + useState (local)
- Validation: Ant Design Form rules (client) + Zod (server)
- Auth: NextAuth.js hoặc custom JWT + httpOnly cookie
- ORM: Prisma hoặc Drizzle

## Architecture

```
src/
├── app/                 # Next.js App Router (pages + API routes)
│   ├── (auth)/          # Auth route group
│   ├── (dashboard)/     # Protected route group
│   └── api/             # API routes
├── components/          # Shared UI components
├── hooks/               # Custom hooks (useUsers, useOrders...)
├── services/            # Business logic + API calls
├── stores/              # Zustand stores
├── lib/                 # DB client, auth config, utilities
└── types/               # TypeScript interfaces
```

Layers: UI → Hooks → Services → API Routes → Database. Không skip layer.

## Auth Flow

```
POST /api/auth/login
  → Validate input (Zod)
  → bcrypt.compare password
  → Sign JWT / create session
  → Set httpOnly + Secure cookie (KHÔNG trả token trong body)
  → Redirect to app

middleware.ts:
  → Check cookie trên mọi protected route
  → Redirect /login nếu thiếu hoặc expired
```

Không lưu token trong `localStorage` — XSS đọc được.

## Form Pattern (Ant Design)

```typescript
const [form] = Form.useForm()

<Form form={form} onFinish={handleSubmit} layout="vertical">
  <Form.Item name="email" label="Email"
    rules={[{ required: true }, { type: 'email', message: 'Email không hợp lệ' }]}>
    <Input />
  </Form.Item>
  <Button type="primary" htmlType="submit" loading={isSubmitting}>
    Lưu
  </Button>
</Form>
// onFinish KHÔNG phải onSubmit
// htmlType="submit" để trigger Form validation
```

## Data Fetching Pattern

```typescript
// Server Component — fetch trực tiếp
export default async function Page() {
  const data = await db.user.findMany()
  return <UserList data={data} />
}

// Client Component — TanStack Query
const { data, isLoading, error } = useQuery({
  queryKey: ['users'],
  queryFn: () => fetch('/api/users').then(r => r.json()),
})
```

## UI Rules

- Ant Design components cho tất cả UI — không tự viết nếu đã có
- Mọi page phải có: loading (`Skeleton`) + empty (`Empty`) + error (`Result`) states
- Responsive: Ant Grid Row/Col với breakpoints xs/md/lg
- Colors: Ant Design token qua ConfigProvider — không hardcode hex
- Xem `docs/rules/ui-design.md` để biết design system đầy đủ

## Database Migration

- Prisma: `npx prisma migrate dev` (dev) / `npx prisma migrate deploy` (prod)
- Drizzle: `npx drizzle-kit push` (dev) / `npx drizzle-kit migrate` (prod)
- KHÔNG chạy raw SQL trực tiếp trên production DB
- Mỗi migration = 1 commit riêng: `chore(db): migrate <tên thay đổi>`
- Backup trước khi migrate trên data thật
- Schema changes phải backward-compatible trong v0.x

## Testing

- Jest + React Testing Library
- Coverage > 70%
- Test behavior, không test implementation

## Commands
- `npm run dev` | `npm test` | `npm run lint` | `npm run build`
