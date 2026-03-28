---
name: email
description: "Transactional email. Trigger khi gửi email verification, password reset, notification, invoice."
---

# Email

## Stack: Resend + React Email
```bash
npm install resend @react-email/components
```

## Email Template
```tsx
// emails/WelcomeEmail.tsx
import { Html, Head, Body, Container, Heading, Text, Button } from '@react-email/components'

interface Props { name: string; verifyUrl: string }

export function WelcomeEmail({ name, verifyUrl }: Props) {
  return (
    <Html>
      <Head />
      <Body style={{ fontFamily: 'sans-serif', background: '#f6f9fc' }}>
        <Container style={{ maxWidth: 600, margin: '0 auto', padding: 24 }}>
          <Heading>Xin chào {name}!</Heading>
          <Text>Nhấn nút bên dưới để xác nhận email của bạn.</Text>
          <Button href={verifyUrl} style={{ background: '#0070f3', color: '#fff', padding: '12px 24px', borderRadius: 6 }}>
            Xác nhận Email
          </Button>
        </Container>
      </Body>
    </Html>
  )
}
```

## Gửi Email
```ts
// lib/email.ts
import { Resend } from 'resend'
import { WelcomeEmail } from '@/emails/WelcomeEmail'

const resend = new Resend(process.env.RESEND_API_KEY)

export async function sendWelcomeEmail(to: string, name: string, verifyUrl: string) {
  const { error } = await resend.emails.send({
    from: 'MyApp <no-reply@myapp.com>',
    to,
    subject: 'Xác nhận email của bạn',
    react: WelcomeEmail({ name, verifyUrl }),
  })
  if (error) throw new Error(`Email failed: ${error.message}`)
}
```

## Email Types thường gặp
| Type | Subject pattern | Trigger |
|------|----------------|---------|
| Verify | Xác nhận email | Đăng ký mới |
| Reset password | Đặt lại mật khẩu | Quên mật khẩu |
| Welcome | Chào mừng bạn | Sau verify |
| Notification | [Tên app] Thông báo | Event trong app |
| Invoice | Hóa đơn #XXX | Thanh toán |

## Preview local
```bash
npx email dev   # mở http://localhost:3000 xem email preview
```

## Rules
- `RESEND_API_KEY` trong `.env`
- Domain xác thực trong Resend dashboard (tránh spam folder)
- Luôn có text fallback cho HTML email
- Rate limit: không gửi quá 1 email/phút/user
