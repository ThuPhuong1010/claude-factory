---
name: testing
description: "Testing strategy. Trigger khi viết test, thiết kế test architecture, hoặc debug test failure."
---

# Testing

## Khi nào cần đọc skill này
- Bắt đầu viết test cho feature mới
- Quyết định test cái gì và như thế nào
- Test đang fail không rõ lý do
- Cần đạt coverage > 70%

---

## Phân tích — Test What?

Trước khi viết test, tự hỏi:

```
Feature này cần test gì?
  → Happy path: input hợp lệ → output đúng
  → Error cases: validation fail, API error, permission denied
  → Edge cases: empty list, max length, concurrent actions
  → UI behavior: button disable khi loading, error message hiện đúng chỗ
```

**Không test:**
- Implementation details (tên biến, cấu trúc nội bộ component)
- Third-party library behavior
- Trivial 1-line getters

---

## Design — Test Pyramid

```
        /\
       /E2E\        ← Ít (chậm) — Playwright, chỉ critical flows
      /──────\
     /Integr. \     ← Vừa — API route + DB thật
    /──────────\
   /   Unit     \   ← Nhiều (nhanh) — Vitest + RTL
  /──────────────\
Tỷ lệ: 70% unit / 20% integration / 10% E2E
```

---

## Design — Test Per Layer

| Layer | Test gì | Tool |
|-------|---------|------|
| UI Components | Render, user interaction, state | RTL + userEvent |
| Custom Hooks | Logic, loading/error states | renderHook |
| Services / Utils | Business logic, transformation | Vitest |
| API Routes | Response, validation, errors | Fetch mock / supertest |

---

## Stack & Setup

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./src/test/setup.ts'],
    coverage: { reporter: ['text', 'html'], thresholds: { lines: 70 } }
  }
})

// src/test/setup.ts
import '@testing-library/jest-dom'
```

---

## Implementation Patterns

**Component — user behavior:**
```typescript
it('should show error when email invalid', async () => {
  const user = userEvent.setup()
  render(<LoginForm />)
  await user.type(screen.getByLabelText('Email'), 'not-email')
  await user.click(screen.getByRole('button', { name: 'Đăng nhập' }))
  expect(screen.getByText('Email không hợp lệ')).toBeInTheDocument()
})
```

**Async / loading states:**
```typescript
it('should show loading then data', async () => {
  vi.spyOn(api, 'getUsers').mockResolvedValue([{ id: 1, name: 'Test' }])
  render(<UserList />)
  expect(screen.getByTestId('skeleton')).toBeInTheDocument()
  expect(await screen.findByText('Test')).toBeInTheDocument()
})

it('should show error state when API fails', async () => {
  vi.spyOn(api, 'getUsers').mockRejectedValue(new Error('Network error'))
  render(<UserList />)
  expect(await screen.findByRole('button', { name: 'Thử lại' })).toBeInTheDocument()
})
```

**Run per task (không full suite):**
```bash
npx vitest run --related src/components/LoginForm.tsx
```

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| `fireEvent.click()` | `await userEvent.click()` |
| Test internal state | Test rendered output + behavior |
| Mock mọi thứ kể cả business logic | Chỉ mock I/O (API, DB, timer) |
| Comment out failing test | Fix root cause |
