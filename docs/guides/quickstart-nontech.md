# Hướng Dẫn Bắt Đầu — Dành Cho Người Không Biết Code

Bạn không cần biết lập trình để dùng Claude Factory. Tài liệu này hướng dẫn từng bước bằng ngôn ngữ đơn giản.

---

## Bạn cần chuẩn bị gì?

| Thứ cần có | Cách có |
|-----------|---------|
| Claude Code (ứng dụng AI) | Tải tại claude.ai/code |
| Tài khoản Claude (Pro hoặc Max) | Đăng ký tại claude.ai |
| Folder template này | Copy vào máy tính của bạn |

> Không cần cài Node.js, Python, hay bất kỳ thứ gì khác lúc này.
> Claude sẽ tự lo phần kỹ thuật.

---

## 5 Bước Để Có Solution Đầu Tiên

### Bước 1 — Mở ứng dụng Claude Code

**Trên Windows:**
1. Tải Claude Code tại claude.ai/code → cài đặt
2. Mở Claude Code
3. Chọn **"Open Folder"** → chọn folder template này

**Trên Mac:**
1. Tải Claude Code tại claude.ai/code → kéo vào Applications
2. Mở Claude Code → chọn folder template này

---

### Bước 2 — Mô tả ý tưởng của bạn

Mở file `context/input.md` và điền vào:

```
## Idea
Tôi muốn có một tool tự động ghép 5 file Excel báo cáo hàng tuần thành 1 file tổng hợp.

## Problem
Mỗi tuần tôi mất 2 tiếng để copy-paste dữ liệu từ 5 file vào 1 file chung. Rất tốn thời gian và hay bị nhầm.

## Target Users
Chỉ mình tôi dùng, trên máy tính Windows

## Must-have
1. Đọc 5 file Excel từ một folder
2. Gộp vào 1 sheet tổng hợp
3. Tự đặt tên file theo ngày

## Constraints
- Máy Windows, không cài Python sẵn
```

> **Mẹo:** Viết như đang giải thích cho người bạn nghe. Càng cụ thể càng tốt. Không cần dùng từ kỹ thuật.

**Có ý tưởng ở dạng file khác?** Copy vào folder `context/` rồi ghi tên file vào phần "Context Files":

| Bạn có gì | Làm gì |
|-----------|--------|
| File Word (.docx) | Copy vào `context/`, Claude tự convert |
| File Excel (.xlsx) | Copy vào `context/`, Claude tự convert |
| File PDF | Copy vào `context/`, Claude đọc trực tiếp |
| Ảnh wireframe/mockup | Copy vào `context/`, Claude đọc trực tiếp |
| Ảnh chụp bảng trắng | Copy vào `context/`, Claude đọc trực tiếp |
| Ghi âm cuộc họp | Dùng Whisper Desktop (Windows) hoặc MacWhisper → copy text vào input.md |
| Link Figma / Notion | Paste link vào input.md, Claude hướng dẫn setup tiếp |

---

### Bước 3 — Để Claude phân tích

Trong Claude Code, gõ vào ô chat:

```
/analyze
```

Claude sẽ:
1. Đọc ý tưởng của bạn
2. Đề xuất 2-3 cách làm khác nhau (giải thích đơn giản)
3. Hỏi bạn chọn cách nào

**Đọc phần "Output — Bạn nhận được gì" để hiểu mỗi cách cho ra thứ gì.** Chọn cách phù hợp nhất với bạn.

---

### Bước 4 — Build

Sau khi bạn chọn hướng đi, gõ:

```
/build
```

Claude sẽ tự làm việc — **bạn không cần làm gì**. Quá trình này có thể mất 5-30 phút tùy độ phức tạp.

Khi Claude xong, bạn sẽ thấy thông báo **"Session done"**.

---

### Bước 5 — Xem hướng dẫn sử dụng

Claude tự tạo file hướng dẫn tại: `docs/guides/how-to-run.md`

File này sẽ giải thích:
- Tool của bạn đã sẵn sàng chưa
- Cách chạy/dùng nó (từng bước, không cần kỹ thuật)
- Nếu có lỗi thì làm gì

---

## Các Loại Solution Và Bạn Nhận Được Gì

| Loại ý tưởng | Bạn nhận được |
|-------------|--------------|
| Tự động hóa file Excel, CSV | File script — chạy bằng double-click |
| Automation gửi email, Slack | Flow n8n hoặc Make — import và chạy |
| Web dashboard xem báo cáo | App web — mở trên trình duyệt |
| Quy trình, SOP, tài liệu | File PDF/Word/Markdown |
| Bot Telegram, Zalo | Script — chạy trên server/máy tính |

---

## Khi Bạn Không Hiểu Điều Claude Đang Hỏi

Nếu Claude hỏi điều gì bạn không hiểu (VD: "Bạn muốn dùng PostgreSQL hay SQLite?"), **cứ trả lời đơn giản bằng tiếng Việt**:

> "Tôi không biết cái đó là gì. Hãy chọn cái nào phù hợp nhất với người không biết code."

Claude sẽ tự quyết định và giải thích lý do.

---

## Câu Hỏi Thường Gặp

**Q: Tôi phải biết code để dùng không?**
A: Không. Claude viết code thay bạn. Bạn chỉ cần mô tả vấn đề.

**Q: Nếu tool Claude tạo ra bị lỗi thì sao?**
A: Gõ `/fix` và Claude sẽ tự debug. Nếu không fix được, Claude sẽ giải thích để bạn nhờ người khác giúp.

**Q: Tool này an toàn không? Dữ liệu của tôi có bị lấy không?**
A: Code chạy hoàn toàn trên máy tính của bạn. Claude chỉ đọc và viết file trong folder này.

**Q: Tôi có thể yêu cầu Claude giải thích code không?**
A: Có. Hỏi thẳng: "Giải thích cho tôi hiểu đoạn code này làm gì?" Claude sẽ giải thích bằng ngôn ngữ đơn giản.

**Q: Làm xong rồi, tôi muốn thêm tính năng mới?**
A: Mở lại Claude Code, gõ `/status` để xem trạng thái, rồi mô tả tính năng muốn thêm.

---

## Khi Cần Hỗ Trợ

Nếu bị mắc kẹt ở bất kỳ bước nào, nhờ người có kiến thức IT đọc file `docs/reports/integration-needs.md` — file này liệt kê những gì Claude cần trợ giúp từ bên ngoài.
