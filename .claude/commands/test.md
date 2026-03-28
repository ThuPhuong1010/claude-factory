Full QA pass theo testing tier của solution.

1. Đọc context/techstack.md → xác định Testing Tier
2. Đọc docs/rules/testing-strategy.md

Tier 1 (automated):
- Chạy test command + coverage
- Tier files < 70% → viết thêm tests (edge cases, error states)
- Chạy lint + build verify
- Ghi kết quả vào docs/reports/qa-report.md

Tier 2 (hybrid):
- Chạy unit tests cho logic thuần
- Tạo/update docs/testing/manual-checklist.md
- Ghi kết quả vào docs/reports/qa-report.md

Tier 3 (workflow/automation):
- Tạo/update docs/testing/test-scenarios.md
- Mỗi scenario: input, steps, expected output, cách verify, rollback
- Thêm dry-run guide nếu có destructive steps

Tier 4 (documentation/process):
- Tạo docs/testing/review-checklist.md
- Walkthrough checklist đầy đủ

Luôn tạo docs/reports/qa-report.md:
- Solution type + Testing tier
- Kết quả: pass/fail/pending manual
- Issues tìm thấy
- Coverage (nếu có)
- Next steps
