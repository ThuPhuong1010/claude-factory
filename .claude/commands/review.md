Code review on all changed files since last commit on main.

1. git diff main --name-only → list changed files
2. Per file, check:
   CORRECTNESS: logic correct, edge cases, error handling
   QUALITY: no duplication, file<300 lines, naming conventions
   SECURITY: no secrets, input validated, auth checks
   UI (if .tsx): Ant Design used, loading/error states, responsive
3. Auto-fix: low severity issues
4. Report: medium/high severity findings
