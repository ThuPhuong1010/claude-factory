---
name: nextjs-app-router
description: "Next.js 15 App Router patterns. Trigger khi tạo pages, layouts, API routes."
---

# Next.js 15 App Router

## Key Rules
- Default: Server Components (no hooks)
- Need hooks? Add 'use client' at top
- params is Promise in Next.js 15+
- Layout wraps pages, persists across navigation

## File Convention
page.tsx=route, layout.tsx=layout, loading.tsx=loading,
error.tsx=error boundary, not-found.tsx=404, route.ts=API

## Common Gotchas → see references/gotchas.md
