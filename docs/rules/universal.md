# Universal Rules
Áp dụng cho MỌI solution type, mọi tech stack.

## Code Quality
- Max 300 lines/file, 50 lines/function
- Naming: rõ ràng, tự mô tả — không cần comment để giải thích tên
- Không có magic numbers — đặt tên constant
- Không nested quá 3 levels
- Không code commented-out (xóa hẳn, dùng git nếu cần)
- Không debug output / console.log trong production

## Error Handling
- Mọi async operation đều có error handling
- Không có empty catch blocks
- Lỗi phải được log hoặc propagate — không được nuốt im
- User-facing errors phải có message rõ ràng

## Security
- Không hardcode secrets, API keys, passwords
- Dùng environment variables cho config nhạy cảm
- Validate mọi input từ bên ngoài (user, file, API, env)
- Không expose internal errors ra ngoài

## Version Control
- Commit format: `type(scope): description`
  - type: feat | fix | chore | docs | refactor | test
- Mỗi commit = một unit of work có ý nghĩa
- Không commit broken state

## Documentation
- README phải có: what it does, how to run, how to test
- Mọi non-obvious decision → ghi vào context/decisions.md
- External dependencies → ghi lý do chọn vào context/decisions.md

## Environment
- KHÔNG commit file .env, .env.local, .env.production
- Dùng templates/.env.example làm template — commit file này
- Thêm variable mới vào .env.example trước khi dùng trong code
- Validate required env vars khi startup, fail fast nếu thiếu
- Gitignore phải có: .env, .env.local, .env*.local

## Memory Rotation
- memory/bugs.md có thể accumulate theo thời gian
- Bug đã được fix và đã qua 2 versions: move entry sang memory/archive/bugs.md
- Giữ memory/bugs.md chỉ chứa bugs còn relevant với version hiện tại
- Scan heading counts: nếu > 20 entries → review và archive entries cũ
