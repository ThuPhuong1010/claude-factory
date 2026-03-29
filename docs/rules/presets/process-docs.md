# Preset: Process / Documentation

Load khi solution type = SOP, Runbook, System Design, Technical Documentation, Process Design.

## Types thuộc preset này

- Standard Operating Procedure (SOP)
- Runbook / Incident response guide
- System design document
- Technical specification
- Onboarding guide
- API documentation

## Output Format

Tất cả deliverables là Markdown files, trừ khi user yêu cầu docx/pdf.
Dùng skill `document-generation` nếu cần export ra file.

## Structure

```
docs/
├── overview.md          # Tổng quan — viết cho người mới
├── architecture.md      # System design (nếu applicable)
├── processes/           # SOPs, workflows
│   ├── process-A.md
│   └── process-B.md
├── runbooks/            # Incident + operational guides
│   ├── deployment.md
│   └── incident-response.md
├── guides/
│   ├── onboarding.md    # Setup + first steps
│   └── how-to-run.md    # Sinh từ templates/how-to-run.md
└── reference/           # API reference, glossary, etc.
```

## Document Quality Rules

**Mỗi document phải có:**
- **Audience**: viết cho ai (developer? non-tech? ops?)
- **Prerequisites**: cần biết gì / có gì trước khi đọc
- **Scope**: document này cover gì, không cover gì
- **Last updated**: ngày cập nhật cuối

**Viết để người mới hiểu được:**
- Không assume knowledge — giải thích thuật ngữ lần đầu dùng
- Ví dụ cụ thể hơn lý thuyết trừu tượng
- Step-by-step > paragraph dài
- Diagrams (Mermaid) cho flows phức tạp

**SOP format:**
```markdown
# SOP: [Tên quy trình]
**Audience:** [ai thực hiện]
**Trigger:** [khi nào chạy quy trình này]
**Prerequisites:** [cần gì trước]

## Steps
1. [Bước 1 — action cụ thể]
2. [Bước 2]
...

## Verify
- [ ] [Cách kiểm tra đã xong đúng]

## Rollback (nếu có)
[Cách hoàn tác nếu có vấn đề]
```

**Runbook format:**
```markdown
# Runbook: [Tên sự cố / Operation]
**Severity:** P1 / P2 / P3
**ETA to resolve:** [ước tính]

## Symptoms
[Biểu hiện nhận ra vấn đề này]

## Diagnosis
[Các bước kiểm tra để confirm]

## Resolution
[Các bước fix step-by-step]

## Escalation
[Khi nào và escalate cho ai]
```

## Testing (Tier 4)

Tạo `docs/testing/review-checklist.md`:
```
## Documentation Review Checklist
- [ ] Đọc được bởi target audience mà không cần hỏi thêm
- [ ] Tất cả steps đã walkthrough thực tế (không chỉ lý thuyết)
- [ ] Diagrams reflect hiện trạng thật
- [ ] Links hoạt động
- [ ] Không có "TODO" hoặc placeholder còn sót
- [ ] Peer review bởi ít nhất 1 người khác
```
