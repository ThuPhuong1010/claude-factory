# Parallel Work Test — Chứng minh Claude + Antigravity làm việc song song

## Cơ chế hoạt động

Hai agents tránh conflict bằng cách:
1. **File ownership** — mỗi agent có zone riêng, không đụng zone nhau
2. **Lock file** — `tracklog/active.md` track ai đang edit file shared
3. **Branch isolation** — branch riêng cho features phức tạp

---

## Test A: Parallel edit không conflict (happy path)

### Setup
```bash
git checkout -b test/parallel-demo
```

### Bước 1 — Claude edit backend file
```bash
# Simulate Claude editing API file (backend zone)
echo "// Claude was here" >> src/app/api/test-route.ts
git add src/app/api/test-route.ts
git commit -m "feat(claude/api): add test route"
```

### Bước 2 — Antigravity edit frontend file (cùng lúc, khác file)
```bash
# Simulate Antigravity editing component (frontend zone)
echo "// Antigravity was here" >> src/components/TestComponent.tsx
git add src/components/TestComponent.tsx
git commit -m "feat(antigravity/ui): add test component"
```

### Kết quả mong đợi
```bash
git log --oneline
# → 2 commits, 0 conflicts
# → git status: clean
```
✅ **Proof**: Khác file = không conflict dù "đồng thời"

---

## Test B: Conflict detection trên shared file

### Setup — Cả 2 agents cùng edit shared file (types/)

```bash
# Agent 1 (Claude) tạo branch
git checkout -b agent/claude/add-user-type

# Edit shared file
cat >> src/types/index.ts << 'EOF'
export interface User { id: string; email: string; }
EOF
git commit -am "feat(claude/types): add User interface"
```

```bash
# Agent 2 (Antigravity) tạo branch từ main (KHÔNG biết Claude đang edit)
git checkout main
git checkout -b agent/antigravity/add-user-type

# Edit cùng file, khác nội dung
cat >> src/types/index.ts << 'EOF'
export type UserRole = 'admin' | 'user' | 'guest';
EOF
git commit -am "feat(antigravity/types): add UserRole type"
```

### Merge test
```bash
git checkout main
git merge agent/claude/add-user-type      # OK
git merge agent/antigravity/add-user-type # → CONFLICT nếu cùng line
```

### Kết quả mong đợi
- Nếu edit khác vị trí trong file → auto merge ✅
- Nếu edit cùng line → conflict, cần resolve manually ⚠️

### Prevention (đúng cách nên làm)
Trước khi edit `src/types/index.ts`, ghi vào `tracklog/active.md`:
```
## LOCKED FILES
- src/types/index.ts → Claude Code (2026-03-29 09:00)
```
Antigravity thấy lock → làm task khác → không conflict.

---

## Test C: Branch strategy (gold standard)

```bash
# Claude làm feature auth trên branch riêng
git checkout -b agent/claude/auth-feature
# ... edit backend files ...
git commit -m "feat(claude/api): auth endpoints"

# Antigravity làm UI auth trên branch riêng
git checkout -b agent/antigravity/auth-ui
# ... edit frontend files ...
git commit -m "feat(antigravity/ui): auth forms"

# Merge cả 2 vào main
git checkout main
git merge agent/claude/auth-feature       # OK (backend only)
git merge agent/antigravity/auth-ui       # OK (frontend only)
git log --oneline --graph
```

Kết quả: clean merge history, zero conflicts (vì edit khác zone).

---

## Test D: Worktree isolation (Claude Code native)

```bash
# Tạo worktree riêng cho Antigravity
git worktree add ../project-antigravity agent/antigravity

# Claude làm trong thư mục gốc
cd /path/to/project
claude  # Claude Code session 1

# Antigravity làm trong worktree riêng
cd ../project-antigravity
# Antigravity session chạy ở đây — filesystem hoàn toàn isolated
```

Đây là **cách isolate mạnh nhất** — 2 working directories riêng biệt, không thể đụng file nhau.

---

## Chạy nhanh Test A để verify ngay

```bash
cd /path/to/project
bash docs/testing/run-parallel-test.sh
```

---

## Kết luận

| Scenario | Có conflict không | Prevention |
|---------|-----------------|-----------|
| Edit khác file (khác zone) | ❌ Không | File ownership rules |
| Edit cùng file, khác vị trí | ❌ Thường không | Lock mechanism |
| Edit cùng file, cùng dòng | ✅ Có | Branch strategy |
| Worktree riêng | ❌ Không bao giờ | Git worktree |
