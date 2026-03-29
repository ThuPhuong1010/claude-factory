# Architecture Principles
Áp dụng cho mọi solution type. Stack-specific details → xem presets/.

## Layered Architecture (universal)
Mọi solution đều có layers, tên khác nhau theo stack:
```
Web App:     UI → Hooks → Services → API → Database
CLI Tool:    CLI → Commands → Services → I/O (file, network, DB)
Automation:  Trigger → Steps → Handlers → External APIs
```
**Quy tắc:** Mỗi layer chỉ gọi layer ngay dưới. Không skip. Không circular deps.

## Shared Code
- Utilities dùng lại nhiều nơi → `lib/` hoặc `utils/`
- Types/interfaces → `types/`
- Constants → `constants/` hoặc `config/`

## State (Web App — chi tiết trong presets/web.md)
- Local UI state: useState / component state
- Shared app state: Zustand / Redux
- Server/async state: TanStack Query / SWR
- Form state: form library (React Hook Form, Ant Design Form)
