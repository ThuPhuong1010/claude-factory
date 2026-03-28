Xem commits chưa push và đẩy lên remote sau khi user xác nhận.

1. Kiểm tra trạng thái:
   git status --short
   git log origin/$(git branch --show-current)..HEAD --oneline 2>/dev/null || git log --oneline -10

2. Hiển thị rõ ràng cho user:
   ```
   📦 [N] commits chưa push lên remote:
   - abc1234 feat(scope): ...
   - def5678 fix(scope): ...

   Remote: origin/[branch]
   Push không?
   ```

3. DỪNG. Chờ user confirm ("yes", "đẩy đi", "push đi", ...).

4. Sau khi user confirm → push:
   git push origin $(git branch --show-current)

5. Báo kết quả + link repo.

NOTE: Command này chỉ được gọi khi user chủ động chạy /push hoặc
nói rõ "push đi". KHÔNG tự gọi trong /build hay /handoff.
