---
name: document-generation
description: "Tạo file Word (.docx), PDF từ template hoặc data. Trigger khi output là document, report dạng file."
---

# Document Generation

## Khi nào cần đọc skill này
- Output của feature là file Word hoặc PDF
- Cần export report, invoice, contract dạng document
- Cần nhúng chart/image vào document
- User cần tải file về

---

## Phân tích — Chọn Tool

| Tình huống | Tool | Stack |
|-----------|------|-------|
| Word từ template `.docx` có sẵn | **docxtemplater** | Node.js |
| Word tạo từ code (không có template) | **python-docx** | Python |
| PDF đẹp từ HTML/CSS | **Puppeteer** | Node.js |
| PDF đơn giản từ code | **PDFKit** / **ReportLab** | Node / Python |
| PDF từ HTML+CSS phức tạp | **WeasyPrint** | Python |
| Word + chart embed | **python-docx** + Matplotlib | Python |
| PDF + chart embed | Puppeteer (render HTML có chart) | Node.js |

**Quyết định nhanh:**
```
Có template Word sẵn?          → docxtemplater (fill data vào template)
Không có template?
  → Cần format tự do            → python-docx hoặc PDFKit
  → Cần pixel-perfect layout    → Puppeteer (design HTML → export PDF)
Cần nhúng chart?               → Generate chart ra PNG trước → embed
```

---

## Design — Word từ template (docxtemplater)

Workflow: tạo file `.docx` template trước (trong Word), dùng syntax `{variable}` làm placeholder.

```bash
npm install docxtemplater pizzip
```

```typescript
import PizZip from 'pizzip'
import Docxtemplater from 'docxtemplater'
import fs from 'fs'

function generateDocx(templatePath: string, data: Record<string, unknown>, outputPath: string) {
  const content = fs.readFileSync(templatePath, 'binary')
  const zip = new PizZip(content)
  const doc = new Docxtemplater(zip, { paragraphLoop: true, linebreaks: true })

  doc.render(data)

  const buf = doc.getZip().generate({ type: 'nodebuffer', compression: 'DEFLATE' })
  fs.writeFileSync(outputPath, buf)
}

// Dùng:
generateDocx('templates/report.docx', {
  title: 'Báo cáo tháng 3',
  date: '29/03/2026',
  items: [
    { name: 'Sản phẩm A', qty: 10, total: '1,000,000đ' },
    { name: 'Sản phẩm B', qty: 5,  total: '500,000đ' },
  ],
  grand_total: '1,500,000đ'
}, 'output/report.docx')
```

Template syntax trong `.docx`:
- `{variable}` — giá trị đơn
- `{#items}{name} - {total}{/items}` — loop array
- `{?condition}nội dung{/condition}` — conditional

---

## Design — Word từ code (python-docx)

```python
from docx import Document
from docx.shared import Pt, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH

doc = Document()

# Heading
heading = doc.add_heading('Báo cáo doanh thu', level=0)
heading.alignment = WD_ALIGN_PARAGRAPH.CENTER

# Paragraph
doc.add_paragraph('Kính gửi Ban Giám Đốc,')

# Table
table = doc.add_table(rows=1, cols=3)
table.style = 'Table Grid'
hdr = table.rows[0].cells
hdr[0].text = 'Sản phẩm'
hdr[1].text = 'Số lượng'
hdr[2].text = 'Doanh thu'

for item in items:
    row = table.add_row().cells
    row[0].text = item['name']
    row[1].text = str(item['qty'])
    row[2].text = item['total']

# Nhúng chart (generate trước, save ra PNG)
doc.add_picture('chart.png', width=Inches(5))

doc.save('output.docx')
```

---

## Design — PDF từ HTML (Puppeteer)

Tốt nhất khi cần layout phức tạp, styling CSS, chart nhúng.

```typescript
import puppeteer from 'puppeteer'

async function generatePDF(html: string, outputPath: string) {
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

// HTML template có thể dùng inline CSS, base64 image (chart)
const html = `
<html>
<head><style>
  body { font-family: 'Arial', sans-serif; }
  table { width: 100%; border-collapse: collapse; }
  th, td { border: 1px solid #ddd; padding: 8px; }
</style></head>
<body>
  <h1>Báo cáo tháng 3</h1>
  <img src="data:image/png;base64,${chartBase64}" width="500"/>
  ${tableHtml}
</body>
</html>`
```

---

## Implementation Rules

- Generate chart ra file PNG trước, sau đó embed — không inline SVG phức tạp.
- Puppeteer cần `waitUntil: 'networkidle0'` nếu HTML có font load từ CDN.
- docxtemplater: nếu template có image placeholder, cần plugin `docxtemplater-image-module`.
- Tên file output nên có timestamp để tránh ghi đè: `report_2026-03-29.pdf`.
- Dọn file tạm (chart PNG) sau khi embed xong.

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| Không có template → viết HTML thuần rồi export | Dùng docxtemplater nếu client cần `.docx` editable |
| Puppeteer không chờ font/image load | Thêm `waitUntil: 'networkidle0'` |
| Nhúng SVG phức tạp trực tiếp vào docx | Convert sang PNG trước (`matplotlib savefig`) |
| Không dọn file tạm | Delete PNG sau khi embed xong |
| File tên cố định bị ghi đè | Thêm timestamp vào tên output |
