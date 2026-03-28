# Solution Types Catalog

Khi chạy /analyze, Claude sẽ xác định solution type dựa trên input.md và load preset rules tương ứng.

---

## Web App
**Khi nào:** Cần UI chạy trên browser, có user login, CRUD operations, dashboard.
**Preset:** docs/rules/presets/web.md
**Stack mặc định:** Next.js + TypeScript + Ant Design + Zustand
**Testing tier:** 1 (Jest + RTL)
**Output:** Deployable web application

---

## CLI Tool
**Khi nào:** Tool chạy trong terminal, nhận arguments, xử lý files, output text.
**Preset:** docs/rules/presets/cli.md
**Stack gợi ý:** Node.js/TypeScript (Commander.js) hoặc Python (Click)
**Testing tier:** 1-2
**Output:** Executable binary / npm package / pip package

---

## Automation / Workflow
**Khi nào:** Tự động hóa process lặp đi lặp lại, kết nối services, scheduled tasks.
**Preset:** docs/rules/presets/automation.md
**Stack gợi ý:** Tùy platform (n8n/Zapier flow, Python script, bash, Node.js cron)
**Testing tier:** 3 (test scenarios + dry-run)
**Output:** Workflow definition / automation script / runbook

---

## VSCode Extension
**Khi nào:** Thêm feature vào VSCode — commands, snippets, language support, sidebar.
**Preset:** docs/rules/presets/extension.md
**Stack:** TypeScript + vscode API
**Testing tier:** 2 (unit + manual checklist)
**Output:** .vsix package

---

## Browser Extension
**Khi nào:** Thêm feature vào Chrome/Firefox — modify pages, intercept requests, popup.
**Preset:** docs/rules/presets/extension.md
**Stack:** TypeScript + WebExtensions API
**Testing tier:** 2
**Output:** Extension zip / Chrome Web Store listing

---

## API / Service
**Khi nào:** Backend service, REST/GraphQL API, microservice, webhook handler.
**Stack gợi ý:** Node.js (Express/Fastify/Hono) hoặc Python (FastAPI) hoặc Go
**Testing tier:** 1 (unit + integration tests)
**Output:** Deployable service / Docker image

---

## Script / Bot
**Khi nào:** One-off script, data processing, Telegram/Discord bot, scraper.
**Stack gợi ý:** Python (requests, BeautifulSoup) hoặc Node.js
**Testing tier:** 1-2
**Output:** Runnable script

---

## Process Design / Documentation
**Khi nào:** Thiết kế quy trình làm việc, SOP, hướng dẫn, system design document.
**Stack:** Markdown / Mermaid diagrams
**Testing tier:** 4 (review checklist + walkthrough)
**Output:** Documentation files / runbook

---

## Desktop App
**Khi nào:** Native app chạy trên Windows/Mac/Linux, cần system access, offline-first.
**Stack gợi ý:** Electron + React hoặc Tauri + React hoặc Python (tkinter/PyQt)
**Testing tier:** 2
**Output:** Installable desktop application

---

## AI / LLM App
**Khi nào:** App tích hợp AI model — chatbot, copilot, RAG system, AI agent, AI feature trong app.
**Preset:** docs/rules/presets/ai-app.md
**Stack gợi ý:** Next.js + Vercel AI SDK + Anthropic/OpenAI SDK (web) | Python FastAPI + LangChain (API)
**Skills auto-load:** llm-integration, state-management, security
**Testing tier:** 2 (unit + manual eval)
**Output:** Deployable AI application
**Lưu ý:** RAISE API keys (ANTHROPIC_API_KEY / OPENAI_API_KEY) vào integration-needs.md ngay Phase 1

---

## Other
Nếu không khớp type nào, /analyze sẽ:
1. Mô tả solution type mới
2. Tự định nghĩa rules phù hợp
3. Ghi vào docs/rules/presets/custom.md
