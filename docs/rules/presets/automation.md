# Preset: Automation / Workflow

Load khi solution type = Automation, Workflow, Process Design, Integration, Bot.

## Types thuộc preset này
- Workflow tự động (n8n, Zapier, Make, custom pipeline)
- Scheduled jobs / cron tasks
- Event-driven pipelines (webhook → process → output)
- Integration giữa các services
- Process documentation + automation

## Design Principles

- **Idempotent**: chạy nhiều lần = kết quả giống nhau (dùng unique ID để dedup)
- **Fail-safe**: lỗi không làm hỏng data — validate trước khi mutate
- **Observable**: log đủ để debug khi lỗi mà không cần reproduce
- **Resumable**: nếu dừng giữa chừng, có thể tiếp tục từ điểm dừng

## Structure

```
workflows/
├── README.md            # Mô tả tổng thể + trigger conditions
├── triggers/            # Webhook handlers, cron definitions
├── steps/               # Individual step logic
├── handlers/            # Error handlers, retry logic
└── config/              # Environment config, connection details

docs/testing/
├── test-scenarios.md    # Manual test cases
└── dry-run-guide.md     # Hướng dẫn test an toàn
```

## Error Handling + Retry Pattern

**n8n Error Workflow:**
```
Main Workflow
  → Step fails
  → Catch với "Error Trigger" node
  → Log error: timestamp + node name + input data + error message
  → Retry nếu transient (HTTP 429, 503, timeout): max 3 lần, backoff 2^n giây
  → Dead Letter Queue nếu vẫn fail: lưu vào DB/sheet để review thủ công
  → Alert: gửi notification (Slack/email) nếu critical
```

**Custom Python/Node pipeline:**
```python
import time

def run_with_retry(fn, max_attempts=3, backoff_base=2):
    for attempt in range(max_attempts):
        try:
            return fn()
        except TransientError as e:
            if attempt == max_attempts - 1:
                raise
            wait = backoff_base ** attempt
            logger.warning(f"Attempt {attempt+1} failed: {e}. Retry in {wait}s")
            time.sleep(wait)
        except PermanentError as e:
            logger.error(f"Permanent failure: {e}")
            send_to_dlq(e)  # Dead Letter Queue
            raise
```

## Idempotency Pattern

```python
# Track processed IDs để tránh duplicate processing
def process_event(event_id: str, payload: dict):
    if db.processed_events.exists(event_id):
        logger.info(f"Skipping duplicate: {event_id}")
        return  # Idempotent — safe to skip

    result = do_work(payload)
    db.processed_events.insert(event_id, result)
    return result
```

## Logging Convention

```python
# Format: [Module] action | key=value pairs
logger.info("[OrderProcessor] processed | order_id=123 status=success items=5")
logger.error("[WebhookHandler] failed | event_id=abc error='Connection timeout'")
# KHÔNG log: passwords, PII, full request body với sensitive fields
```

## Testing Workflows (Tier 3 — không chạy trực tiếp)

Tạo `docs/testing/test-scenarios.md`:
```markdown
## Scenario 1: Happy path
- Setup: [điều kiện cần]
- Input: [data mẫu]
- Expected: [kết quả mong đợi]
- Verify bằng: [cách kiểm tra]

## Scenario 2: Transient error → retry
- Setup: Mock service trả về 503 lần đầu
- Expected: retry sau 2s, thành công lần 2
- Verify: log có "Retry in 2s", kết quả đúng

## Scenario 3: Permanent failure → DLQ
- Setup: Mock service luôn fail
- Expected: sau 3 attempts, item vào dead letter queue
- Verify: DLQ có entry, alert được gửi
```

## External Services

- RAISE trong `docs/reports/integration-needs.md` trước khi code
- Dùng mock/stub trong testing (không hit real API)
- Ghi environment variables cần thiết vào `.env.example`
- Webhook secrets qua env var — không hardcode trong workflow
