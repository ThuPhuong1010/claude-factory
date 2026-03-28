# Preset: Extension / Plugin

Load khi solution type = VSCode Extension, Browser Extension, App Plugin.

## VSCode Extension
- Stack: TypeScript + vscode API
- Entry: src/extension.ts (activate/deactivate exports)
- Manifest: package.json với contributes section
- Test: @vscode/test-electron

## Browser Extension
- Stack: TypeScript + WebExtensions API
- Manifest: manifest.json (v3 cho Chrome/Edge, v2 fallback Firefox)
- Structure: background/, content/, popup/, options/
- Build: webpack hoặc vite

## Rules
- Minimal permissions — chỉ request quyền thật sự cần
- Không inject unnecessary scripts
- Cleanup khi deactivate/uninstall
- Settings/config qua extension storage API, không hardcode

## Testing Extensions (thường không chạy trực tiếp trong CI)
Tạo docs/testing/test-scenarios.md:
```
## Manual Test Checklist
- [ ] Install từ source
- [ ] Activate command hoạt động
- [ ] Settings lưu/load đúng
- [ ] Uninstall clean (không còn artifacts)
- [ ] Test trên browser/editor version tối thiểu
```

## Build & Package
- VSCode: vsce package → .vsix
- Browser: zip dist/ → upload to store
- Ghi version bump process vào docs/
