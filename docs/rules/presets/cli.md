# Preset: CLI Tool / Script

Load khi solution type = CLI Tool, Script, Bot, Automation Script.

## Stack gợi ý
- Node.js + TypeScript (Commander.js / Yargs cho CLI)
- Python (Click / Typer cho CLI, requests/httpx cho HTTP)
- Shell script (bash/zsh cho automation đơn giản)
- Chọn theo: ngôn ngữ quen, dependencies cần, target OS

## Structure
```
src/
├── index.ts         # Entry point
├── commands/        # Sub-commands
├── utils/           # Utilities
└── types/           # TypeScript types
```

## Rules
- Entry point rõ ràng (bin field trong package.json nếu Node)
- --help flag hoạt động với đầy đủ thông tin
- --dry-run flag khi có destructive operations
- Exit codes: 0 = success, 1 = error, 2 = usage error
- Stderr cho errors/logs, stdout cho output thật
- Progress indication cho long-running operations

## Testing
- Unit test các functions chính
- Integration test: chạy actual commands với test inputs
- Nếu không tự chạy được: tạo docs/testing/manual-test-script.md
