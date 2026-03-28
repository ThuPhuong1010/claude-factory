# Security Rules

## Code Security
JWT in httpOnly cookies. bcrypt 12+ rounds. Sanitize all input.
Secrets in .env only. CORS specific origins. npm audit.

## Settings File Warning
`.claude/settings.json` dùng `"defaultMode": "bypassPermissions"`.
- Chế độ này cho phép Claude execute mà không cần confirm từng lệnh
- Phù hợp khi dùng LOCAL cho project cá nhân, đã trust môi trường
- KHÔNG share file này khi distribute template — người nhận sẽ bị bypass permissions mà không biết
- Khi share template: đổi `defaultMode` thành `"default"` hoặc `"acceptEdits"` trước khi commit
