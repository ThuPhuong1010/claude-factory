# Error Patterns
Ghi lại các pattern sai hay gặp. Format:

```
### ERR-N: [tên pattern]
**Wrong:** code/approach sai
**Right:** code/approach đúng
**Why:** Tại sao cái sai hay xảy ra và tại sao cái đúng tốt hơn
```

---

<!-- EXAMPLE — xóa khi dùng thật:

### ERR-0: Example format
**Wrong:** `catch(e) {}` — empty catch block
**Right:** `catch(e) { logger.error('[ModuleName]', e); throw e }`
**Why:** Empty catch nuốt lỗi im lặng → bug khó debug sau này. Luôn log hoặc re-throw.

-->
