Làm rõ ý tưởng qua hội thoại — dùng trước /analyze khi idea còn mơ hồ.

Đọc context/input.md. Dẫn dắt user qua một cuộc hội thoại có cấu trúc để làm rõ ý tưởng trước khi propose solution.

## Quy trình

**Bước 1 — Đọc và tóm tắt:**
Tóm tắt lại những gì tao hiểu từ input.md trong 2-3 câu.
"Tao hiểu mày muốn [X] để giải quyết [Y] cho [Z]. Đúng không?"

**Bước 2 — Hỏi từng câu một (KHÔNG hỏi tất cả cùng lúc):**
Chọn câu quan trọng nhất chưa rõ, hỏi trước. Sau khi có trả lời, hỏi tiếp nếu cần.

Bộ câu hỏi gợi ý:
- "Output cuối cùng mày muốn là gì? File, web page, notification, hay gì khác?"
- "Mày sẽ dùng nó thường xuyên không, hay chỉ chạy 1 lần?"
- "Ai khác sẽ dùng nó ngoài mày? Họ technical không?"
- "Mày muốn tự host hay dùng cloud?"
- "Có deadline hoặc constraint về tech không?"
- "Phần nào mày thấy khó nhất / chưa biết làm?"
- "Đã thử solution nào chưa? Tại sao chưa ổn?"

**Bước 3 — Confirm understanding:**
Sau 3-5 câu hỏi, tóm tắt lại toàn bộ understanding:

```
Okay, tao hiểu rồi. Tóm tắt:
- Mục tiêu: ...
- User: ...
- Output cần: ...
- Constraints: ...
- Phần quan trọng nhất: ...

Có gì cần chỉnh không? Nếu ổn, chạy /analyze để tao propose solutions.
```

**Bước 4 — Update context/input.md:**
Append phần "## Clarifications" vào input.md với tất cả answers.

## Khi nào dùng /discover vs /analyze?
- /analyze: idea đã khá rõ, muốn đi nhanh
- /discover: idea còn mơ hồ, muốn được dẫn dắt qua hội thoại
