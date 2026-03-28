---
name: monitoring
description: "Error tracking & observability. Trigger khi setup Sentry, structured logging, production monitoring, alerting."
---

# Monitoring

## Error Tracking: Sentry
```bash
npm install @sentry/nextjs
npx @sentry/wizard@latest -i nextjs
```

Wizard tự tạo `sentry.client.config.ts`, `sentry.server.config.ts`, `sentry.edge.config.ts`.

```ts
// sentry.client.config.ts (thêm context)
import * as Sentry from '@sentry/nextjs'
Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,
  environment: process.env.NODE_ENV,
})
```

Capture manual:
```ts
import * as Sentry from '@sentry/nextjs'
try {
  await riskyOperation()
} catch (err) {
  Sentry.captureException(err, { extra: { userId, action: 'payment' } })
  throw err
}
```

## Structured Logging: Pino
```bash
npm install pino pino-pretty
```

```ts
// lib/logger.ts
import pino from 'pino'
export const logger = pino({
  level: process.env.LOG_LEVEL ?? 'info',
  transport: process.env.NODE_ENV !== 'production'
    ? { target: 'pino-pretty' }
    : undefined,
})

// Dùng
logger.info({ userId, action: 'login' }, 'User logged in')
logger.error({ err, userId }, 'Payment failed')
```

## Log Levels
| Level | Khi nào |
|-------|---------|
| `error` | Exception, operation thất bại |
| `warn` | Degraded state, retry |
| `info` | Business event quan trọng (login, purchase) |
| `debug` | Dev only, xóa trước production |

## Health Check Endpoint
```ts
// app/api/health/route.ts
export async function GET() {
  try {
    await prisma.$queryRaw`SELECT 1`
    return Response.json({ status: 'ok', timestamp: new Date().toISOString() })
  } catch {
    return Response.json({ status: 'error' }, { status: 503 })
  }
}
```

## Rules
- `SENTRY_DSN` trong `.env` — KHÔNG commit DSN public vào code
- Không log PII (email, password, card number)
- `tracesSampleRate: 0.1` trong production (10% requests — đủ để detect, không tốn tiền)
- Luôn log `userId` để trace lỗi theo user
