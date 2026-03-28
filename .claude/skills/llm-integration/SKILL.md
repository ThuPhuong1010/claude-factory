---
name: llm-integration
description: "AI/LLM integration — Claude, OpenAI, streaming, tool use, RAG. Trigger khi app gọi AI model hoặc build AI feature."
versions: { ai: "^4.0", "@ai-sdk/react": "^1.0", "@ai-sdk/anthropic": "^1.0" }
---

# LLM Integration (Vercel AI SDK v4)

```bash
npm install ai @ai-sdk/react @ai-sdk/anthropic zod
```

## Streaming Chat — App Router

```ts
// app/api/chat/route.ts
import { anthropic } from '@ai-sdk/anthropic'
import { streamText, UIMessage, convertToModelMessages } from 'ai'

export async function POST(req: Request) {
  const { messages }: { messages: UIMessage[] } = await req.json()
  const result = streamText({
    model: anthropic('claude-sonnet-4-6'),
    system: 'You are a helpful assistant.',
    messages: await convertToModelMessages(messages),
    maxTokens: 2048,
  })
  return result.toUIMessageStreamResponse()
}
```

```tsx
// components/Chat.tsx
'use client'
import { useChat } from '@ai-sdk/react'

export function Chat() {
  const { messages, input, setInput, sendMessage, status } = useChat()
  const isLoading = status === 'streaming' || status === 'submitted'
  return (
    <div>
      {messages.map(m => (
        <div key={m.id}>
          <b>{m.role}:</b>{' '}
          {m.parts.map((p, i) => p.type === 'text' ? <span key={i}>{p.text}</span> : null)}
        </div>
      ))}
      <form onSubmit={e => { e.preventDefault(); sendMessage({ text: input }); setInput('') }}>
        <input value={input} onChange={e => setInput(e.target.value)} disabled={isLoading} />
        <button type="submit" disabled={isLoading}>Send</button>
      </form>
    </div>
  )
}
```

> ⚠️ v4 thay đổi lớn: `UIMessage` (không phải `Message`), `convertToModelMessages()`, `sendMessage()` (không phải `handleSubmit()`), import từ `@ai-sdk/react` (không phải `ai/react`)

## Tool Use

```ts
import { tool, streamText } from 'ai'
import { z } from 'zod'

const result = streamText({
  model: anthropic('claude-sonnet-4-6'),
  messages: await convertToModelMessages(messages),
  tools: {
    getWeather: tool({
      description: 'Get weather for a city',
      inputSchema: z.object({ city: z.string() }),
      execute: async ({ city }) => ({ temp: 25, condition: 'sunny' }),
    }),
  },
  stopWhen: (steps) => steps.length >= 5,  // max 5 tool call rounds
})
```

## Không stream (generate một lần)

```ts
import { generateText } from 'ai'
const { text } = await generateText({
  model: anthropic('claude-haiku-4-5'),
  prompt: 'Classify this text: ' + input,
})
```

## Cost Control

| Task | Model |
|------|-------|
| Classify, extract, short | `claude-haiku-4-5` |
| General, coding | `claude-sonnet-4-6` |
| Complex reasoning | `claude-opus-4-6` |

- Luôn set `maxTokens` — không để unlimited
- Cache system prompt: thêm `experimental_providerMetadata: { anthropic: { cacheControl: { type: 'ephemeral' } } }` vào system message
- Log usage: `result.usage` trả về `{ inputTokens, outputTokens }`

## Rules
- API key: `ANTHROPIC_API_KEY` trong `.env`
- Validate + sanitize user input trước khi nhúng vào system prompt (prompt injection)
- Không expose system prompt ra client
- Fallback message khi LLM lỗi (wrap trong try/catch)
