End session. Prepare context for next session (Claude or Antigravity).

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
