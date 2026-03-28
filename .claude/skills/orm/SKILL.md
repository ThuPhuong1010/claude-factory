---
name: orm
description: "Prisma ORM — schema, migration, query. Trigger khi tạo database models, query DB, migration."
versions: { prisma: "^6", "@prisma/client": "^6" }
---

# ORM (Prisma v6)

```bash
npm install prisma @prisma/client
npx prisma init --datasource-provider postgresql
```

`DATABASE_URL` trong `.env`. Thêm `.env` vào `.gitignore`.

## Schema Pattern

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  role      Role     @default(USER)
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?        // soft delete
}

enum Role { USER ADMIN }
```

## Client Singleton

```ts
// lib/prisma.ts
import { PrismaClient } from '@prisma/client'
const globalForPrisma = globalThis as unknown as { prisma: PrismaClient }
export const prisma = globalForPrisma.prisma ?? new PrismaClient()
if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

## Migrations

```bash
npx prisma migrate dev --name init    # tạo migration + apply (dev)
npx prisma migrate deploy             # apply migrations (production)
npx prisma db seed                    # seed data
npx prisma studio                     # GUI localhost:5555
npx prisma generate                   # regenerate client sau khi đổi schema
```

## Query Patterns

```ts
// Create
const user = await prisma.user.create({ data: { email, name } })

// Read với include
const user = await prisma.user.findUnique({
  where: { id },
  include: { posts: { where: { deletedAt: null } } },
})

// Pagination
const [items, total] = await prisma.$transaction([
  prisma.post.findMany({ skip: (page - 1) * limit, take: limit, orderBy: { createdAt: 'desc' } }),
  prisma.post.count({ where: { deletedAt: null } }),
])

// Upsert
await prisma.user.upsert({
  where: { email },
  update: { name },
  create: { email, name },
})

// Soft delete (khuyến nghị hơn hard delete)
await prisma.user.update({ where: { id }, data: { deletedAt: new Date() } })

// Atomic increment
await prisma.post.update({ where: { id }, data: { views: { increment: 1 } } })
```

## Rules
- ID: `cuid()` hoặc `uuid()` — không dùng auto-increment integer (expose sequence)
- Mọi model: `createdAt`, `updatedAt`, `deletedAt` (optional)
- Soft delete với `deletedAt` thay hard delete cho data quan trọng
- Không dùng `$queryRaw` trừ khi Prisma API không đáp ứng được
- Filter `deletedAt: null` trong mọi query (không lấy soft-deleted records)
