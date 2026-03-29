When editing Python files (*.py):
- Type hints on all function signatures (PEP 484)
- Use dataclasses or Pydantic for structured data — not plain dicts
- Every async function has try-except. No bare except (catch specific exceptions)
- f-strings for formatting. No % or .format() style
- Use pathlib.Path for file paths — not os.path
- Secrets: os.getenv() only. Never hardcode
- Logging: use logging module, not print() in production
