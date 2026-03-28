---
name: error-handling
description: "Error handling patterns. Trigger khi viết async code, API calls."
---

# Error Handling

## Rules
- EVERY async → try-catch
- NO empty catch
- User sees: friendly message (Ant Design message component)
- Dev sees: console.error with context prefix
- ErrorBoundary wraps every page/route
- API errors: { success: false, error: { code, message } }
