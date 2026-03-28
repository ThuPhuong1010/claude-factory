---
name: context-ingestion
description: "Chuyển đổi file binary (Word, Excel, PowerPoint, PDF, ảnh) thành Markdown để Claude đọc được. Trigger khi user có context ở .docx .xlsx .pptx hoặc mention file không phải text/md."
---

# Context Ingestion

## Format Support

| Format | Claude đọc được? | Cách xử lý |
|--------|-----------------|-----------|
| `.md` `.txt` `.json` `.csv` | ✅ Native | Đọc trực tiếp |
| `.pdf` `.png` `.jpg` `.svg` | ✅ Native | Đọc trực tiếp (multimodal) |
| `.docx` `.xlsx` `.pptx` `.html` | ❌ Binary | Chạy script bên dưới |
| Audio/Video | ❌ | Xem hướng dẫn bên dưới |
| Figma / Notion / Google Docs | ❌ | Dùng MCP (xem docs/rules/mcp.md) |

## Convert nhanh — MarkItDown (1 lệnh xử lý tất cả)

```bash
# Install một lần
pip install markitdown[all]

# Convert bất kỳ file nào → context/<tên>.md
python .claude/skills/context-ingestion/scripts/ingest.py <path/to/file>
```

Hỗ trợ: `.docx` `.xlsx` `.pptx` `.pdf` `.html` `.csv` `.jpg` `.png` và nhiều hơn.

## Convert thủ công với Pandoc (chất lượng cao nhất cho .docx)

```bash
# Install Pandoc: https://pandoc.org/installing.html
pandoc input.docx -t markdown --extract-media=context/assets -o context/output.md
```

Pandoc xử lý tốt hơn MarkItDown với DOCX có bảng phức tạp, heading styles, footnotes.

## Audio / Video

**Có OPENAI_API_KEY** (~$0.006/phút):
```bash
pip install openai
python .claude/skills/context-ingestion/scripts/transcribe_audio.py recording.mp3
# Output: context/transcript_recording.md
```

**Không có API key (free):**
- Windows: [Whisper Desktop](https://github.com/Const-me/Whisper)
- Mac: [MacWhisper](https://goodsnooze.gumroad.com/l/macwhisper)
- Sau đó paste transcript vào `context/input.md`

## Sau khi convert
Thêm vào `context/input.md` section "Context Files":
```markdown
## Context Files
- context/spec.md  (converted từ spec.docx)
- context/data.md  (converted từ data.xlsx)
```
