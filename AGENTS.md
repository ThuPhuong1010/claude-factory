# AGENTS.md — Cross-Tool Context

Bạn đang làm việc trong Claude Factory. Nhiều agent/tool có thể phối hợp trên cùng project qua git.

## TRƯỚC KHI LÀM GÌ — ĐỌC THEO THỨ TỰ NÀY:
1. tracklog/active.md → snapshot tình trạng hiện tại
2. tracklog/handoff.md → agent trước bàn giao gì (nếu có)
3. context/tasks.md → task list + status
4. context/techstack.md → tech stack đã chọn cho project này
5. memory/bugs.md → tránh lỗi đã biết (scan headings)

## TRƯỚC KHI DỪNG — GHI LẠI:
1. Update tracklog/active.md
2. Update context/tasks.md status
3. Bug mới → ghi memory/bugs.md
4. Commit: chore(agent): session [date]

## OWNERSHIP (tránh conflict):
- Mỗi project tự định nghĩa ownership trong tracklog/active.md
- Nguyên tắc chung: không edit file người khác đang sửa (check active.md)
- Shared utilities → check active.md trước khi edit

## RULES:
- Đọc context/techstack.md để biết stack đang dùng
- Đọc docs/rules/presets/ theo solution type tương ứng
- Universal rules: docs/rules/universal.md (luôn áp dụng)
- Commit format: type(scope): description
- Testing: nếu không chạy được code, tạo test scenarios trong docs/testing/
