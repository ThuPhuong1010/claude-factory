---
name: docker
description: "Docker & containerization. Trigger khi deploy app, tạo Dockerfile, docker-compose, production packaging."
---

# Docker

## Next.js Dockerfile (multi-stage, tối ưu size)
```dockerfile
FROM node:20-alpine AS base

FROM base AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup -g 1001 nodejs && adduser -S nextjs -u 1001
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
```
> Yêu cầu `output: 'standalone'` trong `next.config.ts`

## docker-compose.yml (dev)
```yaml
services:
  app:
    build: .
    ports: ["3000:3000"]
    env_file: .env
    depends_on: [db]
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes: [postgres_data:/var/lib/postgresql/data]
    ports: ["5432:5432"]
volumes:
  postgres_data:
```

## .dockerignore
```
node_modules
.next
.git
*.env
*.env.*
!.env.example
```

## Commands
```bash
docker build -t myapp .
docker compose up -d
docker compose logs -f app
docker compose down -v   # xóa volumes
```

## Rules
- Multi-stage build — production image không có devDependencies
- Non-root user (`USER nextjs`) trong production
- Secrets qua env_file hoặc Docker secrets, không COPY vào image
- `.dockerignore` luôn có `*.env`
