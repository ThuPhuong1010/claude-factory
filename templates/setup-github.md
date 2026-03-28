# Setup Guide: GitHub + Claude Code (Windows)

Hướng dẫn setup lần đầu khi clone/tạo project mới trên Windows.

---

## 1. Cài GitHub CLI (gh)

```powershell
# Mở Windows Terminal (PowerShell) với quyền admin
winget install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements
```

> Sau khi cài, **mở terminal mới** để PATH được load.

---

## 2. Login GitHub CLI

**QUAN TRỌNG:** Dùng `&` khi gọi executable có space trong path trên PowerShell.

```powershell
# PowerShell (dùng & để invoke)
& "C:\Program Files\GitHub CLI\gh.exe" auth login

# Hoặc nếu đã có trong PATH (terminal mới sau khi cài)
gh auth login
```

Chọn theo thứ tự:
1. `GitHub.com`
2. `HTTPS`
3. `Yes` (Authenticate Git with GitHub credentials)
4. `Login with a web browser`

Copy one-time code → Enter → browser mở → paste code → Done.

Kiểm tra đã login:
```powershell
gh auth status
# ✓ Logged in as <username>
```

---

## 3. Tạo GitHub Repo từ local

```bash
# Trong Git Bash hoặc terminal của project
export PATH="$PATH:/c/Program Files/GitHub CLI"

gh repo create <repo-name> \
  --public \
  --description "<mô tả project>" \
  --source=. \
  --remote=origin \
  --push
```

Flags:
- `--public` / `--private` — visibility
- `--source=.` — dùng folder hiện tại
- `--remote=origin` — tự set remote origin
- `--push` — push luôn sau khi tạo

---

## 4. Push lần đầu (nếu repo đã tồn tại)

```bash
git remote add origin https://github.com/<username>/<repo-name>.git
git branch -M main
git push -u origin main
```

---

## 5. PowerShell Syntax — Lưu ý

| Tình huống | Sai | Đúng |
|-----------|-----|------|
| Invoke exe có space trong path | `"C:\Program Files\gh.exe" args` | `& "C:\Program Files\gh.exe" args` |
| Chạy script .ps1 | `.\script.ps1` (có thể bị blocked) | `powershell -ExecutionPolicy Bypass -File .\script.ps1` |
| Variable trong string | `"$HOME\file"` (được expand) | `'$HOME\file'` (literal, không expand) |

---

## 6. PATH trong Git Bash

Git Bash không tự load PATH của Windows. Với các tool cài qua winget:

```bash
# Thêm vào ~/.bashrc để tự động load
echo 'export PATH="$PATH:/c/Program Files/GitHub CLI"' >> ~/.bashrc

# Hoặc thêm tạm trong session
export PATH="$PATH:/c/Program Files/GitHub CLI"
```

---

## 7. Claude Code settings — bypassPermissions

Sau khi setup project, set ngay để Claude không hỏi quyền:

```json
// .claude/settings.json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": ["Bash(*)", "Read", "Write", "Edit", "Glob", "Grep", "WebFetch", "WebSearch", "mcp__*", "Agent"],
    "deny": ["Bash(rm -rf /)", "Bash(rm -rf ~)", "Bash(sudo *)", "Bash(git push --force*)"]
  }
}
```

**Lưu ý:** Setting này chỉ có hiệu lực sau khi **restart Claude Code session**.

Để áp dụng global (mọi project), set tương tự vào `~/.claude/settings.json`.

---

## 8. Notification khi Claude xong task

Setup Stop hook để nhận Windows notification:

```json
// .claude/settings.json — thêm vào hooks
"hooks": {
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": "powershell.exe -ExecutionPolicy Bypass -File '.claude\\notify.ps1'",
      "async": true
    }]
  }]
}
```

Script `.claude/notify.ps1`:
```powershell
Add-Type -AssemblyName System.Windows.Forms
$n = New-Object System.Windows.Forms.NotifyIcon
$n.Icon = [System.Drawing.SystemIcons]::Information
$n.BalloonTipTitle = "Claude Code"
$n.BalloonTipText = "Done! Quay lai xem ket qua nhe."
$n.Visible = $True
$n.ShowBalloonTip(8000)
Start-Sleep 2
$n.Dispose()
```
