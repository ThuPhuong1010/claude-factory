---
name: spreadsheet
description: "Tạo/đọc file Excel (.xlsx), CSV, Google Sheets. Trigger khi output là bảng tính, data export, báo cáo số liệu."
---

# Spreadsheet Generation

## Excel (.xlsx)

### Node.js — ExcelJS (full-featured, recommended)
```bash
npm install exceljs
```
```js
const ExcelJS = require('exceljs');

const workbook = new ExcelJS.Workbook();
const sheet = workbook.addWorksheet('Báo cáo');

// Headers với style
sheet.columns = [
  { header: 'STT', key: 'stt', width: 8 },
  { header: 'Tên', key: 'name', width: 30 },
  { header: 'Doanh thu', key: 'revenue', width: 15 },
];

// Style header
sheet.getRow(1).font = { bold: true };
sheet.getRow(1).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF4472C4' } };

// Data
data.forEach((row, i) => sheet.addRow({ stt: i + 1, ...row }));

// Format số
sheet.getColumn('revenue').numFmt = '#,##0 "₫"';

await workbook.xlsx.writeFile('output.xlsx');
```

### Python — openpyxl
```bash
pip install openpyxl
```
```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill

wb = Workbook()
ws = wb.active
ws.title = "Báo cáo"

ws.append(['STT', 'Tên', 'Doanh thu'])
ws['A1'].font = Font(bold=True)

for i, row in enumerate(data, 1):
    ws.append([i, row['name'], row['revenue']])

wb.save('output.xlsx')
```

### Python — pandas (data processing + export)
```bash
pip install pandas openpyxl
```
```python
import pandas as pd

df = pd.DataFrame(data)
df.to_excel('output.xlsx', index=False, sheet_name='Data')

# Multiple sheets
with pd.ExcelWriter('output.xlsx') as writer:
    df1.to_excel(writer, sheet_name='Sheet1', index=False)
    df2.to_excel(writer, sheet_name='Sheet2', index=False)
```

---

## CSV

### Node.js
```js
const { stringify } = require('csv-stringify/sync'); // npm install csv-stringify
const fs = require('fs');

const output = stringify(data, { header: true, columns: ['name', 'email'] });
fs.writeFileSync('output.csv', '\uFEFF' + output); // BOM cho Excel đọc đúng UTF-8
```

### Python
```python
import csv

with open('output.csv', 'w', newline='', encoding='utf-8-sig') as f:
    writer = csv.DictWriter(f, fieldnames=['name', 'email'])
    writer.writeheader()
    writer.writerows(data)
```

---

## Google Sheets (via API)
```bash
npm install googleapis
```
RAISE trong integration-needs.md: cần Google Service Account credentials.

---

## Khi nào dùng gì
| Case | Tool |
|------|------|
| Excel đẹp với style | ExcelJS / openpyxl |
| Data processing + export | pandas |
| Simple CSV export | csv-stringify / Python csv |
| Google Sheets | googleapis (cần RAISE) |
