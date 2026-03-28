---
name: ant-design
description: "Ant Design 5.x UI. Trigger khi code React component, form,
  table, layout, modal. Dùng TRƯỚC KHI viết custom UI."
---

# Ant Design 5.x

## Setup
Wrap app trong ConfigProvider + App component.
Import locale: `import viVN from 'antd/locale/vi_VN'`
Theme tokens qua ConfigProvider theme prop.

## Quick Reference
| Need | Use |
|------|-----|
| Button | `<Button type="primary">` |
| Table | `<Table columns={} dataSource={}>` |
| Form | `<Form><Form.Item rules={[]}>` |
| Confirm | `Modal.confirm()` |
| Toast | `message.success()` |
| Select | `<Select options={[]}/>` |
| Date | `<DatePicker>` |
| Layout | `<Layout><Sider><Content>` |
| Icons | `@ant-design/icons` |
| Menu | `<Menu items={[]}>` |

## Patterns
- Menu/Tabs/Select: `items` array prop, KHÔNG children
- Form: `onFinish` (KHÔNG onSubmit), `Form.useForm()` hook
- Table: pagination built-in, `pagination={{ pageSize: 10 }}`
- Import: `import { Button } from 'antd'` (KHÔNG `antd/lib/`)

## Deep reference: references/component-guide.md
