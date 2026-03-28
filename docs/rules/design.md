# Design Rules

## Design System: Ant Design 5.x
- TOÀN BỘ UI components dùng Ant Design
- KHÔNG tự viết component nếu Ant Design đã có
- KHÔNG mix UI libraries (no MUI, no Chakra, no Headless UI)

## Layout Principles
- Mobile-first: thiết kế cho mobile trước, responsive lên desktop
- Content hierarchy rõ ràng: title → subtitle → content → actions
- Consistent spacing: dùng Ant Design token spacing (8px grid)
- Max content width: 1200px (centered)
- Sidebar: 240px collapsed, 60px mini

## Typography
- Font: System font stack (Ant Design default) hoặc Inter
- Headings: Ant Design Typography component
- Body: 14px (Ant Design default)
- KHÔNG dùng font custom trừ khi brand yêu cầu

## Color
- Primary: dùng Ant Design colorPrimary token
- Semantic colors: success (green), warning (amber), error (red), info (blue)
- KHÔNG hardcode hex — dùng Ant Design token qua ConfigProvider
- Dark mode: dùng Ant Design algorithm switch, KHÔNG tự code

## Component Patterns

### Page Layout
```tsx
<Layout>
  <Layout.Sider collapsible>
    <Menu items={menuItems} />
  </Layout.Sider>
  <Layout>
    <Layout.Header> {/* Breadcrumb + user menu */} </Layout.Header>
    <Layout.Content style={{ padding: 24 }}>
      {children}
    </Layout.Content>
  </Layout>
</Layout>
```

### Data Page (table + CRUD)
```
PageHeader (title + description + primary action button)
├── Filter bar (search input + filter selects)
├── Table (sortable, paginated)
│   └── Actions column (edit, delete)
├── Empty state (khi không có data)
└── Create/Edit Modal hoặc Drawer
```

### Form Page
```
Card
├── Form title
├── Form fields (grouped by section)
│   └── Form.Item with label + rules
├── Divider (between sections)
└── Footer: Cancel + Submit buttons
```

### Dashboard Page
```
Row of Stat Cards (Ant Statistic component)
├── Charts section (1-2 charts)
├── Recent items table
└── Quick actions
```

## States (BẮT BUỘC cho mọi page)
- Loading: Skeleton hoặc Spin
- Empty: Empty component + CTA button
- Error: Result component type="error" + retry button
- Success: message.success() hoặc Result component

## Responsive Breakpoints
- xs: <576px (mobile)
- sm: ≥576px (tablet portrait)
- md: ≥768px (tablet landscape)
- lg: ≥992px (desktop)
- xl: ≥1200px (large desktop)
- Dùng Ant Grid: `<Row gutter={[16, 16]}><Col xs={24} md={12} lg={8}>`

## Accessibility (WCAG 2.1 AA)
- Alt text cho mọi image
- Labels cho mọi form input
- Keyboard navigation hoạt động
- Color contrast ratio ≥ 4.5:1
- Focus indicators visible

## Icons
- Primary: @ant-design/icons
- Supplement: Lucide React (nếu Ant Design không có)
- Size: 16px inline, 24px standalone
- KHÔNG dùng emoji trong UI

## Animation
- Dùng Ant Design built-in transitions
- Page transitions: không cần (App Router handles)
- Micro-interactions: hover states, loading transitions
- KHÔNG dùng animation libraries (framer-motion, etc.) trừ khi cần phức tạp

## Design Review Checklist (cho /review command)
- [ ] Dùng Ant Design components (không custom)
- [ ] Có loading state (Skeleton hoặc Spin)
- [ ] Có empty state (Empty + CTA)
- [ ] Có error state (Result + retry)
- [ ] Responsive (test xs, md, lg)
- [ ] Dark mode hoạt động (nếu enable)
- [ ] Consistent spacing (8px grid)
- [ ] Semantic colors (không hardcode hex)
- [ ] Accessible (labels, alt text, keyboard)
- [ ] No inline styles cho colors (dùng token)
- [ ] Form validation hiển thị đúng
- [ ] Table có pagination
- [ ] Modal confirm cho destructive actions
