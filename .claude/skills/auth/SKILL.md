---
name: auth
description: "Authentication & Authorization. Trigger khi cần login, đăng ký, session, JWT, OAuth, RBAC, protected routes."
versions: { "next-auth": "^5.0.0-beta", next: "^15" }
---

# Auth (NextAuth.js v5 / Auth.js)

```bash
npm install next-auth@beta
npx auth secret          # generate AUTH_SECRET → tự thêm vào .env
```

## Setup

```ts
// auth.ts (root project)
import NextAuth from 'next-auth'
import GitHub from 'next-auth/providers/github'
import Credentials from 'next-auth/providers/credentials'
import { prisma } from '@/lib/prisma'
import bcrypt from 'bcryptjs'

export const { handlers, signIn, signOut, auth } = NextAuth({
  providers: [
    GitHub,
    Credentials({
      credentials: { email: { type: 'email' }, password: { type: 'password' } },
      authorize: async ({ email, password }) => {
        const user = await prisma.user.findUnique({ where: { email: String(email) } })
        if (!user || !await bcrypt.compare(String(password), user.passwordHash)) return null
        return user
      },
    }),
  ],
  callbacks: {
    jwt({ token, user }) { if (user) token.role = user.role; return token },
    session({ session, token }) { session.user.role = token.role as string; return session },
  },
})
```

```ts
// app/api/auth/[...nextauth]/route.ts
export { handlers as GET, handlers as POST } from '@/auth'
```

## Session — Server Components

```ts
import { auth } from '@/auth'

export default async function Dashboard() {
  const session = await auth()
  if (!session?.user) redirect('/login')
  return <div>Hello {session.user.name}</div>
}
```

## Session — Client Components

```tsx
'use client'
import { useSession, SessionProvider } from 'next-auth/react'

// Wrap layout với SessionProvider
// Dùng hook:
const { data: session, status } = useSession()
```

## Protected Routes (Middleware)

```ts
// middleware.ts
import { auth } from '@/auth'
export default auth((req) => {
  if (!req.auth) return Response.redirect(new URL('/login', req.url))
})
export const config = { matcher: ['/dashboard/:path*', '/api/protected/:path*'] }
```

## RBAC

```ts
// lib/permissions.ts
type Role = 'admin' | 'editor' | 'viewer'
const PERMS: Record<Role, string[]> = {
  admin: ['*'], editor: ['read', 'write'], viewer: ['read'],
}
export const can = (role: Role, action: string) =>
  PERMS[role]?.includes('*') || PERMS[role]?.includes(action)
```

## Sign In / Out

```tsx
import { signIn, signOut } from '@/auth'
<form action={async () => { 'use server'; await signIn('github') }}><button>Login with GitHub</button></form>
<form action={async () => { 'use server'; await signOut() }}><button>Logout</button></form>
```

## Rules
- `AUTH_SECRET` bắt buộc trong `.env` (generate bằng `npx auth secret`)
- Token: httpOnly cookie — KHÔNG localStorage
- Password: hash với bcrypt 12+ rounds
- Role lưu trong JWT token, không query DB mỗi request
