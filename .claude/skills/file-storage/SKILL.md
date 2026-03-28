---
name: file-storage
description: "File upload & cloud storage. Trigger khi cần upload file, lưu ảnh, attachment, S3, R2, presigned URL."
---

# File Storage

## Stack mặc định: UploadThing (Next.js native, đơn giản nhất)
```bash
npm install uploadthing @uploadthing/react
```

```ts
// app/api/uploadthing/core.ts
import { createUploadthing, type FileRouter } from 'uploadthing/next'
const f = createUploadthing()

export const ourFileRouter = {
  imageUploader: f({ image: { maxFileSize: '4MB', maxFileCount: 1 } })
    .middleware(async ({ req }) => {
      const user = await auth() // validate session
      if (!user) throw new Error('Unauthorized')
      return { userId: user.id }
    })
    .onUploadComplete(async ({ metadata, file }) => {
      await db.user.update({ where: { id: metadata.userId }, data: { avatar: file.url } })
    }),
} satisfies FileRouter
```

```ts
// app/api/uploadthing/route.ts
import { createRouteHandler } from 'uploadthing/next'
import { ourFileRouter } from './core'
export const { GET, POST } = createRouteHandler({ router: ourFileRouter })
```

```tsx
// components/UploadButton.tsx
'use client'
import { UploadButton } from '@uploadthing/react'
import type { OurFileRouter } from '@/app/api/uploadthing/core'

export function AvatarUpload() {
  return (
    <UploadButton<OurFileRouter, 'imageUploader'>
      endpoint="imageUploader"
      onClientUploadComplete={(res) => console.log('Uploaded:', res[0].url)}
      onUploadError={(e) => console.error(e)}
    />
  )
}
```

## Thay thế: Cloudflare R2 (tiết kiệm cost)
```ts
// lib/r2.ts
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3'
import { getSignedUrl } from '@aws-sdk/s3-request-presigner'

const r2 = new S3Client({
  region: 'auto',
  endpoint: process.env.R2_ENDPOINT,
  credentials: { accessKeyId: process.env.R2_ACCESS_KEY!, secretAccessKey: process.env.R2_SECRET_KEY! },
})

export async function getPresignedUploadUrl(key: string) {
  return getSignedUrl(r2, new PutObjectCommand({ Bucket: process.env.R2_BUCKET, Key: key }), { expiresIn: 3600 })
}
```

## Rules
- Validate file type + size server-side (không chỉ client)
- Lưu URL vào DB, không lưu file content trong DB
- Tên file: UUID, không dùng tên gốc từ user (security)
- Public files: CDN URL trực tiếp. Private files: presigned URL với expiry
