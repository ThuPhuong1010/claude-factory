So sánh các approaches trước khi chọn hướng đi. Dùng khi muốn explore nhiều góc nhìn.

Đọc context/input.md + variants/current.md (nếu có).

## Bước 1 — Brainstorm 2-3 approaches khác nhau

Mỗi approach phải khác nhau ở ít nhất 1 dimension quan trọng:
- Khác paradigm: web app vs CLI vs automation vs API
- Khác stack: JS vs Python vs no-code
- Khác scope: minimal vs full-featured vs AI-powered
- Khác delivery: self-host vs cloud vs file-based

## Bước 2 — Mô tả từng approach

Cho mỗi approach:

```
### Approach [A/B/C]: [Tên gợi nhớ]

**Một câu mô tả:** ...
**Stack:** ...
**User sẽ thấy gì:** ...
**Effort:** S / M / L / XL

**Ưu điểm:**
- ...
**Nhược điểm:**
- ...
**Rủi ro:**
- ...
**Phù hợp khi:** ...
**Không phù hợp khi:** ...
```

## Bước 3 — Bảng so sánh

| Tiêu chí | A: [Tên] | B: [Tên] | C: [Tên] |
|---------|---------|---------|---------|
| Effort đến MVP | | | |
| Độ phức tạp kỹ thuật | | | |
| Dễ test | | | |
| Khả năng mở rộng | | | |
| Dễ maintain | | | |
| Rủi ro kỹ thuật | | | |
| Phù hợp yêu cầu | ⭐⭐⭐ | ⭐⭐ | ⭐ |

**Recommendation:** [Approach nào + lý do cụ thể]

## Bước 4 — Hỏi user

```
Tao recommend [A/B/C] vì [lý do ngắn].

Mày chọn approach nào? Hoặc muốn mix ý tưởng từ nhiều approach?
```

**DỪNG. Chờ user trả lời.**

## Bước 5 — Sau khi user chọn

- Ghi kết quả vào variants/current.md
- Tạo variants/variant-{chữ}/ với approach.md, pros-cons.md, techstack.md, effort.md
- Tạo variants/comparison.md (bảng so sánh đầy đủ)
- Thông báo: "Đã lưu. Chạy /analyze để generate plan cho approach này."
