---
name: presentations
description: "Tạo slide PowerPoint (.pptx) hoặc web-based presentation. Trigger khi output là slides, deck, presentation."
---

# Presentation Generation

## PowerPoint (.pptx)

### Python — python-pptx (recommended)
```bash
pip install python-pptx
```
```python
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor

prs = Presentation()

# Slide 1: Title
slide = prs.slides.add_slide(prs.slide_layouts[0])
slide.shapes.title.text = "Tên Presentation"
slide.placeholders[1].text = "Subtitle"

# Slide 2: Content
slide = prs.slides.add_slide(prs.slide_layouts[1])
slide.shapes.title.text = "Section Title"
tf = slide.placeholders[1].text_frame
tf.text = "Bullet 1"
tf.add_paragraph().text = "Bullet 2"

# Slide với chart
from pptx.util import Inches
from pptx.chart.data import ChartData
from pptx.enum.chart import XL_CHART_TYPE

chart_data = ChartData()
chart_data.categories = ['Q1', 'Q2', 'Q3']
chart_data.add_series('Revenue', (1000, 1500, 2000))
slide.shapes.add_chart(XL_CHART_TYPE.BAR_CLUSTERED, Inches(1), Inches(2), Inches(6), Inches(4), chart_data)

prs.save('output.pptx')
```

### Node.js — PptxGenJS
```bash
npm install pptxgenjs
```
```js
const pptx = require('pptxgenjs');
const pres = new pptx();

const slide = pres.addSlide();
slide.addText('Title', { x: 1, y: 1, fontSize: 36, bold: true });
slide.addText('Content', { x: 1, y: 2, fontSize: 18 });

// Image
slide.addImage({ path: 'logo.png', x: 0.5, y: 0.5, w: 1, h: 1 });

// Table
slide.addTable([
  [{ text: 'Name', options: { bold: true } }, { text: 'Value' }],
  ['Item 1', '100'],
], { x: 1, y: 3, w: 8 });

await pres.writeFile({ fileName: 'output.pptx' });
```

---

## Web-based Slides

### Marp (Markdown → slides, simplest)
```bash
npm install -g @marp-team/marp-cli
```
```markdown
---
marp: true
theme: default
---

# Slide 1
Content here

---

# Slide 2
- Bullet 1
- Bullet 2
```
```bash
marp slides.md --pdf  # Export PDF
marp slides.md --pptx # Export PPTX
marp slides.md        # Export HTML
```

### Reveal.js (interactive web presentation)
HTML-based, good for code demos and live web hosting.

---

## Khi nào dùng gì
| Case | Tool |
|------|------|
| .pptx từ data/template | python-pptx |
| .pptx từ Node.js | PptxGenJS |
| Slides từ Markdown nhanh | Marp |
| Interactive web slides | Reveal.js |
