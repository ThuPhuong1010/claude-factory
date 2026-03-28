#!/usr/bin/env python3
"""Transcribe audio/video using OpenAI Whisper API.
Usage: python transcribe_audio.py <audio_file> [--lang vi]
Requires: pip install openai
Requires: OPENAI_API_KEY in .env or environment
Cost: ~$0.006/minute
"""
import sys
import os
import argparse
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description='Transcribe audio to Markdown')
    parser.add_argument('file', help='Audio file (.mp3 .wav .m4a .mp4 .webm)')
    parser.add_argument('--lang', default='vi', help='Language code (default: vi)')
    args = parser.parse_args()

    src = Path(args.file)
    if not src.exists():
        print(f"Error: {src} not found"); sys.exit(1)

    # Load .env nếu có
    env_file = Path('.env')
    if env_file.exists():
        for line in env_file.read_text().splitlines():
            if '=' in line and not line.startswith('#'):
                k, v = line.split('=', 1)
                os.environ.setdefault(k.strip(), v.strip().strip('"\''))

    api_key = os.getenv('OPENAI_API_KEY')
    if not api_key:
        print("Error: OPENAI_API_KEY not found in environment or .env")
        print("Alternatives (free):")
        print("  Windows: Whisper Desktop — https://github.com/Const-me/Whisper")
        print("  Mac:     MacWhisper      — https://goodsnooze.gumroad.com/l/macwhisper")
        sys.exit(1)

    print(f"Transcribing {src.name} (lang: {args.lang})...")

    from openai import OpenAI
    client = OpenAI(api_key=api_key)

    with open(src, 'rb') as f:
        transcript = client.audio.transcriptions.create(
            model='whisper-1',
            file=f,
            language=args.lang,
        )

    out_dir = Path('context')
    out_dir.mkdir(exist_ok=True)
    out = out_dir / f'transcript_{src.stem}.md'
    out.write_text(
        f'# Transcript: {src.name}\n\n{transcript.text}',
        encoding='utf-8'
    )
    print(f'✓ Saved: {out}')
    print(f'  Add to context/input.md: "- {out}"')


if __name__ == '__main__':
    main()
