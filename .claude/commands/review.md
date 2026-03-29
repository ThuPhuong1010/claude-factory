Code review on all changed files since last commit on main.

1. Đọc context/techstack.md → xác định solution type
2. git diff main --name-only → list changed files
3. Per file, check:
   CORRECTNESS: logic correct, edge cases, error handling
   QUALITY: no duplication, file<300 lines, naming conventions
   SECURITY: no secrets, input validated, auth checks
   UI (nếu có UI files): run UI Checklist bên dưới theo solution type
4. Auto-fix: low severity issues
5. Report: medium/high severity findings
6. MEMORY: nếu phát hiện recurring error pattern → append to memory/errors.md

---

## UI Checklist (chọn theo solution type)

### Web App (.tsx files — Ant Design)
- [ ] Ant Design components (no custom replacements)
- [ ] Layout uses Ant Layout + Grid
- [ ] Loading state (Skeleton or Spin)
- [ ] Empty state (Empty + CTA button)
- [ ] Error state (Result + retry button)
- [ ] Responsive: mobile (xs), tablet (md), desktop (lg)
- [ ] Colors use Ant tokens (no hardcoded hex)
- [ ] Typography uses Ant Typography
- [ ] Icons from @ant-design/icons
- [ ] Form validation displays correctly
- [ ] Table has pagination
- [ ] Modal confirm for destructive actions
- [ ] Accessible: labels, alt text, keyboard nav

### Desktop App (Electron/Tauri)
- [ ] Window close/minimize/maximize handlers
- [ ] Native menu wired up (File, Edit, Help)
- [ ] System tray behavior correct (nếu có)
- [ ] Crash on IPC errors handled gracefully
- [ ] Auto-updater logic present (nếu applicable)
- [ ] File dialogs use native OS dialogs

### Mobile App (React Native/Expo)
- [ ] SafeAreaView wraps root layout
- [ ] Keyboard avoidance on form screens
- [ ] Loading states on async actions
- [ ] Platform-specific styles (iOS vs Android) handled
- [ ] Back button behavior (Android) correct
- [ ] Network error states shown to user

### CLI / Script
- [ ] --help output đầy đủ và rõ ràng
- [ ] --dry-run flag có cho destructive operations
- [ ] Exit codes đúng (0 = success, 1 = error, 2 = usage)
- [ ] Errors ra stderr, output ra stdout
- [ ] Progress indication cho long-running operations
- [ ] No color codes khi output không phải TTY

### Extension (VSCode / Browser)
- [ ] Minimal permissions requested
- [ ] Cleanup khi deactivate/uninstall
- [ ] Settings load/save correctly
- [ ] No injected scripts beyond what's declared in manifest
- [ ] Error handling khi extension context invalidated

### API / Service
- [ ] Tất cả endpoints có validation (Zod hoặc tương đương)
- [ ] Authentication check trước khi xử lý request
- [ ] Rate limiting logic present (nếu public-facing)
- [ ] Consistent error response format
- [ ] Health check endpoint exists

### Automation / Workflow
- [ ] Idempotent — chạy nhiều lần = cùng kết quả
- [ ] Error path có rollback hoặc notification
- [ ] Logs đủ để debug khi fail
- [ ] Không hardcode credentials trong workflow
- [ ] Dry-run mode hoạt động (nếu applicable)
