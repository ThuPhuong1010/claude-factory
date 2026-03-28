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
