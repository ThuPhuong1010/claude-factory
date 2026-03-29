# Patterns That Work
Ghi lại patterns đã được validate là tốt. Format:

```
### PAT-N: [tên pattern]
**Context:** Khi nào dùng pattern này
**Pattern:** Mô tả hoặc code snippet
**Why it works:** Tại sao pattern này hiệu quả
```

---

<!-- EXAMPLE — xóa khi dùng thật:

### PAT-0: Example format
**Context:** Khi cần wrap nhiều API routes với error handling
**Pattern:** `withErrorHandler(handler)` wrapper — catch AppError → trả về structured JSON, catch unknown → log + 500
**Why it works:** Centralize error logic ở một chỗ, không lặp try-catch trong mỗi route

-->
