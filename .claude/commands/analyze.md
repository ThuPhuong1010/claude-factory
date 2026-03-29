Phân tích ý tưởng → propose solutions → lấy approval → generate plan.
Chạy theo 3 phases. KHÔNG bỏ qua phase nào.

> **Khi nào dùng /discover trước?**
> - Idea còn rất mờ (1-2 câu, chưa rõ vấn đề là gì) → `/discover` trước để làm rõ
> - Idea đủ rõ (đã có context/input.md với 3+ fields) → `/analyze` thẳng
> - `/analyze` cũng có PHASE 1 tự hỏi thêm nếu thiếu thông tin — `/discover` không bắt buộc

---

## PHASE 1: DISCOVER (luôn chạy đầu tiên)

Đọc context/input.md.

**ETHICAL CHECK — chạy trước khi hỏi thêm:**
Kiểm tra xem idea có chứa gray-area không:
- Scraping website có ToS cấm (Shopee, Facebook, LinkedIn, ...)
- Bulk messaging / spam automation
- Thu thập dữ liệu cá nhân không có consent rõ ràng
- Bypass authentication / rate limiting của bên thứ 3
- Impersonation hoặc fake identity

Nếu phát hiện gray-area → thông báo trước khi tiếp tục:
```
⚠️ Lưu ý: Idea này có thể liên quan đến [vấn đề cụ thể].
- [Lý do: ToS Section X, PDPA, GDPR...]
→ Tao vẫn có thể build nếu đây là use case hợp lệ.
  Confirm mày có quyền làm điều này không?
Confirm để tiếp tục, hoặc điều chỉnh ý tưởng.
```
Nếu không có gray-area → tiếp tục bình thường.

Nếu ý tưởng chưa đủ rõ, hỏi tối đa 5 câu để làm rõ:

**Câu hỏi gợi ý (chọn những câu THỰC SỰ cần thiết):**
- Mục tiêu cuối cùng là gì? (output/outcome mong muốn)
- Ai sẽ dùng? (user persona, technical level)
- Dùng ở đâu? (web, desktop, terminal, mobile, tích hợp vào tool khác)
- Có constraints nào không? (ngôn ngữ bắt buộc, OS, budget, timeline)
- Đã có solution nào chưa? Vì sao chưa đủ?
- Phần nào quan trọng nhất nếu chỉ được làm 1 thứ?
- Dữ liệu đầu vào là gì? Output format cần là gì?
- **Có tool AI khác (Antigravity) làm việc song song không?** → Nếu có, tao sẽ tự setup worktree để 2 agents không conflict.

**Format hỏi:**
```
Tao cần làm rõ thêm một số điểm trước khi propose solution:

1. [Câu hỏi cụ thể]
2. [Câu hỏi cụ thể]
...

→ Trả lời xong, chạy lại /analyze để tao tiếp tục.
```

Nếu ý tưởng đã đủ rõ → SKIP phase 1, đi thẳng phase 2.

**Context file scan (chạy tự động ngay khi bắt đầu PHASE 1):**
1. Scan `context/` folder tìm file không phải `.md/.txt/.json`
2. `.pdf` `.png` `.jpg` `.svg` → đọc trực tiếp bằng Read tool
3. `.docx` `.xlsx` `.pptx` `.html` → thông báo: "Tao thấy file [tên] chưa convert. Chạy: `python .claude/skills/context-ingestion/scripts/ingest.py context/[tên]` rồi /analyze lại."
4. `.mp3` `.wav` `.m4a` `.mp4` → thông báo: "File audio/video cần transcribe trước. Chạy: `python .claude/skills/context-ingestion/scripts/transcribe_audio.py [tên]` (cần OPENAI_API_KEY) hoặc dùng Whisper Desktop/MacWhisper free."
5. File `transcript_*.md` hoặc `*.txt` → đọc như context bình thường

**Xử lý câu trả lời về multi-agent:**
- Nếu user nói CÓ Antigravity → chạy `/worktree setup` ngay sau khi DISCOVER xong, trước khi PROPOSE.
- Nếu user nói KHÔNG → tiếp tục bình thường.

---

## PHASE 2: PROPOSE SOLUTIONS (sau khi đủ context)

Đề xuất 2-3 solutions khả thi. Mỗi solution gồm:

```
### Solution [A/B/C]: [Tên gợi nhớ]
**Mô tả:** 1-2 câu tóm tắt approach
**Stack:** [tech stack cụ thể]
**Output:** [người dùng nhận được gì]
**Effort:** [S = <1 ngày | M = 2-5 ngày | L = 1-2 tuần | XL = >2 tuần]

**Ưu điểm:**
- ...

**Nhược điểm / Rủi ro:**
- ...

**Phù hợp khi:** [điều kiện tốt nhất để chọn solution này]
```

Sau đó tạo bảng so sánh:

| Tiêu chí | Solution A | Solution B | Solution C |
|---------|-----------|-----------|-----------|
| Độ phức tạp | | | |
| Time to MVP | | | |
| Khả năng mở rộng | | | |
| Dễ maintain | | | |
| Rủi ro kỹ thuật | | | |
| Phù hợp với yêu cầu | | | |

**Recommendation:** [Solution nào tao recommend + lý do ngắn gọn]

```
→ Mày chọn solution nào? (A/B/C hoặc mix)
  Hoặc có điều chỉnh gì không?
```

**DỪNG LẠI. Chờ user chọn. KHÔNG tự generate plan.**

---

## PHASE 3: GENERATE PLAN (chỉ sau khi user đã chọn)

Sau khi user confirm solution:

1. Load rules:
   - docs/rules/universal.md
   - docs/rules/presets/{type}.md theo solution type
2. Xác định Testing Tier từ docs/rules/testing-strategy.md
3. Tạo context/techstack.md — stack + commands + testing tier
4. Tạo context/prd.md từ templates/prd.md
5. Tạo context/architecture.md — cấu trúc + mermaid diagram
6. Tạo context/tasks.md — task list đầy đủ:
   - ID, Title, Description, Acceptance Criteria
   - Dependencies, Effort (S/M/L), Status: TODO, Version: v0.1.0
7. Nếu cần external service → RAISE vào docs/reports/integration-needs.md
8. Tạo versions/v0.1.0.md + versions/current.md
9. Ghi solution đã chọn vào variants/current.md
10. Tạo docs/guides/how-to-run.md từ templates/how-to-run.md:
    - Mô tả đơn giản: "Tool này làm gì" (không có từ kỹ thuật)
    - Install steps + run steps theo solution type và OS của user
    - Verify checklist: user tự check không cần đọc code
    - Troubleshooting 2-3 lỗi phổ biến nhất của stack này
    → File này phải đọc được bởi người NON-TECH
11. Tóm tắt output:
    - Solution + stack đã chọn
    - Testing tier
    - Số tasks + tổng effort ước tính (cộng effort từng task)
    - Timeline ước tính: "~X ngày nếu build liên tục"
    - Next step: "Gõ /build để bắt đầu"

IMPORTANT: MVP = nhỏ nhất có thể verify được ý tưởng. Defer nice-to-haves sang v0.2.0+.
