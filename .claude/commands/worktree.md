Quản lý git worktree cho parallel agent workflow.
Chỉ dùng khi có 2+ agents làm việc đồng thời (Claude + Antigravity).

---

## Auto-Detection (chạy khi không có subcommand)

Nếu user chạy `/worktree` không có subcommand, hoặc Claude phát hiện signal từ `SessionStart` hook:

1. Đọc `tracklog/active.md` → check `PARALLEL MODE`
2. Nếu `PARALLEL MODE: OFF`, kiểm tra:
   - `context/tasks.md` có chứa "Antigravity" không?
   - `context/input.md` có chứa "Antigravity", "song song", "parallel", "hai tool" không?
3. Nếu có signal → thông báo và hỏi:
   ```
   Tao thấy project này có vẻ cần 2 agents làm việc song song ([signal cụ thể]).
   Muốn tao bật Parallel Mode (git worktree) không?
   → Nhắn "có" hoặc "setup" là tao làm ngay.
   ```
4. Nếu user đồng ý → chạy `/worktree setup` tự động
5. Nếu không có signal → báo "Không thấy signal cần parallel mode. Nếu muốn bật thủ công: /worktree setup"

---

## /worktree setup

Khởi tạo worktree cho agent thứ 2.

1. Kiểm tra điều kiện:
   - git status phải clean (không có uncommitted changes)
   - Chưa có worktree nào (git worktree list)

2. Xác định tên project:
   ```bash
   PROJECT=$(basename $(pwd))
   WORKTREE_PATH="../${PROJECT}-antigravity"
   BRANCH="agent/antigravity"
   ```

3. Tạo branch + worktree:
   ```bash
   git branch agent/antigravity 2>/dev/null || true
   git worktree add "$WORKTREE_PATH" agent/antigravity
   ```

4. Update tracklog/active.md — thêm section:
   ```
   ## PARALLEL MODE: ON
   - Claude zone: [thư mục hiện tại] (branch: master/main)
   - Antigravity zone: [WORKTREE_PATH] (branch: agent/antigravity)
   - Sync: chạy /worktree sync để merge
   ```

5. Thông báo:
   ```
   ✅ Worktree setup xong!

   Claude làm việc tại: [current dir]
   Antigravity làm việc tại: [WORKTREE_PATH]

   Hướng dẫn cho Antigravity:
   - Mở [WORKTREE_PATH] trong tool của Antigravity
   - Làm việc bình thường, commit local
   - KHÔNG push trực tiếp

   Khi muốn sync: chạy /worktree sync
   Khi xong cả hai: chạy /worktree merge
   ```

---

## /worktree sync

Xem diff giữa 2 worktrees, không merge.

```bash
git diff master..agent/antigravity --stat
git log master..agent/antigravity --oneline
git log agent/antigravity..master --oneline
```

Báo cáo:
- Commits chỉ có ở Claude (master)
- Commits chỉ có ở Antigravity (agent/antigravity)
- Files overlap (cả 2 cùng edit)

---

## /worktree merge

Merge antigravity branch vào main sau khi cả 2 xong.

1. Kiểm tra clean state trên cả 2 branches
2. Preview merge:
   ```bash
   git merge --no-commit --no-ff agent/antigravity
   git diff --cached --stat
   git merge --abort
   ```
3. Hiển thị kết quả preview → hỏi user xác nhận
4. Sau khi confirm:
   ```bash
   git merge agent/antigravity -m "chore: merge antigravity work"
   ```
5. Nếu conflict → list files conflict, hướng dẫn resolve

---

## /worktree teardown

Xóa worktree sau khi không cần parallel mode nữa.

1. Kiểm tra không có uncommitted changes trong worktree
2. Nếu chưa merge → cảnh báo + hỏi confirm
3. Xóa:
   ```bash
   git worktree remove "../${PROJECT}-antigravity" --force
   git branch -d agent/antigravity
   ```
4. Update tracklog/active.md: xóa section PARALLEL MODE
5. Thông báo: "Parallel mode OFF. Trở về single-agent workflow."

---

## Lưu ý

- Worktree dùng cùng .git repo → commit của agent nào cũng visible cho agent kia
- KHÔNG chạy 2 git operations cùng lúc trên cùng repo (git có internal locks)
- Mỗi worktree nên làm việc trên branch riêng
