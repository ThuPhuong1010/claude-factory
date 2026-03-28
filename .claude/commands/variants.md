Test nhiều approach cho cùng ý tưởng.

1. Read context/input.md — hiểu ý tưởng gốc
2. Brainstorm 2-3 approaches khác nhau:
   - Khác UI paradigm (kanban vs calendar vs list)
   - Khác tech approach (SSR vs SPA, SQL vs NoSQL)
   - Khác feature priority (simple-first vs ai-first)
3. Cho mỗi approach, tạo folder variants/variant-{a,b,c}/:
   - approach.md: mô tả ngắn + user flow
   - pros-cons.md: ưu điểm, nhược điểm, rủi ro
   - techstack.md: stack nếu khác default
   - effort.md: estimate S/M/L + timeline
4. Tạo variants/comparison.md: bảng so sánh
   | Criteria | Variant A | Variant B | Variant C |
   |----------|-----------|-----------|-----------|
   | Complexity | | | |
   | Time to MVP | | | |
   | Scalability | | | |
   | UX quality | | | |
   | Risk | | | |
5. Đề xuất variant recommend + lý do
6. Hỏi user: "Chọn variant nào?"
7. Sau khi chọn → ghi vào variants/current.md
8. Copy techstack/approach sang context/ để /analyze dùng
