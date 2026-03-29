# Preset: Extension / Plugin

Load khi solution type = VSCode Extension, Browser Extension, App Plugin.

## VSCode Extension

**Stack:** TypeScript + VS Code Extension API

```
src/
├── extension.ts         # Entry: activate() + deactivate()
├── commands/            # Command handlers (1 file per command)
├── providers/           # TreeDataProvider, WebviewProvider, etc.
├── services/            # Business logic (không phụ thuộc VS Code API)
└── utils/               # Helpers
```

**Rules:**
- `activate()` — register commands, providers. Không làm heavy work ở đây.
- `deactivate()` — cleanup disposables (listeners, watchers, connections)
- Dùng `context.subscriptions.push(...)` cho mọi disposable
- Settings qua `vscode.workspace.getConfiguration('extensionName')`
- Không block extension host — async cho mọi I/O

```typescript
export function activate(context: vscode.ExtensionContext) {
  const disposable = vscode.commands.registerCommand('ext.hello', async () => {
    try {
      await doWork()
      vscode.window.showInformationMessage('Done!')
    } catch (e) {
      vscode.window.showErrorMessage(`Error: ${e.message}`)
    }
  })
  context.subscriptions.push(disposable)
}
```

**Build & Package:**
```bash
npm run compile    # TypeScript → JS
vsce package       # Tạo .vsix
vsce publish       # Publish lên Marketplace
```

---

## Browser Extension

**Stack:** TypeScript + WebExtensions API, Manifest V3

```
src/
├── background/          # Service Worker (MV3) — long-running logic
├── content/             # Content scripts — DOM interaction
├── popup/               # Toolbar popup UI
├── options/             # Extension settings page
└── shared/              # Types, utils dùng chung
manifest.json            # MV3 manifest
```

**Rules:**
- Manifest V3: background = Service Worker (không persistent, không DOM access)
- Content scripts: inject tối thiểu, cleanup khi navigate away
- Messaging: `chrome.runtime.sendMessage` / `chrome.tabs.sendMessage`
- Storage: `chrome.storage.local` (local) hoặc `chrome.storage.sync` (cross-device)
- Permissions: chỉ request minimum cần thiết — reviewer sẽ reject nếu overkill

```typescript
// Background service worker
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'FETCH_DATA') {
    fetchData(message.url).then(sendResponse)
    return true  // async response
  }
})
```

**Build:**
```bash
npm run build              # Bundle với webpack/vite
web-ext lint               # Lint manifest + code
web-ext build              # Tạo .zip cho submission
```

---

## Universal Extension Rules

- **Minimal permissions** — chỉ request quyền thật sự dùng. Justify từng permission.
- **Không inject unnecessary scripts** — chỉ content script khi page match pattern
- **Cleanup khi deactivate/uninstall** — xóa storage entries, remove event listeners
- **Error handling**: mọi async operation có try/catch + user-visible feedback
- **Version bump**: update version trong `package.json` + `manifest.json` đồng bộ

## Testing

```bash
# VSCode Extension
npm run test                        # @vscode/test-electron
code --extensionDevelopmentPath=.   # F5 để debug

# Browser Extension
web-ext run --browser firefox       # Live reload trong Firefox
```

Manual checklist `docs/testing/manual-checklist.md`:
```
- [ ] Install từ source (unpacked)
- [ ] Mọi command/action hoạt động đúng
- [ ] Settings lưu/load đúng
- [ ] Không có console errors khi dùng bình thường
- [ ] Uninstall không để lại artifacts
- [ ] Test trên browser/editor version tối thiểu được support
- [ ] Permissions prompt hiện đúng (browser extension)
```
