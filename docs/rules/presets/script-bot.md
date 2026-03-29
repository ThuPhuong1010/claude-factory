# Preset: Script / Bot

Load khi solution type = Script, Bot (Telegram, Discord, Slack), Data processor, Scheduled job.

## Stack gợi ý

| Use case | Stack |
|---------|-------|
| Data processing, automation | Python |
| Telegram bot | Python + python-telegram-bot |
| Discord bot | Python + discord.py hoặc JS + discord.js |
| Slack bot | Python + slack-bolt hoặc JS + bolt |
| File processing, CLI utility | Python hoặc Node.js |
| Cron job / scheduled task | Python + APScheduler hoặc Node + node-cron |

## Structure

```
src/
├── main.py / index.ts   # Entry point
├── handlers/            # Command / event handlers
├── services/            # Business logic, external API calls
├── utils/               # Helpers
└── config.py / config.ts # Config từ env vars

config/
└── .env.example         # Tất cả env vars cần thiết

docs/
└── setup.md             # Hướng dẫn setup bot credentials
```

## Rules

**Config:**
- Mọi token/key qua env vars — không hardcode
- Validate env vars khi startup: `if not os.getenv('BOT_TOKEN'): raise ValueError(...)`
- `.env.example` liệt kê đầy đủ mọi var cần thiết

**Bot patterns:**
```python
# Telegram bot handler
async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    try:
        result = await process(update.message.text)
        await update.message.reply_text(result)
    except Exception as e:
        logger.error(f"[BotHandler] {e}")
        await update.message.reply_text("Đã có lỗi. Thử lại sau.")
    # Không để crash bot vì 1 user gặp lỗi
```

**Idempotency (cho data processing):**
- Track processed IDs để tránh xử lý duplicate
- Dùng checkpoint file hoặc DB nếu job dài

**Logging:**
- Structured logs: `logger.info("[Module] action", extra={"user_id": uid})`
- Không log message content của user (privacy)
- Log đủ để debug: timestamp + user_id + action + result

## Testing

- Unit test handlers với mock update objects
- Integration test với bot API sandbox nếu platform hỗ trợ
- Manual test script: docs/testing/manual-test-script.md

## Deployment

- Bot thường chạy liên tục → cần process manager (PM2, systemd, Docker)
- Healthcheck: log heartbeat mỗi X phút
- Restart policy: auto-restart on crash
- Ghi deployment steps vào docs/guides/how-to-run.md
