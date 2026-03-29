# Known Bugs Database
Agent đọc file này TRƯỚC KHI code. Format mỗi entry:

```
### BUG-N: [tên ngắn]
**Symptom:** Biểu hiện ra sao (lỗi gì, ở đâu)
**Root Cause:** Nguyên nhân thật sự
**Fix:** Cách đã fix
**Prevention:** Cách tránh lần sau
```

---

<!-- EXAMPLE — xóa khi dùng thật:

### BUG-0: Example format
**Symptom:** `params.id` trả về `undefined` trong Next.js 15 dynamic route
**Root Cause:** Next.js 15 đổi `params` thành Promise — cần await trước khi access
**Fix:** `const { id } = await params` thay vì `const { id } = params`
**Prevention:** Luôn await params trong Next.js 15 App Router

-->
