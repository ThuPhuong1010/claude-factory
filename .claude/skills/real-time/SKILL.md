---
name: real-time
description: "Real-time updates — SSE, WebSocket, Socket.io. Trigger khi cần live data, chat, notification, dashboard realtime."
---

# Real-time

## Lựa chọn theo use case
| Need | Solution | Complexity |
|------|----------|-----------|
| Server → client only (notification, feed) | SSE | Thấp |
| Bi-directional (chat, collab) | Socket.io | Trung bình |
| Managed (production, scale) | Pusher / Ably | Thấp (cost) |

## SSE — Server-Sent Events (đơn giản nhất, Next.js native)
```ts
// app/api/stream/route.ts
export async function GET() {
  const encoder = new TextEncoder()
  const stream = new ReadableStream({
    async start(controller) {
      const send = (data: object) =>
        controller.enqueue(encoder.encode(`data: ${JSON.stringify(data)}\n\n`))

      // Gửi data theo interval hoặc khi có event
      const interval = setInterval(() => send({ time: Date.now() }), 1000)
      // Cleanup khi client disconnect
      return () => clearInterval(interval)
    },
  })
  return new Response(stream, {
    headers: { 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache' },
  })
}
```

```tsx
// Client
'use client'
import { useEffect, useState } from 'react'

export function LiveFeed() {
  const [data, setData] = useState(null)
  useEffect(() => {
    const es = new EventSource('/api/stream')
    es.onmessage = (e) => setData(JSON.parse(e.data))
    return () => es.close()
  }, [])
  return <div>{JSON.stringify(data)}</div>
}
```

## Socket.io (bi-directional)
```bash
npm install socket.io socket.io-client
```
> Next.js App Router không support Socket.io server natively.
> Cần Express server riêng hoặc dùng custom server (`server.ts`).
> Hoặc dùng Pusher/Ably managed service — đơn giản hơn nhiều.

## Pusher (managed, production-ready)
```bash
npm install pusher pusher-js
```
```ts
// Server: trigger event
import Pusher from 'pusher'
const pusher = new Pusher({ appId, key, secret, cluster })
await pusher.trigger('my-channel', 'new-message', { text: 'Hello' })

// Client: subscribe
import Pusher from 'pusher-js'
const pusher = new PusherClient(key, { cluster })
const channel = pusher.subscribe('my-channel')
channel.bind('new-message', (data) => console.log(data))
```

## Rules
- SSE cho notification/feed đơn hướng — không overengineer với WebSocket
- Luôn cleanup connection khi component unmount (`es.close()`, `unsubscribe()`)
- Reconnect logic: SSE tự reconnect. Socket.io cần config `reconnection: true`
