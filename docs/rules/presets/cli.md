# Preset: CLI Tool / Script

Load khi solution type = CLI Tool, Script, Bot, Automation Script.

## Stack gợi ý

| Use case | Stack |
|---------|-------|
| General CLI | Node.js + TypeScript + Commander.js |
| Data processing, automation | Python + Click / Typer |
| System automation, glue scripts | Python hoặc bash/zsh |
| Performance-critical | Go + cobra |

## Structure

```
src/                     # Node.js
├── index.ts             # Entry point + CLI definition
├── commands/            # Sub-command handlers
├── services/            # Business logic (testable, không phụ thuộc CLI layer)
├── utils/               # Helpers (file, format, validate)
└── types/               # TypeScript types

src/ hoặc project root/  # Python
├── main.py / cli.py     # Entry + Click/Typer app
├── commands/            # Sub-commands
├── services/            # Business logic
└── utils/               # Helpers
```

## Error Handling

```typescript
// Node.js — wrap main với global handler
async function main() {
  try {
    await program.parseAsync(process.argv)
  } catch (err) {
    console.error(`Error: ${err.message}`)
    process.exit(1)
  }
}
```

```python
# Python Click — custom exception handler
@click.command()
@click.pass_context
def cmd(ctx, ...):
    try:
        do_work()
    except AppError as e:
        click.echo(f"Error: {e}", err=True)  # err=True → stderr
        ctx.exit(1)
    except Exception as e:
        click.echo(f"Unexpected error: {e}", err=True)
        ctx.exit(2)
```

## UX Rules

- `--help` đầy đủ: mô tả command, mọi option + default value, ví dụ usage
- `--dry-run` flag cho mọi operation destructive (xóa, ghi đè, gửi request)
- Progress indication cho operations > 1 giây (spinner hoặc progress bar)
- **Errors ra stderr** (`console.error` / `click.echo(err=True)`), output ra stdout
- Verbose mode `--verbose` / `-v` cho debug output — không bật mặc định
- Colorize output khi TTY, plain text khi piped (`process.stdout.isTTY`)

## Exit Codes

| Code | Nghĩa |
|------|-------|
| 0 | Success |
| 1 | Runtime error (file not found, API fail, ...) |
| 2 | Usage error (wrong args, missing required flags) |

## Config File (nếu cần persist settings)

- Location: `~/.config/<toolname>/config.json` (Linux/Mac) hoặc `%APPDATA%\<toolname>\config.json` (Windows)
- Dùng `os.path.expanduser` / `os.environ` để resolve cross-platform
- `.env` cho credentials — không lưu vào config file

## Testing

```bash
# Node.js
npm test              # Jest unit tests
node dist/index.js --help   # Manual smoke test

# Python
pytest tests/         # Unit tests
python -m cli --help  # Manual smoke test
```

- Unit test service layer (pure functions, dễ test nhất)
- Integration test: chạy actual commands với test inputs + assert stdout/stderr + exit code
- Nếu không tự chạy được trong CI: tạo `docs/testing/manual-test-script.md`

## Distribution

```bash
# Node.js — npm package
"bin": { "toolname": "dist/index.js" }  # package.json
npm publish

# Python — pip package
pyproject.toml với [project.scripts]
pip install -e .      # local install để test
```
