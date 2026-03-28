# Preset: Automation / Workflow

Load khi solution type = Automation, Workflow, Process Design, Integration, Bot.

## Types thuộc preset này
- Workflow tự động (n8n, Zapier, Make, custom)
- Scheduled jobs / cron tasks
- Event-driven pipelines
- Process documentation + automation
- Integration giữa các services

## Design Principles
- Idempotent: chạy nhiều lần = kết quả giống nhau
- Fail-safe: lỗi không làm hỏng data
- Observable: log đủ để debug khi lỗi
- Resumable: nếu dừng giữa chừng, có thể tiếp tục

## Structure
```
workflows/
├── README.md        # Mô tả tổng thể
├── triggers/        # Event triggers / schedules
├── steps/           # Individual steps
├── handlers/        # Error handlers
└── config/          # Environment config
docs/testing/
├── test-scenarios.md   # Manual test cases
└── dry-run-guide.md    # Hướng dẫn dry-run
```

## Testing Workflows (không chạy được trực tiếp)
Tạo docs/testing/test-scenarios.md với:
```
## Scenario 1: Happy path
- Input: ...
- Expected: ...
- Verify bằng: ...

## Scenario 2: Error case
- Input: ...
- Expected behavior: ...
- Check log tại: ...
```

## Nếu workflow dùng external services
- RAISE trong docs/reports/integration-needs.md
- Dùng mock/stub trong testing
- Ghi environment variables cần thiết vào .env.example
