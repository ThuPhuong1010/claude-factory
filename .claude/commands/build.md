Autonomous build. NO questions asked. Self-decide everything.

SESSION START (read ONCE):
1. context/tasks.md → find next TODO task for current version
2. tracklog/active.md → current state
3. memory/bugs.md → scan headings for known issues
4. memory/errors.md → scan headings for error patterns

PER TASK:
5. Read task acceptance criteria
6. Code the feature (skills auto-trigger by file type)
7. Write test for the feature
8. Run: npm test -- --related {changed files} (NOT full suite)
9. If test fails → check memory/bugs.md → fix → re-test (max 3)
10. npm run lint -- --fix
11. git add -A && git commit -m "feat(scope): task description"
12. Update task status in context/tasks.md → DONE
13. Loop to next TODO task

SESSION END:
14. npm test (full suite — one time)
15. npm run build (verify)
16. Update tracklog/active.md
17. git add -A && git commit -m "chore: session update"
