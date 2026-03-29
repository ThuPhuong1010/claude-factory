# Claude Factory

## Mission
Hiện thực hóa bất kỳ ý tưởng nào — web app, CLI tool, automation workflow, extension, script, process design, hay bất cứ thứ gì khác. Tech stack được chọn theo solution, không phải ngược lại.

## Commands
Xác định sau khi biết tech stack. Mặc định: xem context/techstack.md.

## Workflow
1. Read tracklog/active.md → know current state + check PARALLEL MODE
2. Read context/tasks.md → find next TODO task
3. Read memory/bugs.md → avoid known issues
4. Build → Test → Fix → Commit → Update task status
5. After session: update tracklog/active.md

## Parallel Mode Auto-Detection (chạy mỗi session start)
Sau khi đọc tracklog/active.md, kiểm tra các signals sau:
- PARALLEL MODE đang là gì (ON/OFF)?
- context/tasks.md có task nào gán cho Antigravity không?
- context/input.md có đề cập "Antigravity", "song song", "parallel", "hai tool" không?
- User có nhắc đến việc dùng tool AI khác không?

**Nếu phát hiện signal VÀ PARALLEL MODE: OFF:**
→ Chủ động thông báo ngay (không chờ user hỏi):
"Tao thấy project này có vẻ cần 2 agents làm việc song song ([signal cụ thể]).
Muốn tao bật Parallel Mode (git worktree) không? Chạy /worktree setup là xong."

**Không cần thông báo nếu:**
- PARALLEL MODE: ON (đã bật rồi)
- Không có signal nào
- Project chỉ có 1 agent

## Solution Types
Web App | CLI Tool | Automation/Workflow | VSCode Extension | Browser Extension | Script/Bot | Process Design | Documentation System | API/Service | Desktop App | Mobile App | Other

Tech stack, architecture, testing approach → xác định trong /analyze dựa trên solution type.

## Git Rules (BẮT BUỘC)
- `git commit` local → tự động, không hỏi
- `git push` remote → KHÔNG BAO GIỜ tự chạy. Phải hỏi user trước:
  "Tao có X commits chưa push. Push lên remote không?"
  Chỉ push sau khi user confirm trong conversation. Không push im lặng.
- Nếu không có lệnh push rõ ràng từ user → chỉ commit local, báo trạng thái

## Rules (universal — always apply)
- Max 300 lines/file, 50 lines/function
- Naming: rõ ràng, nhất quán trong codebase
- Every async has error handling. No empty catches.
- No hardcoded secrets. No debug output in production.
- Commit: type(scope): description

## Rules (conditional — load từ docs/rules/presets/ theo solution type)
- Web App → docs/rules/presets/web.md
- API / Service → docs/rules/presets/api-service.md
- CLI / Script → docs/rules/presets/cli.md
- Script / Bot → docs/rules/presets/script-bot.md
- Automation → docs/rules/presets/automation.md
- Extension → docs/rules/presets/extension.md
- Desktop App → docs/rules/presets/desktop-app.md
- Mobile App → docs/rules/presets/mobile-app.md
- AI/LLM App → docs/rules/presets/ai-app.md
- Process / Docs → docs/rules/presets/process-docs.md
- Precedence khi conflict: universal < preset < task-level instruction
- Git branching → docs/rules/git-branching.md

## Testing Approach
- Code có thể chạy → viết automated tests, coverage > 70%
- Code không thể chạy trực tiếp → tạo docs/testing/test-scenarios.md với manual test scripts
- Workflow/process → định nghĩa success criteria + dry-run checklist
- Xem docs/rules/testing-strategy.md để biết thêm

## Decision Making
- After plan is approved: NO asking user. Self-decide everything.
- Uncertain? Pick common option, log in context/decisions.md
- Need external tool/API? RAISE in docs/reports/integration-needs.md
- Bug won't fix after 3 tries? Log [NEEDS_HUMAN], move to next task.

## Skills
Available in .claude/skills/. Auto-triggered by context.
Read SKILL.md first, then references/ only if needed.

## Memory (Continuous Learning)
- New bug? Append to memory/bugs.md: symptom + cause + fix + prevention
- Found error pattern? Append to memory/errors.md
- Good pattern? Append to memory/patterns.md
- READ memory/ BEFORE coding to avoid repeating mistakes
