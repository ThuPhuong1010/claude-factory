# Claude Factory

## Mission
Hiện thực hóa bất kỳ ý tưởng nào — web app, CLI tool, automation workflow, extension, script, process design, hay bất cứ thứ gì khác. Tech stack được chọn theo solution, không phải ngược lại.

## Commands
Xác định sau khi biết tech stack. Mặc định: xem context/techstack.md.

## Workflow
1. Read context/tasks.md → find next TODO task
2. Read tracklog/active.md → know current state
3. Read memory/bugs.md → avoid known issues
4. Build → Test → Fix → Commit → Update task status
5. After session: update tracklog/active.md

## Solution Types
Web App | CLI Tool | Automation/Workflow | VSCode Extension | Browser Extension | Script/Bot | Process Design | Documentation System | API/Service | Desktop App | Mobile App | Other

Tech stack, architecture, testing approach → xác định trong /analyze dựa trên solution type.

## Rules (universal — always apply)
- Max 300 lines/file, 50 lines/function
- Naming: rõ ràng, nhất quán trong codebase
- Every async has error handling. No empty catches.
- No hardcoded secrets. No debug output in production.
- Commit: type(scope): description

## Rules (conditional — load từ docs/rules/presets/ theo solution type)
- Web App → docs/rules/presets/web.md
- CLI/Script → docs/rules/presets/cli.md
- Automation → docs/rules/presets/automation.md
- Extension → docs/rules/presets/extension.md

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
