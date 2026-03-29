# Preset: Desktop App

Load khi solution type = Desktop App (Electron, Tauri, hoặc native).

## Stack gợi ý

| Use case | Stack |
|---------|-------|
| Web tech + native access | Electron + React/Vue + TypeScript |
| Lighter bundle, Rust backend | Tauri + React/Vue + TypeScript |
| Simple system tray tool | Electron + minimal UI |

## Architecture (Electron)

```
src/
├── main/            # Main process (Node.js — file system, OS APIs)
│   ├── index.ts     # App entry, window management
│   ├── ipc/         # IPC handlers (main side)
│   └── services/    # Native services (file, tray, auto-update)
├── renderer/        # Renderer process (web UI — React)
│   ├── components/
│   ├── hooks/
│   └── pages/
└── shared/          # Types, constants dùng cả hai process
```

**IPC pattern (Electron):**
```typescript
// main/ipc/file-handler.ts
ipcMain.handle('read-file', async (_, path: string) => {
  return fs.readFile(path, 'utf-8')
})

// renderer — preload exposed API
window.api.readFile(path)  // NOT ipcRenderer.invoke trực tiếp
```

## Rules

- **IPC security:** contextIsolation: true, nodeIntegration: false — bắt buộc
- Expose OS API qua preload script, không dùng ipcRenderer trực tiếp trong renderer
- Main process: không import React; Renderer: không import fs/path trực tiếp
- Auto-updater: implement từ đầu nếu app sẽ distribute (electron-updater)
- Native menus: Application menu + context menu theo OS convention
- Window state persistence: lưu size/position vào electron-store

## Testing

- Unit test main process services (mock electron APIs)
- Unit test renderer components (Vitest + RTL)
- E2E: Playwright + electron driver cho critical flows
- Manual checklist: `docs/testing/manual-checklist.md` cho OS-specific behavior

## Build & Distribution

```bash
# Build
npm run build          # Compile TypeScript + bundle renderer
npm run make           # Package với electron-forge

# Artifacts
dist/                  # Compiled
out/                   # Packaged installers (.exe, .dmg, .deb)
```

- Sign app trước khi distribute (Windows: code signing cert, Mac: Apple notarization)
- .gitignore: `out/`, `dist/`, `*.dmg`, `*.exe`
