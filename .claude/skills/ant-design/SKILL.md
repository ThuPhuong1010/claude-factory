---
name: ant-design
description: "Ant Design 5.x UI. Trigger khi code React component, form, table, layout, modal. Dùng TRƯỚC KHI viết custom UI."
---

# Ant Design 5.x

## Khi nào cần đọc skill này
- Bắt đầu viết bất kỳ UI component nào
- Chọn component phù hợp cho use case
- Form validation, table pagination
- Layout, theme customization

---

## Phân tích — Chọn Component

**Quyết định trước khi code:**
```
Cần hiển thị gì?
  → Data list có nhiều column     → Table
  → Data list đơn giản            → List
  → Card dạng grid                → Card + Row/Col
  → Stats / số liệu               → Statistic

User cần nhập gì?
  → Form nhiều field              → Form + Form.Item
  → Chọn từ list                  → Select
  → Chọn ngày                     → DatePicker
  → Upload file                   → Upload

Cần feedback gì?
  → Action thành công/thất bại    → message.success() / message.error()
  → Confirm trước khi xóa         → Modal.confirm()
  → Loading state                 → Skeleton hoặc Spin
  → Lỗi cả trang                  → Result

Navigation?
  → Sidebar menu                  → Layout + Sider + Menu
  → Tab trong page                → Tabs
  → Breadcrumb                    → Breadcrumb
```

---

## Design — App Setup

```typescript
// _app.tsx hoặc layout.tsx root
import { ConfigProvider, App } from 'antd'
import viVN from 'antd/locale/vi_VN'

export default function RootLayout({ children }) {
  return (
    <ConfigProvider
      locale={viVN}
      theme={{
        token: {
          colorPrimary: '#1677ff',  // thay bằng brand color
          borderRadius: 8,
        }
      }}
    >
      <App>{children}</App>
    </ConfigProvider>
  )
}
// Wrap App để dùng message/modal/notification hooks
```

---

## Design — Component Patterns

**Form (bắt buộc dùng đúng pattern):**
```typescript
const [form] = Form.useForm()

<Form form={form} onFinish={handleSubmit} layout="vertical">
  <Form.Item name="email" label="Email"
    rules={[{ required: true }, { type: 'email' }]}>
    <Input />
  </Form.Item>
  <Button type="primary" htmlType="submit" loading={isLoading}>
    Submit
  </Button>
</Form>
// onFinish KHÔNG phải onSubmit
// htmlType="submit" để trigger form validation
```

**Table với pagination:**
```typescript
<Table
  columns={columns}
  dataSource={data}
  rowKey="id"
  loading={isLoading}
  pagination={{ pageSize: 20, showTotal: (total) => `${total} items` }}
/>
```

**Confirm dialog:**
```typescript
Modal.confirm({
  title: 'Xóa user này?',
  content: 'Không thể hoàn tác.',
  okText: 'Xóa',
  okType: 'danger',
  cancelText: 'Hủy',
  onOk: () => deleteUser(id),
})
```

---

## Quick Reference

| Need | Component |
|------|-----------|
| Button | `<Button type="primary">` |
| Table | `<Table columns={} dataSource={} rowKey="id">` |
| Form | `<Form onFinish={}>` + `<Form.Item rules={[]}>` |
| Confirm | `Modal.confirm({ title, onOk })` |
| Toast | `message.success()` / `message.error()` |
| Select | `<Select options={[{ value, label }]}/>` |
| Date | `<DatePicker format="DD/MM/YYYY">` |
| Layout | `<Layout><Sider><Content>` |
| Icons | `import { UserOutlined } from '@ant-design/icons'` |
| Menu | `<Menu items={[{ key, icon, label }]}>` |
| Loading | `<Skeleton active>` hoặc `<Spin>` |
| Empty | `<Empty description="Chưa có dữ liệu">` |
| Error page | `<Result status="500" title="Lỗi">` |

---

## Implementation Rules

- `Menu`, `Tabs`, `Select`: dùng `items` array prop — không dùng children syntax (deprecated).
- Import: `import { Button } from 'antd'` — không `antd/lib/button`.
- Colors: dùng ConfigProvider theme tokens — không hardcode hex trong component.
- Mọi page: phải có loading state (Skeleton), empty state (Empty), error state (Result).
- Responsive: dùng `<Row gutter={16}><Col xs={24} md={12}>` — không CSS breakpoint tự viết.

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| `<Menu><Menu.Item>` (children) | `<Menu items={[...]}/>` |
| `onSubmit` trong Form | `onFinish` |
| `import Button from 'antd/lib/button'` | `import { Button } from 'antd'` |
| Hardcode `color: '#ff0000'` | ConfigProvider `token.colorError` |
| Không có loading/empty/error state | Luôn handle 3 states |
| `<Select><Option>` (children) | `<Select options={[]}/>` |

## Deep reference: references/component-guide.md
