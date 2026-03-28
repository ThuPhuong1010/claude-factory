Phân tích yêu cầu phần mềm và tạo plan đầy đủ.

Steps:
1. Read context/input.md
2. Scan docs/rules/ headings (deep-read only relevant ones)
3. Create context/prd.md — full PRD with acceptance criteria per feature
4. Create context/techstack.md — justify each technology choice
5. Create context/architecture.md — module boundaries + mermaid diagram
6. Create context/tasks.md — task breakdown with:
   - ID (TASK-001), Title, Description
   - Acceptance Criteria
   - Dependencies [TASK-XXX]
   - Effort: S/M/L
   - Status: TODO
   - Version: v0.1.0
7. If needs external service → write docs/reports/integration-needs.md
8. Create versions/v0.1.0.md + versions/current.md
9. Print summary for user review

IMPORTANT: Group tasks into v0.1.0 (MVP — smallest viable scope).
Defer nice-to-haves to v0.2.0+.
