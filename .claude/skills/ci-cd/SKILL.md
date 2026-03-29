---
name: ci-cd
description: "GitHub Actions CI/CD pipeline. Trigger khi setup deployment pipeline, automate test/build/deploy, tạo workflow .yml."
---

# CI/CD (GitHub Actions)

## Khi nào cần đọc skill này
- Setup CI/CD pipeline lần đầu
- Thêm automated testing vào GitHub Actions
- Config deployment tự động lên Vercel / VPS / Docker
- Cần multi-environment (staging + production)

---

## Phân tích — Chọn deployment target

| Target | Tool | Khi nào |
|--------|------|---------|
| Next.js / Node | Vercel Action | Web app nhanh nhất |
| Containerized app | Docker + VPS / Cloud Run | Cần full control |
| Python script/bot | VPS + systemd / Docker | Long-running process |
| Static site | GitHub Pages | Docs, landing page |
| Mobile | Expo EAS | React Native |

---

## Design — Pipeline chuẩn

```
Push to main / PR open
    ↓
[test] → lint + test + build
    ↓ (chỉ main branch)
[deploy] → build image / upload → deploy → health check
```

---

## Web App (Next.js → Vercel)

```yaml
# .github/workflows/ci.yml
name: CI/CD
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

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

---

## Python App / Bot (Docker → VPS)

```yaml
name: CI/CD Python
on:
  push: { branches: [main] }

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: '3.12' }
      - run: pip install -r requirements.txt
      - run: pytest --tb=short
      - run: pip audit  # security check

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build & push Docker image
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:latest
        env:
          DOCKER_BUILDKIT: 1
      - name: Deploy to VPS
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            docker pull ghcr.io/${{ github.repository }}:latest
            docker stop app || true
            docker run -d --name app --restart unless-stopped \
              --env-file /etc/app/.env \
              ghcr.io/${{ github.repository }}:latest
```

---

## Multi-environment (staging + production)

```yaml
jobs:
  deploy-staging:
    if: github.ref == 'refs/heads/develop'
    environment: staging
    steps:
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          # staging deploy (không có --prod flag)

  deploy-production:
    if: github.ref == 'refs/heads/main'
    environment: production    # requires manual approval in GitHub
    needs: test
    steps:
      - uses: amondnet/vercel-action@v25
        with:
          vercel-args: '--prod'
```

---

## Secrets Management

```bash
# Set via GitHub CLI
gh secret set VERCEL_TOKEN
gh secret set DATABASE_URL
gh secret set VPS_SSH_KEY

# Dùng trong workflow
${{ secrets.SECRET_NAME }}
```

**Không hardcode bất kỳ secret nào trong `.yml` file.**
Dùng GitHub Environments để phân tách staging/production secrets.

## Database Migration trong CI

```yaml
- name: Run migrations
  run: npx prisma migrate deploy
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

---

## Quick Reference

| Pattern | Syntax |
|---------|--------|
| Chỉ chạy trên main | `if: github.ref == 'refs/heads/main'` |
| Chờ job khác | `needs: [test, lint]` |
| Cache npm | `actions/setup-node@v4` với `cache: npm` |
| Cache pip | `actions/setup-python@v5` với `cache: pip` |
| Matrix test | `strategy: matrix: python: ['3.11', '3.12']` |
| Manual trigger | `on: workflow_dispatch` |
| Manual approval | `environment: production` (set Protection Rules trong GitHub) |

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| Hardcode secret trong yml | `${{ secrets.NAME }}` |
| Deploy khi test fail | `needs: test` + `if: success()` |
| Không cache dependencies | `cache: npm` / `cache: pip` |
| Deploy tất cả branches | `if: github.ref == 'refs/heads/main'` |
| Không có health check sau deploy | Thêm step curl health endpoint |
