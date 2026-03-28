---
name: ci-cd
description: "GitHub Actions CI/CD pipeline. Trigger khi setup deployment pipeline, automate test/build/deploy, tạo workflow .yml."
---

# CI/CD (GitHub Actions)

## Pipeline chuẩn Next.js
```yaml
# .github/workflows/ci.yml
name: CI
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: npm }
      - run: npm ci
      - run: npm run lint
      - run: npm test -- --coverage
      - run: npm run build
```

## Deploy to Vercel
```yaml
# Thêm vào ci.yml sau job test
  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

## Secrets Management
```bash
# Set via GitHub CLI
gh secret set VERCEL_TOKEN
gh secret set DATABASE_URL
```
Dùng `${{ secrets.NAME }}` trong workflow. KHÔNG hardcode.

## Database Migration trong CI
```yaml
- name: Run migrations
  run: npx prisma migrate deploy
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

## Quick Reference
| Pattern | Syntax |
|---------|--------|
| Chỉ chạy trên main | `if: github.ref == 'refs/heads/main'` |
| Chờ job khác | `needs: [test, lint]` |
| Cache npm | `actions/setup-node@v4` với `cache: npm` |
| Matrix test | `strategy: matrix: node: [18, 20]` |
| Manual trigger | `on: workflow_dispatch` |
