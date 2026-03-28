---
name: python-scripting
description: "Python scripts, automation, data processing, bots. Trigger khi solution dùng Python hoặc cần scripting/automation nhanh."
---

# Python Scripting

## Project Structure
```
project/
├── main.py          # Entry point
├── src/
│   ├── __init__.py
│   ├── core.py
│   └── utils.py
├── tests/
├── requirements.txt
├── .env             # Secrets (gitignore)
└── README.md
```

## Environment Setup
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Config & Secrets
```bash
pip install python-dotenv
```
```python
from dotenv import load_dotenv
import os

load_dotenv()
API_KEY = os.getenv('API_KEY')
if not API_KEY:
    raise ValueError("API_KEY not set in .env")
```

## CLI với argparse
```python
import argparse

parser = argparse.ArgumentParser(description='Tool description')
parser.add_argument('input', help='Input file')
parser.add_argument('--output', '-o', default='output.txt')
parser.add_argument('--verbose', '-v', action='store_true')
parser.add_argument('--dry-run', action='store_true')

args = parser.parse_args()
```

## HTTP Requests
```bash
pip install httpx  # async-capable, recommended
```
```python
import httpx

# Sync
response = httpx.get('https://api.example.com/data', headers={'Authorization': f'Bearer {token}'})
data = response.json()

# Async
async with httpx.AsyncClient() as client:
    response = await client.post(url, json=payload)
```

## Error Handling Pattern
```python
import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
logger = logging.getLogger(__name__)

def run_task(input_data):
    try:
        result = process(input_data)
        logger.info(f"Success: {result}")
        return result
    except ValueError as e:
        logger.error(f"Invalid input: {e}")
        raise
    except Exception as e:
        logger.exception(f"Unexpected error: {e}")
        raise
```

## File I/O
```python
from pathlib import Path

# Read
content = Path('input.txt').read_text(encoding='utf-8')
data = json.loads(Path('data.json').read_text())

# Write
Path('output.txt').write_text(result, encoding='utf-8')
Path('output.json').write_text(json.dumps(data, ensure_ascii=False, indent=2))

# Iterate files
for file in Path('data/').glob('*.csv'):
    process(file)
```

## Common Packages
| Use case | Package |
|---------|---------|
| HTTP requests | httpx, requests |
| HTML scraping | beautifulsoup4, playwright |
| Data processing | pandas, polars |
| Excel | openpyxl, xlrd |
| PDF | pypdf2, pdfplumber, weasyprint |
| Word | python-docx |
| Scheduling | schedule, apscheduler |
| CLI | click, typer, argparse |
| Config | python-dotenv, pydantic-settings |
| Testing | pytest |
