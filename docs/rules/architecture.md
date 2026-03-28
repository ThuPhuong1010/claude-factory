# Architecture
Layers: UI → Hooks → Services → API → Database
No circular deps. Shared code in lib/. State: useState (local),
Zustand (shared), TanStack Query (server), Ant Form (forms).
