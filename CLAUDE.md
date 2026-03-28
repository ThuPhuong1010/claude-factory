# AI SDLC Factory

## Commands
npm run dev | npm test | npm run lint | npm run build

## Architecture
Next.js 15 App Router + Ant Design 5.x + TypeScript + Zustand + TanStack Query.
UI: Ant Design components only. No custom UI libs.
Structure: src/{app,components,hooks,lib,services,stores,types}

## Workflow
1. Read context/tasks.md → find next TODO task
2. Read tracklog/active.md → know current state
3. Read memory/bugs.md → avoid known issues
4. Code → Test → Fix → Commit → Update task status
5. After session: update tracklog/active.md

## Rules (auto-loaded from .claude/rules/)
- TypeScript strict. No `any`.
- Max 300 lines/file, 50 lines/function
- Ant Design components for ALL UI. No custom replacements.
- Validate client (Form rules) + server (Zod)
- Every async has try-catch. No empty catches.
- No console.log in production. No hardcoded secrets.
- Test every feature. Coverage > 70%.
- Commit: type(scope): description

## Decision Making
- After plan is approved: NO asking user. Self-decide everything.
- Uncertain? Pick common option, log in context/decisions.md
- Need external tool/API? RAISE in docs/reports/integration-needs.md
- Bug won't fix after 3 tries? Log [NEEDS_HUMAN], move to next task.

## Skills
Available in .claude/skills/. Auto-triggered by context.
Read SKILL.md first, then references/ only if needed.

## Memory (Continuous Learning)
- New bug? Append to memory/bugs.md with: symptom + cause + fix + prevention
- Found error pattern? Append to memory/errors.md
- Good pattern? Append to memory/patterns.md
- READ memory/ BEFORE coding to avoid repeating mistakes
