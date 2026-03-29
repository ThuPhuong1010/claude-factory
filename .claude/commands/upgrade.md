Sync template improvements vào project đang dùng.
Dùng khi template ra version mới và muốn pull improvements về project hiện tại.

---

## Khi nào dùng /upgrade

- Template vừa ra version mới (xem CHANGELOG.md của template repo)
- Muốn sync một improvement cụ thể (skill mới, command mới, rule mới)
- Project bị stale so với template gốc

---

## Quy trình

### Bước 1 — Check current state

```bash
# Version template hiện tại của project
cat versions/current.md

# Version template mới nhất (nếu đã clone về thư mục riêng)
cat ../claude-factory/versions/current.md
```

Nếu user chưa có template repo local:
```
→ Tao cần mày clone template về để so sánh:
  git clone https://github.com/ThuPhuong1010/claude-factory ../claude-factory-latest
  Rồi chạy lại /upgrade
```

### Bước 2 — Identify what to sync

So sánh các thư mục template với project hiện tại:

| Thư mục | Sync strategy |
|---------|--------------|
| `.claude/commands/` | Merge từng file — **không overwrite** nếu project đã custom |
| `.claude/skills/` | Add skills mới; update skills cũ chỉ nếu project chưa custom |
| `.claude/rules/` | Add files mới; **không overwrite** |
| `docs/rules/` | Add files mới; **không overwrite** |
| `docs/rules/presets/` | Add presets mới; **không overwrite** |
| `templates/` | Add files mới; **không overwrite** |
| `CLAUDE.md` | **KHÔNG tự overwrite** — highlight diff, hỏi user |
| `AGENTS.md` | **KHÔNG tự overwrite** — highlight diff, hỏi user |
| `context/` | **KHÔNG bao giờ overwrite** — project data |
| `memory/` | **KHÔNG bao giờ overwrite** — project data |
| `tracklog/` | **KHÔNG bao giờ overwrite** — project data |

### Bước 3 — Report diff

Output dạng:

```
## Upgrade Report: v{current} → v{new}

### Có thể auto-add (không ảnh hưởng project):
- [+] .claude/skills/report-generation/SKILL.md (new skill)
- [+] docs/rules/presets/api-service.md (new preset)
- [+] .claude/commands/research.md (new command)

### Cần review trước khi merge:
- [~] .claude/commands/build.md (template updated — xem diff bên dưới)
- [~] CLAUDE.md (breaking changes — cần manual merge)

### Không sync (project đã custom):
- [=] context/tasks.md (project data — skip)
- [=] memory/bugs.md (project data — skip)

Diff cho files cần review:
[hiển thị diff cụ thể]
```

### Bước 4 — Apply (với confirm)

```
→ Auto-add [N] files mới? (Y/n)
→ Từng file cần review: apply / skip / manual-merge?
```

Sau khi apply:
- Cập nhật versions/current.md với version mới
- Commit: `chore(template): upgrade to v{version}`

### Bước 5 — Verify

Sau upgrade, check:
- [ ] CLAUDE.md vẫn load đúng (không bị overwrite)
- [ ] context/ không bị động đến
- [ ] memory/ không bị động đến
- [ ] Commands mới hoạt động: chạy thử `/status`

---

## Lưu ý quan trọng

- **KHÔNG auto-overwrite CLAUDE.md, AGENTS.md, context/, memory/, tracklog/**
- Chỉ add mới, không xóa — project có thể có custom additions
- Nếu conflict → show diff, hỏi user, không tự resolve
- Sau upgrade lớn → chạy `/review` để verify không có broken reference
