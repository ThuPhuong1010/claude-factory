Autonomous build. NO questions asked. Self-decide everything.

SESSION START (read ONCE):
1. context/tasks.md → find next TODO task for current version
2. context/techstack.md → stack + test command + testing tier
3. tracklog/active.md → current state
4. memory/bugs.md → scan headings for known issues
5. memory/errors.md → scan headings for error patterns

PER TASK:
6. Read task acceptance criteria
7. Build the feature (code / workflow / doc / config — theo solution type)
8. Test theo tier (xem context/techstack.md):
   - Tier 1: chạy test command cho files liên quan
   - Tier 2: chạy unit tests + ghi manual checklist
   - Tier 3-4: tạo/update docs/testing/test-scenarios.md
9. Nếu lỗi → check memory/bugs.md → fix → re-test (max 3 lần)
10. Lint nếu có (xem context/techstack.md)
11. git commit -m "feat(scope): task description"
12. Update context/tasks.md → DONE
12b. CHECKPOINT: nếu (tasks completed this session) % 3 == 0 → update tracklog/active.md ngay
13. Loop to next TODO task

SESSION END:
14. Full test pass (tier 1: full suite; tier 2-4: review docs/testing/)
15. Build verify nếu có build step
16. Update tracklog/active.md
17. git commit -m "chore: session update"
