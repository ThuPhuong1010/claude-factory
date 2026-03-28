# Rules: AI / LLM App

Áp dụng thêm vào universal rules khi solution type là AI/LLM App.

## Bắt buộc
- RAISE API keys vào `docs/reports/integration-needs.md` trước khi code
- Không hardcode system prompt trong code — lưu trong config file hoặc DB
- Mọi LLM call phải có try/catch + fallback message cho user
- Set `maxTokens` cho mọi LLM call — không để unlimited
- Log token usage trong development để estimate cost

## Security
- Prompt injection: validate + sanitize user input trước khi nhúng vào system prompt
- Không expose system prompt ra client response
- Rate limit per user: tránh abuse làm tốn cost

## Cost Control
| Tình huống | Model khuyên dùng |
|-----------|------------------|
| Classify, extract, short task | claude-haiku-4-5 |
| General, coding, analysis | claude-sonnet-4-6 |
| Complex reasoning, long context | claude-opus-4-6 |

- Cache system prompt với `cacheControl: 'ephemeral'` (tiết kiệm 90% cost long prompts)
- Streaming: dùng `streamText` thay `generateText` cho UX tốt hơn

## Testing
- Unit test: mock LLM response — test logic xử lý output
- Eval: tạo `docs/testing/llm-evals.md` với test cases input/expected-output
- KHÔNG test quality của LLM response bằng unit test — test bằng eval manual

## State Management
- Conversation history: lưu trong DB (không chỉ client state) để resume session
- Streaming state: dùng Zustand cho `isStreaming`, `error` — không useState local
