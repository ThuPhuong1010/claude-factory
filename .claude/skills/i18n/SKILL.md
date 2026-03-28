---
name: i18n
description: "Internationalization — đa ngôn ngữ. Trigger khi app cần multi-language, locale routing, next-intl."
---

# Internationalization (next-intl)

```bash
npm install next-intl
```

## File Structure
```
messages/
├── vi.json     # Tiếng Việt (default)
└── en.json
```

```json
// messages/vi.json
{
  "nav": { "home": "Trang chủ", "about": "Giới thiệu" },
  "auth": {
    "login": "Đăng nhập",
    "logout": "Đăng xuất",
    "welcome": "Xin chào, {name}!"
  }
}
```

## Setup
```ts
// i18n/routing.ts
import { defineRouting } from 'next-intl/routing'
export const routing = defineRouting({
  locales: ['vi', 'en'],
  defaultLocale: 'vi',
})
```

```ts
// middleware.ts
import createMiddleware from 'next-intl/middleware'
import { routing } from './i18n/routing'
export default createMiddleware(routing)
export const config = { matcher: ['/', '/(vi|en)/:path*'] }
```

```
app/
└── [locale]/
    ├── layout.tsx
    └── page.tsx
```

```tsx
// app/[locale]/layout.tsx
import { NextIntlClientProvider } from 'next-intl'
import { getMessages } from 'next-intl/server'

export default async function Layout({ children, params: { locale } }) {
  const messages = await getMessages()
  return (
    <html lang={locale}>
      <body>
        <NextIntlClientProvider messages={messages}>
          {children}
        </NextIntlClientProvider>
      </body>
    </html>
  )
}
```

## Usage
```tsx
// Server component
import { useTranslations } from 'next-intl'
export default function Page() {
  const t = useTranslations('nav')
  return <nav>{t('home')}</nav>
}

// Với variable
t('auth.welcome', { name: 'An' })  // → "Xin chào, An!"
```

## Ant Design Locale Sync
```tsx
import viVN from 'antd/locale/vi_VN'
import enUS from 'antd/locale/en_US'

const antdLocale = locale === 'vi' ? viVN : enUS
<ConfigProvider locale={antdLocale}>...</ConfigProvider>
```

## Rules
- Không hardcode string UI — mọi text đều qua `t()`
- Key format: `namespace.key` (`'auth.login'`, không `'authLogin'`)
- Tiếng Việt là default locale — phát triển VI trước, EN sau
