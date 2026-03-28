Phân tích ý tưởng trong context/input.md → tạo đầy đủ context để build.

1. Đọc context/input.md — hiểu ý tưởng
2. Xác định Solution Type:
   Web App | CLI Tool | Automation/Workflow | VSCode Extension |
   Browser Extension | Script/Bot | Process Design | API/Service |
   Desktop App | Documentation System | Other
3. Đề xuất Tech Stack phù hợp + giải thích lý do → ghi context/techstack.md
4. Load rules:
   - docs/rules/universal.md (luôn đọc)
   - docs/rules/presets/{type}.md (theo solution type)
5. Xác định Testing Tier (1-4) từ docs/rules/testing-strategy.md → ghi vào context/techstack.md
6. Tạo context/prd.md từ templates/prd.md
7. Tạo context/architecture.md — cấu trúc solution + mermaid diagram
8. Tạo context/tasks.md — task list:
   - ID (TASK-001), Title, Description
   - Acceptance Criteria
   - Dependencies [TASK-XXX]
   - Effort: S/M/L | Status: TODO | Version: v0.1.0
9. Nếu cần external service → RAISE vào docs/reports/integration-needs.md
10. Tạo versions/v0.1.0.md + versions/current.md
11. Tóm tắt: solution type, stack, testing tier, số tasks

IMPORTANT: MVP = nhỏ nhất có thể verify được ý tưởng. Defer nice-to-haves sang v0.2.0+.
