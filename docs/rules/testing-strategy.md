# Testing Strategy

Tùy theo solution type, cách test sẽ khác nhau. Template này hỗ trợ cả automated và manual testing.

## Tier 1: Code có thể chạy và test tự động
*Web app, CLI, API, scripts*

```
Viết automated tests → chạy trong CI → coverage report
Tools: Jest, pytest, go test, ...
Coverage target: > 70%
```

## Tier 2: Code chạy được nhưng cần môi trường đặc biệt
*Extension, desktop app, mobile app*

```
Unit test phần logic thuần (không cần môi trường)
Manual test checklist cho phần cần UI/runtime
File: docs/testing/manual-checklist.md
```

## Tier 3: Không chạy code trực tiếp được
*Workflow automation, process design, n8n/Zapier flows*

Tạo file `docs/testing/test-scenarios.md`:

```markdown
# Test Scenarios

## Scenario [N]: [Tên scenario]
**Điều kiện:** [setup cần thiết]
**Input:** [dữ liệu đầu vào]
**Các bước:**
1. ...
2. ...
**Expected output:** [kết quả mong đợi]
**Verify bằng:** [cách kiểm tra kết quả]
**Rollback nếu lỗi:** [cách undo]
```

## Tier 4: Solution là documentation/process
*Hướng dẫn, SOP, process design*

```
Peer review checklist
Walkthrough với 1 người thực tế
Dry-run trong môi trường staging
File: docs/testing/review-checklist.md
```

---

## Khi /test command chạy

1. Xác định tier của solution hiện tại
2. Tier 1 → chạy automated tests, báo coverage
3. Tier 2-4 → tạo/cập nhật test-scenarios.md + manual-checklist.md
4. Ghi kết quả vào docs/reports/qa-report.md

---

## Dry-run Guide (cho Tier 3)

Trước khi chạy workflow thật:
```
1. Dùng mock data thay vì data thật
2. Enable dry-run mode (nếu tool hỗ trợ)
3. Log mọi action — không execute thật
4. Review log, confirm expected behavior
5. Chạy thật với 1 record nhỏ trước
6. Scale up
```
