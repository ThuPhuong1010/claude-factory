Review và validate plan sau /analyze. Chạy TRƯỚC /build để verify plan chắc chắn.

1. Đọc tất cả context/ files (tasks.md, prd.md, architecture.md, techstack.md)
2. Verify: tasks cover ĐỦ mọi PRD requirement — không bỏ sót F-0X nào
3. Verify: dependency graph acyclic — không có circular dependency
4. Verify: mọi task có Acceptance Criteria rõ ràng, không mơ hồ
5. Verify: MVP scope (v0.1.0) build được trong ~3-5 sessions
6. Check docs/reports/integration-needs.md → có blocker nào chưa resolve?
7. Check context/techstack.md → testing tier xác định chưa?

Output format:

```
PLAN REVIEW: {APPROVED ✅ | NEEDS_REVISION ⚠️}
─────────────────────────────────────────────
Solution : {tên từ prd.md}
Stack    : {stack từ techstack.md}
Tier     : {testing tier}

Tasks    : {total} total ({MVP count} MVP, {v0.2+ count} backlog)
Effort   : ~{S+M+L tổng} → ước tính {X} sessions

{Nếu APPROVED}:
✅ PRD coverage: full
✅ Dependencies: clean
✅ Acceptance criteria: all clear
✅ MVP scope: achievable
→ "Plan ổn. Gõ /build để bắt đầu."

{Nếu NEEDS_REVISION}:
⚠️ Issues found:
  - [Cụ thể vấn đề 1]
  - [Cụ thể vấn đề 2]
→ "Fix những điểm trên trong context/tasks.md rồi /plan lại."
```
