# Rules: AI / LLM App

Áp dụng thêm vào universal rules khi solution type là AI/LLM App.

## Stack gợi ý

| Use case | Stack |
|---------|-------|
| Chat UI + streaming | Next.js + Vercel AI SDK + Claude API |
| Python backend + LLM | FastAPI + Anthropic Python SDK |
| Autonomous agent | Claude API + tool_use |
| RAG / document Q&A | LangChain / LlamaIndex + vector DB |

## Model Selection

| Tình huống | Model |
|-----------|-------|
| Classify, extract, short task | `claude-haiku-4-5` |
| General, coding, analysis | `claude-sonnet-4-6` |
| Complex reasoning, long context | `claude-opus-4-6` |

**Rule:** Dùng model nhỏ nhất đáp ứng được yêu cầu. Cost khác nhau ~10-20x.

## Bắt buộc

- RAISE API keys vào `docs/reports/integration-needs.md` trước khi code
- Không hardcode system prompt trong code — lưu trong `prompts/` folder hoặc DB
- Mọi LLM call có try/catch + user-facing fallback message
- Set `max_tokens` cho mọi LLM call — không để unlimited
- Log token usage trong development để track cost

## Streaming Pattern

```typescript
// Vercel AI SDK
import { streamText } from 'ai'
import { anthropic } from '@ai-sdk/anthropic'

const result = streamText({
  model: anthropic('claude-sonnet-4-6'),
  system: systemPrompt,
  messages: history,
  maxTokens: 2048,
})

// Zustand store cho streaming state
const useChatStore = create((set) => ({
  isStreaming: false,
  error: null,
  setStreaming: (v) => set({ isStreaming: v }),
  setError: (e) => set({ error: e }),
}))
```

## Prompt Cache (tiết kiệm cost)

```typescript
// Cache system prompt — tiết kiệm 90% cost cho long prompts (>1024 tokens)
const result = await anthropic.messages.create({
  model: 'claude-sonnet-4-6',
  system: [{ type: 'text', text: longSystemPrompt, cache_control: { type: 'ephemeral' } }],
  messages: userMessages,
})
```

## Security

- **Prompt injection**: validate + sanitize user input trước khi nhúng vào system prompt
  ```python
  # Wrap user input, đừng concatenate trực tiếp vào system prompt
  messages = [{"role": "user", "content": f"User query: {sanitize(user_input)}"}]
  ```
- Không expose system prompt trong response hoặc error messages
- Rate limit per user (5-10 requests/min) — tránh cost abuse
- Log request IDs, không log content của user (privacy)

## Tool Use / Agent Pattern

```typescript
const tools = {
  searchWeb: tool({
    description: 'Search the web for current information',
    parameters: z.object({ query: z.string() }),
    execute: async ({ query }) => await webSearch(query),
  }),
}

const result = await generateText({
  model: anthropic('claude-sonnet-4-6'),
  tools,
  maxSteps: 5,  // giới hạn agentic loop — không để vô hạn
})
```

## State Management

- Conversation history: lưu trong DB (không chỉ client state) để resume session
- Streaming state: Zustand `isStreaming`, `error` — không useState local
- Message IDs: UUID cho mỗi message để dedup và reference

## Testing

- **Unit test**: mock LLM response — test logic xử lý output, không test LLM quality
- **Eval file**: tạo `docs/testing/llm-evals.md` với test cases input/expected-output
  ```markdown
  ## Eval: Summarize document
  Input: [sample doc]
  Expected: contains key points A, B, C
  Actual: [run manually, record result]
  Pass/Fail: PASS
  ```
- KHÔNG test quality của LLM response bằng automated unit test
- Integration test: mock `anthropic.messages.create` → test full request/response flow
