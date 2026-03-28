# AGENTS.md — Cross-Tool Context

Bạn đang làm việc trong AI SDLC Factory. Nhiều tool (Claude Code,
Antigravity) phối hợp trên cùng codebase qua git.

## TRƯỚC KHI LÀM GÌ — ĐỌC THEO THỨ TỰ NÀY:
1. tracklog/active.md → snapshot tình trạng hiện tại
2. tracklog/handoff.md → agent trước bàn giao gì (nếu có)
3. context/tasks.md → task list + status
4. memory/bugs.md → tránh lỗi đã biết (scan headings)

## TRƯỚC KHI DỪNG — GHI LẠI:
1. Update tracklog/active.md
2. Update context/tasks.md status
3. Bug mới → ghi memory/bugs.md
4. Commit: "chore(antigravity): session [date]"

## OWNERSHIP (tránh conflict):
- Backend, API, scripts, tests → Claude Code
- Frontend UI, components, pages → Antigravity
- Shared (types/, lib/, config) → check active.md trước khi edit

## RULES:
- Đọc docs/rules/ khi cần
- Dùng Ant Design cho tất cả UI
- TypeScript strict, no any
- Commit format: type(scope): description
