---
name: vscode-extension
description: "VSCode extension — commands, sidebar, language support, snippets, themes. Trigger khi solution là VSCode plugin."
---

# VSCode Extension

## Setup
```bash
npm install -g yo generator-code
yo code  # chọn "New Extension (TypeScript)"
cd my-extension && npm install
```

## Structure
```
src/
└── extension.ts    # activate() + deactivate()
package.json        # contributes, activationEvents
```

## package.json — Key Fields
```json
{
  "activationEvents": ["onCommand:myext.hello"],
  "main": "./out/extension.js",
  "contributes": {
    "commands": [{
      "command": "myext.hello",
      "title": "Hello World"
    }],
    "keybindings": [{
      "command": "myext.hello",
      "key": "ctrl+alt+h"
    }],
    "configuration": {
      "properties": {
        "myext.setting": { "type": "string", "default": "value" }
      }
    },
    "menus": {
      "editor/context": [{
        "command": "myext.hello",
        "when": "editorHasSelection"
      }]
    }
  }
}
```

## extension.ts Patterns

### Command
```typescript
import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {
  const cmd = vscode.commands.registerCommand('myext.hello', async () => {
    const editor = vscode.window.activeTextEditor;
    if (!editor) return;

    const selection = editor.document.getText(editor.selection);
    const result = await processText(selection);

    // Replace selection
    await editor.edit(eb => eb.replace(editor.selection, result));
    vscode.window.showInformationMessage('Done!');
  });

  context.subscriptions.push(cmd);
}

export function deactivate() {}
```

### Status Bar
```typescript
const statusBar = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, 100);
statusBar.text = '$(sync) Processing...';
statusBar.show();
context.subscriptions.push(statusBar);
```

### Webview Panel (custom UI)
```typescript
const panel = vscode.window.createWebviewPanel('myView', 'My Panel',
  vscode.ViewColumn.One, { enableScripts: true });

panel.webview.html = `<html><body><h1>Hello!</h1></body></html>`;
panel.webview.onDidReceiveMessage(msg => { /* handle */ }, undefined, context.subscriptions);
panel.webview.postMessage({ type: 'update', data });
```

### TreeView (Sidebar)
```typescript
class MyProvider implements vscode.TreeDataProvider<MyItem> {
  getTreeItem(element: MyItem): vscode.TreeItem { return element; }
  getChildren(): MyItem[] { return [new MyItem('Item 1')]; }
}
vscode.window.registerTreeDataProvider('myView', new MyProvider());
```

### Read Config
```typescript
const config = vscode.workspace.getConfiguration('myext');
const value = config.get<string>('setting', 'default');
```

## Run & Debug
```
F5 → launches Extension Development Host
```

## Package & Publish
```bash
npm install -g @vscode/vsce
vsce package          # → my-extension-1.0.0.vsix
vsce publish          # publish to marketplace (cần PAT)
# Install locally:
code --install-extension my-extension-1.0.0.vsix
```
