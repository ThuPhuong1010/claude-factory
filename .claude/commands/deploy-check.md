Pre-deploy validation. ALL must pass.

1. npm test → ALL pass?
2. npm run build → SUCCESS?
3. npm audit → no critical vulnerabilities?
4. .env.example exists with all required vars?
5. No console.log in src/?
6. No hardcoded localhost URLs?
7. Error pages (404, 500) exist?
8. README.md has setup + run instructions?

Output: READY or NOT_READY + reasons
