#!/usr/bin/env python3
"""Convert any document to Markdown using MarkItDown.
Supports: .docx .xlsx .pptx .pdf .html .csv .jpg .png and more.

Usage: python ingest.py <file> [--out context/output.md]
Requires: pip install markitdown[all]

For highest quality .docx conversion, use Pandoc instead:
  pandoc input.docx -t markdown --extract-media=context/assets -o context/output.md
"""
import sys
import argparse
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description='Convert document to Markdown')
    parser.add_argument('file', help='Input file path')
    parser.add_argument('--out', help='Output path (default: context/<name>.md)')
    args = parser.parse_args()

    src = Path(args.file)
    if not src.exists():
        print(f"Error: {src} not found"); sys.exit(1)

    try:
        from markitdown import MarkItDown
    except ImportError:
        print("Error: markitdown not installed.")
        print("Run: pip install markitdown[all]")
        sys.exit(1)

    out_path = Path(args.out) if args.out else Path('context') / f'{src.stem}.md'
    out_path.parent.mkdir(parents=True, exist_ok=True)

    print(f"Converting {src.name}...")
    md = MarkItDown()
    result = md.convert(str(src))

    out_path.write_text(result.text_content, encoding='utf-8')
    print(f"✓ Saved: {out_path}")
    print(f"  Add to context/input.md: \"- {out_path}\"")


if __name__ == '__main__':
    main()
