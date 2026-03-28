---
name: document-generation
description: "Tạo file Word (.docx), PDF từ template hoặc data. Trigger khi output là document, report dạng file."
---

# Document Generation

## Word (.docx)

### Node.js — docxtemplater (template-based, recommended)
```bash
npm install docxtemplater pizzip
```
```js
const PizZip = require('pizzip');
const Docxtemplater = require('docxtemplater');
const fs = require('fs');

const content = fs.readFileSync('template.docx', 'binary');
const zip = new PizZip(content);
const doc = new Docxtemplater(zip, { paragraphLoop: true });

doc.render({ name: 'Phuong', date: '2026-03-29', items: [...] });

const buf = doc.getZip().generate({ type: 'nodebuffer' });
fs.writeFileSync('output.docx', buf);
```
Template syntax trong .docx: `{name}`, `{#items}{item}{/items}`

### Python — python-docx (tạo từ code)
```bash
pip install python-docx
```
```python
from docx import Document
from docx.shared import Pt, Inches

doc = Document()
doc.add_heading('Báo cáo', 0)
doc.add_paragraph('Nội dung...')

table = doc.add_table(rows=1, cols=3)
table.style = 'Table Grid'
hdr = table.rows[0].cells
hdr[0].text = 'STT'

doc.save('output.docx')
```

---

## PDF

### Node.js — Puppeteer (HTML → PDF, best quality)
```bash
npm install puppeteer
```
```js
const puppeteer = require('puppeteer');

const browser = await puppeteer.launch();
const page = await browser.newPage();
await page.setContent('<html>...</html>');
await page.pdf({ path: 'output.pdf', format: 'A4', printBackground: true });
await browser.close();
```

### Node.js — PDFKit (programmatic, no HTML)
```bash
npm install pdfkit
```
```js
const PDFDocument = require('pdfkit');
const fs = require('fs');

const doc = new PDFDocument();
doc.pipe(fs.createWriteStream('output.pdf'));
doc.fontSize(25).text('Title', 100, 80);
doc.end();
```

### Python — ReportLab (programmatic)
```bash
pip install reportlab
```
```python
from reportlab.pdfgen import canvas
c = canvas.Canvas("output.pdf")
c.drawString(100, 750, "Hello!")
c.save()
```

### Python — WeasyPrint (HTML/CSS → PDF)
```bash
pip install weasyprint
```
```python
from weasyprint import HTML
HTML(string='<h1>Report</h1>').write_pdf('output.pdf')
```

---

## Khi nào dùng gì
| Case | Tool |
|------|------|
| Word từ template có sẵn | docxtemplater (Node) |
| Word từ code | python-docx |
| PDF đẹp từ HTML | Puppeteer |
| PDF đơn giản | PDFKit / ReportLab |
| PDF từ HTML+CSS phức tạp | WeasyPrint |
