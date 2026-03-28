---
name: state-management
description: "Zustand + TanStack Query. Trigger khi quản lý state, fetch/cache server data, global store."
versions: { zustand: "^5", "@tanstack/react-query": "^5" }
---

# State Management

## Nguyên tắc phân chia
- **Server state** (async, cacheable) → TanStack Query
- **Client/UI state** (sync, local) → Zustand
- Không dùng Zustand cache server data. Không dùng useState cho global state.

## Zustand Store

```ts
// stores/useAuthStore.ts
import { create } from 'zustand'
import { devtools } from 'zustand/middleware'

interface AuthState {
  user: User | null
  setUser: (user: User | null) => void
  logout: () => void
}

export const useAuthStore = create<AuthState>()(
  devtools(
    (set) => ({
      user: null,
      setUser: (user) => set({ user }),
      logout: () => set({ user: null }),
    }),
    { name: 'auth-store' }
  )
)
```

**Đọc state ngoài component:**
```ts
const user = useAuthStore.getState().user          // non-reactive
useAuthStore.setState({ user: null })              // set từ ngoài
const unsub = useAuthStore.subscribe(console.log)  // subscribe
```

**Async action trong store:**
```ts
const useDataStore = create<DataState>()((set, get) => ({
  data: null,
  fetch: async (id: string) => {
    const res = await fetch(`/api/data/${id}`)
    set({ data: await res.json() })
  },
}))
```

## TanStack Query v5

```tsx
// providers/QueryProvider.tsx
'use client'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useState } from 'react'

export function QueryProvider({ children }: { children: React.ReactNode }) {
  const [client] = useState(() => new QueryClient({
    defaultOptions: { queries: { staleTime: 60_000, retry: 1 } },
  }))
  return <QueryClientProvider client={client}>{children}</QueryClientProvider>
}
```

**Query key factory** (nhất quán, dễ invalidate):
```ts
export const postKeys = {
  all: ['posts'] as const,
  list: (f?: object) => [...postKeys.all, 'list', f] as const,
  detail: (id: string) => [...postKeys.all, 'detail', id] as const,
}
```

**useQuery:**
```ts
const { data, isLoading, error } = useQuery({
  queryKey: postKeys.list({ status: 'published' }),
  queryFn: () => fetchPosts({ status: 'published' }),
})
```

**useMutation + invalidate:**
```ts
const { mutate, isPending } = useMutation({
  mutationFn: createPost,
  onSuccess: () => queryClient.invalidateQueries({ queryKey: postKeys.all }),
  onError: (err) => toast.error(err.message),
})
```

**Optimistic update:**
```ts
const { mutate } = useMutation({
  mutationFn: updatePost,
  onMutate: async (newData) => {
    await queryClient.cancelQueries({ queryKey: postKeys.detail(newData.id) })
    const prev = queryClient.getQueryData(postKeys.detail(newData.id))
    queryClient.setQueryData(postKeys.detail(newData.id), newData)
    return { prev }
  },
  onError: (_, vars, ctx) => queryClient.setQueryData(postKeys.detail(vars.id), ctx?.prev),
  onSettled: (_, __, vars) => queryClient.invalidateQueries({ queryKey: postKeys.detail(vars.id) }),
})
```
