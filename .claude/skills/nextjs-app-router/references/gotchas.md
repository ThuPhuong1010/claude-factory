# Next.js App Router Gotchas

1. Missing 'use client' → useState/useEffect won't work
2. Params is Promise (Next.js 15+) → must await params
3. ConfigProvider needs 'use client' → separate AntdProvider component
4. Hydration mismatch → no window/localStorage in initial render
5. Import 'server-only' in server-only files
