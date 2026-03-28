---
name: desktop-app
description: "Desktop app Windows/Mac/Linux với Electron hoặc Tauri. Trigger khi solution cần chạy native trên máy tính."
---

# Desktop App

## Option A: Electron + React (JS ecosystem, easiest)
```bash
npm create electron-vite@latest -- --template react-ts
cd my-app && npm install && npm run dev
```

**Structure:**
```
src/
├── main/        # Main process (Node.js)
│   └── index.ts
├── preload/     # Bridge script
│   └── index.ts
└── renderer/    # React UI
    └── src/
```

**IPC (Main ↔ Renderer):**
```ts
// preload/index.ts
import { contextBridge, ipcRenderer } from 'electron';
contextBridge.exposeInMainWorld('api', {
  readFile: (path: string) => ipcRenderer.invoke('read-file', path),
  saveFile: (path: string, data: string) => ipcRenderer.invoke('save-file', path, data),
});

// main/index.ts
ipcMain.handle('read-file', (_, path) => fs.readFileSync(path, 'utf-8'));

// renderer
const content = await window.api.readFile('/path/to/file');
```

**Build:**
```bash
npm run build        # Build app
npm run build:win    # Windows .exe
npm run build:mac    # Mac .dmg
npm run build:linux  # Linux .AppImage
```

---

## Option B: Tauri + React (Rust backend, smaller binary)
```bash
npm create tauri-app@latest
```
- Bundle size: ~3MB vs Electron ~150MB
- Memory: ~30MB vs Electron ~100MB+
- Cần Rust toolchain

---

## Option C: Python + GUI (nhanh cho scripts)

### Tkinter (built-in, simple)
```python
import tkinter as tk
from tkinter import filedialog, messagebox

root = tk.Tk()
root.title("My App")
root.geometry("600x400")

btn = tk.Button(root, text="Open File", command=lambda: filedialog.askopenfilename())
btn.pack(pady=10)

root.mainloop()
```

### PyQt6 / PySide6 (pro-level UI)
```bash
pip install PyQt6
```

### Packaging Python App
```bash
pip install pyinstaller
pyinstaller --onefile --windowed main.py  # → dist/main.exe
```

---

## System Tray App (background app)
```bash
pip install pystray pillow  # Python
# hoặc dùng Electron Tray API
```

---

## Khi nào dùng gì
| Use case | Tool |
|---------|------|
| Complex UI, web dev team | Electron |
| Performance, small binary | Tauri |
| Simple tool, Python codebase | PyInstaller + Tkinter/PyQt |
| System tray utility | Electron Tray / pystray |
