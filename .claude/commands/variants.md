So sánh các approaches trước khi chọn hướng đi. Dùng khi muốn explore nhiều góc nhìn.

Đọc context/input.md + variants/current.md (nếu có).

**WebSearch trước khi brainstorm:**
Search "[problem] existing tools [year]" để biết landscape — tránh build thứ đã có sẵn tốt hơn.

## Bước 1 — Brainstorm 2-3 approaches khác nhau

Luôn xem xét spectrum từ thấp đến cao trước khi lock vào "build code":
```
Existing tool → Configure/integrate → No-code → Script → Full build
```

Mỗi approach phải khác nhau ở ít nhất 1 dimension quan trọng:
- Khác build level: no-code/low-code vs full custom
- Khác paradigm: web app vs CLI vs automation vs API
- Khác stack: JS vs Python vs no-code platform
- Khác scope: minimal vs full-featured vs AI-powered
- Khác delivery: self-host vs cloud vs file-based

**Bắt buộc có ít nhất 1 approach ở level no-code/low-code** (Zapier, n8n, Make, Notion, Airtable, Bubble...) nếu problem có thể giải theo hướng đó — kể cả khi không phải recommendation cuối cùng. Việc này giúp user thấy toàn bộ option spectrum.

## Bước 2 — Mô tả từng approach

Cho mỗi approach:

```
### Approach [A/B/C]: [Tên gợi nhớ]

**Build level:** [Existing tool / No-code / Low-code / Script / Full build]
**Một câu mô tả:** ...
**Stack/Tool:** ...
**User sẽ thấy gì:** ...
**Effort:** S / M / L / XL
**Chi phí ước tính:** [free / ~$X/tháng / one-time]

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
| Build level | | | |
| Effort đến MVP | | | |
| Chi phí | | | |
| Độ phức tạp kỹ thuật | | | |
| Dễ maintain | | | |
| Khả năng mở rộng | | | |
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
