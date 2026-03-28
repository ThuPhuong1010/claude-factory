Full QA pass. Test + Coverage + Lint + Build.

1. npm test -- --coverage
2. Print: pass/fail count, coverage %
3. For files with coverage < 70%:
   a. Read source → write missing tests (edge cases, error states)
   b. Re-run only those tests
4. npm run lint
5. npm run build
6. Create/update docs/reports/qa-report.md
