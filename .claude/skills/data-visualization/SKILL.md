---
name: data-visualization
description: "Charts & data visualization. Trigger khi cần biểu đồ, dashboard analytics, recharts, chart.js."
---

# Data Visualization

## Stack: Recharts (React-native, nhẹ nhất)
```bash
npm install recharts
```

## Chart Types & When to Use
| Chart | Component | Dùng khi |
|-------|-----------|---------|
| Line | `LineChart` | Trend theo thời gian |
| Bar | `BarChart` | So sánh categories |
| Area | `AreaChart` | Volume/trend tích lũy |
| Pie | `PieChart` | Tỉ lệ phần trăm (<5 slices) |
| Composed | `ComposedChart` | Mix bar + line |

## Pattern chuẩn (Responsive)
```tsx
'use client'
import { ResponsiveContainer, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts'

const data = [
  { date: '01/01', revenue: 4000, orders: 24 },
  { date: '01/02', revenue: 3000, orders: 18 },
]

export function RevenueChart() {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <LineChart data={data} margin={{ top: 5, right: 30, left: 0, bottom: 5 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
        <XAxis dataKey="date" />
        <YAxis />
        <Tooltip formatter={(v) => v.toLocaleString('vi-VN')} />
        <Legend />
        <Line type="monotone" dataKey="revenue" stroke="#1677ff" strokeWidth={2} dot={false} />
        <Line type="monotone" dataKey="orders" stroke="#52c41a" strokeWidth={2} dot={false} />
      </LineChart>
    </ResponsiveContainer>
  )
}
```

## Ant Design Color Tokens (dùng thay hex cứng)
```tsx
import { theme } from 'antd'

export function Chart() {
  const { token } = theme.useToken()
  return (
    <Line stroke={token.colorPrimary} />
  )
}
```

## Loading State Pattern
```tsx
import { Skeleton } from 'antd'

export function ChartCard({ isLoading, children }) {
  return isLoading
    ? <Skeleton.Node active style={{ width: '100%', height: 300 }} />
    : children
}
```

## Rules
- Luôn dùng `ResponsiveContainer` — không hardcode width
- Empty state khi `data.length === 0` — hiện `<Empty />`  từ Ant Design
- Format number với `toLocaleString('vi-VN')` cho VND/số lớn
- Không nhồi quá 5 data series trong 1 chart
