Code review on all changed files since last commit on main.

1. git diff main --name-only → list changed files
2. Per file, check:
   CORRECTNESS: logic correct, edge cases, error handling
   QUALITY: no duplication, file<300 lines, naming conventions
   SECURITY: no secrets, input validated, auth checks
   UI (if .tsx): run Design Checklist below
3. Auto-fix: low severity issues
4. Report: medium/high severity findings

## Design Checklist (for .tsx files)
- [ ] Ant Design components (no custom replacements)
- [ ] Layout uses Ant Layout + Grid
- [ ] Loading state (Skeleton or Spin)
- [ ] Empty state (Empty + CTA button)
- [ ] Error state (Result + retry button)
- [ ] Responsive: mobile (xs), tablet (md), desktop (lg)
- [ ] Colors use Ant tokens (no hardcoded hex)
- [ ] Spacing consistent (8px grid)
- [ ] Typography uses Ant Typography
- [ ] Icons from @ant-design/icons
- [ ] Dark mode doesn't crash (if enabled)
- [ ] Form validation displays correctly
- [ ] Table has pagination
- [ ] Modal confirm for destructive actions
- [ ] Accessible: labels, alt text, keyboard nav
