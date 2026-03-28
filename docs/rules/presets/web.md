# Preset: Web App

Load khi solution type = Web App / Web Service / SaaS.

## Stack mặc định (có thể override trong context/techstack.md)
- Framework: Next.js 15 App Router
- UI: Ant Design 5.x (không mix với UI lib khác)
- Language: TypeScript strict (no any)
- State: Zustand (shared) + TanStack Query (server) + useState (local)
- Validation: Ant Design Form rules (client) + Zod (server)

## UI Rules
- Ant Design components cho tất cả UI — không tự viết nếu Ant Design đã có
- Mọi page phải có: loading (Skeleton) + empty (Empty) + error (Result) states
- Responsive: Ant Grid Row/Col với breakpoints xs/md/lg
- Colors: Ant Design token qua ConfigProvider — không hardcode hex
- Xem docs/rules/design.md để biết thêm

## Architecture
- Layers: UI → Hooks → Services → API → Database
- Không circular dependencies
- Shared code trong lib/
- Structure: src/{app,components,hooks,lib,services,stores,types}

## Testing
- Jest + React Testing Library
- Coverage > 70%
- Test behavior, không test implementation

## Database Migration
- Dùng Prisma Migrate nếu stack có Prisma: `npx prisma migrate dev`
- Dùng Drizzle Kit nếu stack có Drizzle: `npx drizzle-kit push`
- KHÔNG chạy raw SQL trực tiếp trên production DB
- Mỗi migration = 1 commit riêng, message: `chore(db): migrate <tên thay đổi>`
- Backup trước khi chạy migration trên dữ liệu thật
- Schema changes phải backward-compatible trong v0.x (không drop column ngay)

## Commands
- npm run dev | npm test | npm run lint | npm run build
