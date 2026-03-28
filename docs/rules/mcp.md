# MCP Rules

## Nguyên tắc
- KHÔNG setup MCP mặc định. Chỉ khi plan yêu cầu.
- Mỗi MCP server tốn context (~100-200 tokens/tool). Chỉ add cái thật sự cần.
- RAISE trong `docs/reports/integration-needs.md` trước khi yêu cầu setup.

## Khi nào cần MCP

| Tình huống | MCP Server | Command |
|------------|-----------|---------|
| Cần Figma design | figma | `claude mcp add figma` |
| Cần GitHub issues/PR | github | `claude mcp add --transport http github <url>` |
| Cần query database | postgres/supabase | `claude mcp add postgres` |
| Cần browser testing | playwright | `claude mcp add playwright` |
| Cần error monitoring | sentry | `claude mcp add sentry` |
| Cần project management | asana/jira | `claude mcp add asana` |
| Cần đọc Notion workspace | notion | `claude mcp add notion` |
| Cần đọc Google Docs/Drive | google-drive | `claude mcp add google-drive` |
| Cần đọc Confluence pages | confluence | `claude mcp add --transport http confluence <url>` |
| Cần Google Calendar | google-calendar | Built-in Claude.ai — không cần setup |

## Cách setup (chỉ khi đã RAISE và user approve)

```bash
# HTTP transport (remote servers — recommended)
claude mcp add --transport http <name> <url>

# Với auth token
claude mcp add --transport http <name> <url> \
  --header "Authorization: Bearer <token>"

# Stdio transport (local servers)
claude mcp add <name> -- npx -y <package-name>
```

## Security Rules
- API keys trong environment variables, KHÔNG hardcode
- Dùng env flag: `claude mcp add --env KEY=value`
- Review MCP server source trước khi install (untrusted risk)
- Read-only MCP trước, write access chỉ khi cần

## Context Cost
- Mỗi MCP server tool: ~100-200 tokens mô tả
- Claude Code v2.1+ có Tool Search: lazy load tools (giảm 95%)
- Vẫn nên giới hạn ≤ 3-5 MCP servers active

## Quy trình RAISE MCP

```
Agent đang code → phát hiện cần external service
    │
    ▼
Ghi vào docs/reports/integration-needs.md:
  | # | Service | Lý do | Method |
    │
    ▼
Agent tiếp tục code (dùng defaults/mock)
    │
    ▼
User thấy RAISE → approve → chạy setup command
    │
    ▼
Agent dùng MCP trong session tiếp
```

## Lưu ý CLAUDE.md
MCP config nằm trong `.claude/settings.json` hoặc thêm qua `claude mcp add`.
KHÔNG ghi MCP config vào CLAUDE.md (lãng phí context mỗi session).
