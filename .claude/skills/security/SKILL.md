---
name: security
description: "Security patterns. Trigger khi code auth, handle user input."
---

# Security
- Auth tokens: httpOnly cookies, NOT localStorage
- Passwords: bcrypt, 12+ rounds
- Input: sanitize all, parameterized queries
- Secrets: .env only, never commit
- CORS: specific origins, no wildcard in prod
- Deps: npm audit regularly
