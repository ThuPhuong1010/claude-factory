Rebuild context awareness từ code hiện tại. Chạy khi bắt đầu session mới hoặc context files bị stale.

1. Đọc tracklog/active.md → state hiện tại + parallel mode
2. Đọc tracklog/handoff.md → nếu có nội dung: absorb → xóa nội dung (giữ header)
3. Đọc context/tasks.md → tính done/total, tìm task IN_PROGRESS còn dở
4. Đọc memory/bugs.md → scan headings, đếm bugs chưa FIXED
5. Đọc context/techstack.md → stack + testing tier
6. Cập nhật tracklog/active.md:
   - Updated: [today]
   - NOW: task đang IN_PROGRESS (hoặc "Không có — sẵn sàng nhận task mới")
   - PROGRESS: Done/Total count
7. Output sync report:

```
SYNC COMPLETE
─────────────────────────────
Tasks    : {done}/{total} | In progress: {task ID nếu có}
Stack    : {từ techstack.md}
Tier     : {testing tier}
Bugs     : {N} open

{Nếu có handoff}: Absorbed handoff note từ session trước:
  → {tóm tắt 1-2 điểm chính từ handoff}

Ready. Gõ /build để tiếp tục hoặc /status để xem chi tiết.
```
