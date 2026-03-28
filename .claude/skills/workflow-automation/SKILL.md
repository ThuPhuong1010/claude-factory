---
name: workflow-automation
description: "n8n, Make, Zapier flows, hoặc custom automation pipeline. Trigger khi solution là workflow tự động kết nối các services."
---

# Workflow Automation

## Khi nào dùng tool nào

| Tool | Phù hợp | Self-host |
|------|---------|-----------|
| n8n | Complex logic, code nodes, self-host | ✅ |
| Make (Integromat) | Visual, 1000+ apps, ít code | ❌ |
| Zapier | Đơn giản, non-technical | ❌ |
| Custom code | Full control, complex transform | ✅ |

---

## n8n

### Setup local
```bash
npx n8n  # Quick test
# hoặc Docker
docker run -it --rm -p 5678:5678 -v ~/.n8n:/home/node/.n8n n8nio/n8n
```

### Workflow Design Principles
1. **Trigger node** đầu tiên: Webhook / Schedule / Manual
2. **Transform nodes**: Set, Code, IF, Switch
3. **Action nodes**: HTTP Request, Email, Database, File
4. **Error handling**: nối Error output, dùng "On Error" node

### Code Node (JavaScript)
```js
// Input: $input.all() = array of items
// Output: return array of items

const items = $input.all();
return items.map(item => ({
  json: {
    ...item.json,
    processed: true,
    timestamp: new Date().toISOString(),
  }
}));
```

### HTTP Request Node Config
```
Method: POST
URL: https://api.example.com/endpoint
Authentication: Header Auth → "Authorization: Bearer {{$env.API_KEY}}"
Body: JSON → { "data": "{{$json.field}}" }
```

### Credentials & Secrets
- Lưu trong n8n Credentials (không hardcode trong workflow)
- Reference: `{{ $credentials.myCredential.apiKey }}`

---

## Custom Automation Script (Node.js)

```typescript
// Pattern: pipeline với steps
interface PipelineContext {
  data: any;
  errors: Error[];
  metadata: Record<string, any>;
}

const pipeline = [
  fetchData,
  transformData,
  validateData,
  sendToDestination,
];

async function run() {
  const ctx: PipelineContext = { data: null, errors: [], metadata: {} };

  for (const step of pipeline) {
    try {
      await step(ctx);
    } catch (err) {
      ctx.errors.push(err as Error);
      console.error(`Step ${step.name} failed:`, err);
      // Decide: continue or abort
      break;
    }
  }

  return ctx;
}
```

---

## Testing Automation Workflows

Vì không thể "unit test" n8n nodes trực tiếp, dùng Tier 3:

**docs/testing/test-scenarios.md format:**
```markdown
## Scenario 1: Happy path
Input: [mô tả trigger data]
Expected: [kết quả ở destination]
Verify: [check ở đâu — database record, email received, file created]
Rollback: [xóa record test, revert changes]

## Scenario 2: Invalid input
Input: [missing field / wrong format]
Expected: [workflow stops at validation, logs error]
Verify: [check error log / notification]
```

**Dry-run checklist:**
- [ ] Dùng sandbox/test credentials
- [ ] Dùng test data, không phải production data
- [ ] Verify từng node output trước khi nối node tiếp
- [ ] Test error path (disable action node, check error handling)
- [ ] Test idempotency (chạy 2 lần = kết quả giống nhau)
