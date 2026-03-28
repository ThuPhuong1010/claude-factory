Phân tích ý tưởng → propose solutions → lấy approval → generate plan.
Chạy theo 3 phases. KHÔNG bỏ qua phase nào.

---

## PHASE 1: DISCOVER (luôn chạy đầu tiên)

Đọc context/input.md. Nếu ý tưởng chưa đủ rõ, hỏi tối đa 5 câu để làm rõ:

**Câu hỏi gợi ý (chọn những câu THỰC SỰ cần thiết):**
- Mục tiêu cuối cùng là gì? (output/outcome mong muốn)
- Ai sẽ dùng? (user persona, technical level)
- Dùng ở đâu? (web, desktop, terminal, mobile, tích hợp vào tool khác)
- Có constraints nào không? (ngôn ngữ bắt buộc, OS, budget, timeline)
- Đã có solution nào chưa? Vì sao chưa đủ?
- Phần nào quan trọng nhất nếu chỉ được làm 1 thứ?
- Dữ liệu đầu vào là gì? Output format cần là gì?

**Format hỏi:**
```
Tao cần làm rõ thêm một số điểm trước khi propose solution:

1. [Câu hỏi cụ thể]
2. [Câu hỏi cụ thể]
...

→ Trả lời xong, chạy lại /analyze để tao tiếp tục.
```

Nếu ý tưởng đã đủ rõ → SKIP phase 1, đi thẳng phase 2.

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
10. Tóm tắt: solution chọn, stack, testing tier, số tasks, next step

IMPORTANT: MVP = nhỏ nhất có thể verify được ý tưởng. Defer nice-to-haves sang v0.2.0+.
