Research real-time một topic cụ thể — tools, pricing, best practices, libraries, alternatives.
Dùng WebSearch để lấy thông tin mới nhất, tổng hợp thành summary có thể hành động.

---

## Khi nào dùng /research

- Chưa biết landscape của một domain (tools nào đang có, cái nào phổ biến)
- Cần verify pricing / free tier trước khi commit vào một tool
- Muốn so sánh libraries/frameworks trước khi /analyze
- Cần best practices cho một problem cụ thể
- Muốn biết có no-code/low-code solution không trước khi build

---

## Cách dùng

```
/research [topic]

Ví dụ:
/research "tools gửi email tự động free tier"
/research "Zapier vs Make so sánh 2025"
/research "best Python PDF generation library"
/research "no-code app builder cho internal tool"
/research "Stripe payment Vietnam support"
```

---

## Quy trình thực hiện

### Bước 1 — Xác định search queries

Từ topic của user, tạo 3-5 search queries bao phủ các góc:
- Landscape query: `"[topic] tools 2025"` hoặc `"[topic] alternatives"`
- Pricing query: `"[tool] pricing free tier limits"`
- Limitation query: `"[tool] limitations problems reddit"` hoặc `"[tool] vs [tool]"`
- Best practice: `"[topic] best practices [year]"`

### Bước 2 — Search và collect

Chạy WebSearch cho từng query. Thu thập:
- Tên tools/options chính trong domain
- Pricing tiers (đặc biệt free/starter)
- Điểm mạnh / yếu thực tế từ user reviews
- Gotchas không được ghi trong docs chính thức

### Bước 3 — Output report

```
## Research: [Topic]
*Ngày: [date] — kết quả có thể thay đổi, verify lại nếu cần*

### TL;DR
[2-3 câu tóm tắt: option tốt nhất cho use case phổ biến là gì]

### Options Overview

| Tool/Option | Free tier | Paid từ | Phù hợp khi | Không phù hợp khi |
|-------------|----------|---------|------------|-----------------|
| ... | ... | ... | ... | ... |

### Chi tiết từng option

#### [Option A]
- **Free tier:** [cụ thể: X requests/month, Y users, ...]
- **Ưu:** ...
- **Nhược / Gotchas:** ...
- **Verdict:** [dùng khi nào]

#### [Option B]
...

### Recommendation theo use case

| Nếu mày cần... | Dùng |
|---------------|------|
| [use case 1] | [tool + lý do ngắn] |
| [use case 2] | [tool + lý do ngắn] |
| [use case 3] | [tool + lý do ngắn] |

### Sources
- [url 1]
- [url 2]
```

### Bước 4 — Suggest next steps

Sau report, suggest:
```
→ Muốn tao compare sâu hơn giữa [A] và [B] không?
→ Muốn tao generate setup guide cho [recommended option]?
→ Muốn chạy /analyze với [recommended approach]?
```

---

## Lưu ý

- Luôn ghi ngày search — pricing và features thay đổi nhanh
- Ưu tiên primary sources (official pricing page) hơn review sites cho pricing
- Với "free tier": verify rõ limits — nhiều tool free nhưng limit rất thấp
- Nếu không tìm được thông tin → nói thẳng "Không tìm được, verify tại [url]"
