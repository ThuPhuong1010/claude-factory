---
name: browser-extension
description: "Chrome/Firefox browser extension. Trigger khi solution cần modify web pages, intercept requests, hoặc add browser UI."
---

# Browser Extension

## Manifest V3 (Chrome/Edge — required)
```json
{
  "manifest_version": 3,
  "name": "My Extension",
  "version": "1.0.0",
  "description": "...",
  "permissions": ["storage", "activeTab"],
  "host_permissions": ["https://*.example.com/*"],
  "background": { "service_worker": "background.js" },
  "content_scripts": [{
    "matches": ["https://*.example.com/*"],
    "js": ["content.js"]
  }],
  "action": { "default_popup": "popup.html" },
  "options_page": "options.html"
}
```

## Structure
```
extension/
├── manifest.json
├── background.js      # Service worker (background logic)
├── content.js         # Injected into pages
├── popup/
│   ├── popup.html
│   └── popup.js
├── options/
└── icons/
```

## Component Roles
| File | Runs where | Can access |
|------|-----------|-----------|
| background.js | Browser background | chrome.* APIs, fetch |
| content.js | Inside webpage | DOM, limited chrome.* |
| popup.js | Popup window | chrome.* APIs, fetch |

## Storage
```js
// Save
await chrome.storage.local.set({ key: 'value' });
await chrome.storage.sync.set({ setting: true }); // sync across devices

// Read
const { key } = await chrome.storage.local.get('key');
```

## Message Passing
```js
// content.js → background.js
const response = await chrome.runtime.sendMessage({ action: 'fetchData', url });

// background.js listens
chrome.runtime.onMessage.addListener((msg, sender, reply) => {
  if (msg.action === 'fetchData') {
    fetch(msg.url).then(r => r.json()).then(data => reply({ data }));
    return true; // async reply
  }
});
```

## Content Script — DOM Manipulation
```js
// Inject UI vào trang
const div = document.createElement('div');
div.id = 'my-extension-ui';
div.innerHTML = '<button id="my-btn">Click me</button>';
document.body.appendChild(div);

// Observe DOM changes
const observer = new MutationObserver((mutations) => { /* ... */ });
observer.observe(document.body, { childList: true, subtree: true });
```

## Build với TypeScript + Vite
```bash
# Template: crxjs
npm create crxjs-vite@latest
```

## Load & Test
1. Chrome → `chrome://extensions/`
2. Enable "Developer mode"
3. "Load unpacked" → chọn folder
4. Sau khi sửa code → click refresh icon

## Minimal Permissions Principle
Chỉ request permissions thực sự cần. Chrome Web Store review rất nghiêm về permissions.

## Package & Publish
```bash
# Zip dist/ folder
zip -r extension.zip dist/
# Upload to Chrome Web Store Developer Dashboard
```
