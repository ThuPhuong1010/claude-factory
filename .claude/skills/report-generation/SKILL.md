---
name: report-generation
description: "Tạo báo cáo hoàn chỉnh: kết hợp data + chart + document output (docx/pdf/pptx). Trigger khi cần export report, tài liệu dự án, business report."
---

# Report Generation

## Khi nào cần đọc skill này
- Cần tạo báo cáo hoàn chỉnh có cả text + bảng + biểu đồ
- Output là file cho người dùng tải về (docx, pdf, pptx)
- Cần tạo tài liệu dự án tự động từ data
- Kết hợp nhiều loại nội dung: Mermaid diagram + data chart + bảng

---

## Phân tích — Chọn Output Format

| Người nhận | Format | Lý do |
|-----------|--------|-------|
| Ban lãnh đạo / Business | `.docx` hoặc `.pdf` | Quen thuộc, in được |
| Khách hàng cần edit | `.docx` | Họ có thể chỉnh sửa tiếp |
| Khách hàng không cần edit | `.pdf` | Layout cố định, chuyên nghiệp hơn |
| Dev / technical team | `.pdf` (Marp) hoặc `.md` | Nhanh, version control được |
| Presentation / demo | `.pptx` hoặc Marp HTML | Slide deck |
| Dashboard web | HTML + Recharts | Interactive, không cần tải |

**Câu hỏi chốt format:**
```
Người nhận có cần edit không?   → Có: .docx / Không: .pdf
Có cần trình bày dạng slide?    → .pptx hoặc Marp
Stack project là gì?             → Python: python-docx/Matplotlib / Node: Puppeteer/PptxGenJS
```

---

## Design — Report Generation Pipeline

```
Data Source (DB / CSV / API)
        ↓
  [1] Collect & Transform data
        ↓
  [2] Generate charts → save PNG
      - Diagram/flow   → Mermaid CLI → PNG
      - Data chart     → Matplotlib / Plotly → PNG
        ↓
  [3] Assemble document
      - Template fill   → docxtemplater / python-docx
      - Layout render   → Puppeteer (HTML → PDF)
      - Slide build     → python-pptx / Marp
        ↓
  [4] Cleanup temp files
        ↓
  [5] Return / save output file
```

---

## Design — Python: Word Report với Charts

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from docx import Document
from docx.shared import Inches
import tempfile, os

def generate_report(data: dict, output_path: str):
    tmp_files = []

    # Step 1: Generate data chart
    chart_path = _make_bar_chart(data['revenue_by_quarter'])
    tmp_files.append(chart_path)

    # Step 2: Generate Mermaid diagram (via API, không cần install)
    diagram_path = _make_mermaid_png(data['flow_diagram'])
    tmp_files.append(diagram_path)

    # Step 3: Assemble Word document
    doc = Document()
    doc.add_heading(data['title'], level=0)
    doc.add_paragraph(data['summary'])

    doc.add_heading('Biểu đồ doanh thu', level=1)
    doc.add_picture(chart_path, width=Inches(5.5))

    doc.add_heading('Quy trình xử lý', level=1)
    doc.add_picture(diagram_path, width=Inches(5.5))

    _add_table(doc, data['items'])

    doc.save(output_path)

    # Step 4: Cleanup
    for f in tmp_files:
        os.remove(f)


def _make_bar_chart(data: list[dict]) -> str:
    """Generate bar chart → save temp PNG → return path"""
    fig, ax = plt.subplots(figsize=(8, 4))
    ax.bar([d['label'] for d in data], [d['value'] for d in data], color='#1677ff')
    ax.set_title('Doanh thu theo quý')
    ax.set_ylabel('Triệu đồng')
    plt.tight_layout()

    path = tempfile.mktemp(suffix='.png')
    plt.savefig(path, dpi=150, bbox_inches='tight')
    plt.close()
    return path


