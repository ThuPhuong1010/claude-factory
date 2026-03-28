End session. Prepare context for next session (Claude or Antigravity).

PRE-HANDOFF VERIFY (chạy trước, bắt buộc):
- [ ] git status → không có uncommitted changes (hoặc ghi rõ lý do)
- [ ] Tests pass (hoặc document test nào failing + lý do chấp nhận được)
- [ ] Không có task IN_PROGRESS mà chưa ghi % hoàn thành
- [ ] Mọi [NEEDS_HUMAN] đã được document trong context/tasks.md
Nếu có item chưa pass → fix trước khi handoff, hoặc ghi rõ vào handoff.md.

1. Summarize this session:
   - Tasks completed (list IDs)
   - Tasks in progress (ID + % + what remains)
   - Bugs found/fixed
   - Decisions made
   - Files changed: git diff --stat
2. Write tracklog/handoff.md
3. Update tracklog/active.md
4. git add -A && git commit -m "chore: handoff"
5. Print: "Handoff ready."
