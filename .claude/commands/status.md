Quick project status dashboard. Dùng để check tiến độ bất kỳ lúc nào.

1. Đọc context/tasks.md → đếm task theo status
2. Đọc versions/current.md → version hiện tại
3. Đọc tracklog/active.md → session state + parallel mode
4. Đọc memory/bugs.md → đếm bugs chưa fix (không có status FIXED)

Output format cố định:

```
═══════════════════════════════
 PROJECT STATUS
═══════════════════════════════
Version  : v{X.Y.Z}
Mode     : Single Agent / PARALLEL MODE ON

Tasks    : {DONE}/{TOTAL} done  ({IN_PROGRESS} in progress, {BLOCKED} blocked)
  MVP    : {done}/{total} v0.1.0 tasks
  Next   : {task ID + title của task TODO tiếp theo không bị block}

Bugs     : {N} open / {M} total in memory/bugs.md

Last     : {task cuối đã DONE}
Session  : {Updated date từ tracklog/active.md}
═══════════════════════════════
→ Tiếp theo: /build để tiếp tục | /handoff để kết thúc session
```