def _make_mermaid_png(diagram_code: str) -> str:
    """Render Mermaid via mermaid.ink API → save temp PNG"""
    import base64, httpx

    encoded = base64.urlsafe_b64encode(diagram_code.encode()).decode()
    resp = httpx.get(f"https://mermaid.ink/img/{encoded}?bgColor=white", timeout=15)
    resp.raise_for_status()

    path = tempfile.mktemp(suffix='.png')
    with open(path, 'wb') as f:
        f.write(resp.content)
    return path


def _add_table(doc: Document, items: list[dict]):
    table = doc.add_table(rows=1, cols=3)
    table.style = 'Table Grid'
    hdr = table.rows[0].cells
    hdr[0].text, hdr[1].text, hdr[2].text = 'Sản phẩm', 'Số lượng', 'Doanh thu'
    for item in items:
        row = table.add_row().cells
        row[0].text, row[1].text, row[2].text = item['name'], str(item['qty']), item['total']
```

---

## Design — Node.js: PDF Report (Puppeteer + Charts)

```typescript
import puppeteer from 'puppeteer'
import { ChartJSNodeCanvas } from 'chartjs-node-canvas'
import fs from 'fs'

async function generatePDFReport(data: ReportData, outputPath: string) {
  // Step 1: Generate chart as base64
  const chartBase64 = await generateChartBase64(data.chartData)

  // Step 2: Render Mermaid via API
  const diagramBase64 = await fetchMermaidBase64(data.flowDiagram)

  // Step 3: Build HTML template
  const html = buildReportHTML({ ...data, chartBase64, diagramBase64 })

  // Step 4: Export to PDF
  const browser = await puppeteer.launch({ headless: 'new' })
  const page = await browser.newPage()
  await page.setContent(html, { waitUntil: 'networkidle0' })
  await page.pdf({
    path: outputPath,
    format: 'A4',
    printBackground: true,
    margin: { top: '20mm', right: '15mm', bottom: '20mm', left: '15mm' }
  })
  await browser.close()
}

async function generateChartBase64(chartData: unknown): Promise<string> {
  const canvas = new ChartJSNodeCanvas({ width: 800, height: 400 })
  const buffer = await canvas.renderToBuffer({
    type: 'bar',
    data: chartData,
    options: { plugins: { legend: { position: 'top' } } }
  })
  return buffer.toString('base64')
}

async function fetchMermaidBase64(diagram: string): Promise<string> {
  const encoded = Buffer.from(diagram).toString('base64url')
  const res = await fetch(`https://mermaid.ink/img/${encoded}?bgColor=white`)
  const buf = await res.arrayBuffer()
  return Buffer.from(buf).toString('base64')
}
```

---

## Implementation Rules

- Luôn dùng `tempfile.mktemp()` (Python) hoặc `os.tmpdir()` (Node) cho file trung gian.
- Cleanup temp files trong `finally` block — không để lại dù bị lỗi.
- Mermaid API (`mermaid.ink`) có rate limit nhẹ — cho production: cài `@mermaid-js/mermaid-cli` local.
- Chart DPI: 150 cho document nhúng, 300 nếu in chất lượng cao.
- Tên file output: `{type}_{YYYY-MM-DD}_{id}.pdf` để tránh ghi đè.

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| Nhúng chart trực tiếp không qua file trung gian | Generate PNG → embed PNG |
| Không cleanup temp files | Delete trong `finally` block |
| Mermaid API không có timeout | Luôn set timeout (15s) |
| Matplotlib không set backend | `matplotlib.use('Agg')` trước import pyplot |
| Output file tên cố định | Thêm timestamp/id vào tên |
| Xử lý mọi thứ trong 1 function | Tách _make_chart, _make_diagram, _assemble_doc |

## Xem thêm
- `data-visualization` — Mermaid, Matplotlib, Plotly chi tiết
- `document-generation` — Word/PDF patterns chi tiết
- `presentations` — PPTX/Marp chi tiết
