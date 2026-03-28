# Git Branching Strategy

## Mặc định theo mode

| Mode | Branching rule |
|------|---------------|
| Solo project, 1 agent | Commit thẳng vào `main` — được phép |
| Solo project, 2+ agents (Parallel Mode ON) | Feature branches — **bắt buộc** |
| Team project | Feature branches — **bắt buộc** |

## Tên branch

```
feature/<task-id>-<short-desc>    # VD: feature/T-05-user-auth
fix/<bug-id>-<short-desc>          # VD: fix/BUG-03-login-redirect
chore/<desc>                       # VD: chore/update-deps
```

## Workflow (khi dùng feature branches)

```
main
 └─ feature/T-05-user-auth
     ├─ commit: feat(auth): add login form
     ├─ commit: feat(auth): add JWT validation
     └─ merge → main (squash merge)
```

1. Tạo branch từ main: `git checkout -b feature/<id>-<desc>`
2. Commit thường xuyên trên branch (không cần perfect)
3. Trước khi merge: chạy `/test` + `/review`
4. Merge vào main: squash merge để giữ history sạch
5. Xóa branch sau khi merge: `git branch -d feature/...`

## Commit squash khi merge

```bash
git checkout main
git merge --squash feature/<branch>
git commit -m "feat(scope): summary of feature"
```

## Không làm

- KHÔNG merge vào main nếu tests fail
- KHÔNG để branch sống quá 1 version (stale branch)
- KHÔNG force-push vào main (đã block trong settings.json)
- KHÔNG tạo branch từ branch khác (trừ hotfix khẩn cấp)

## Parallel Mode (2 agents)

Khi PARALLEL MODE: ON, mỗi agent làm việc trên branch riêng:
- Claude: `agent/claude-<feature>`
- Antigravity: `agent/antigravity-<feature>`
- Merge vào main sau khi cả 2 xong phần của mình
- Xem tracklog/active.md để biết ai đang làm branch nào
