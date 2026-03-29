Pre-deploy validation. Đọc context/techstack.md trước → chạy checklist phù hợp với solution type.

---

## Universal (mọi solution type)

- [ ] `.env.example` tồn tại và có đủ mọi biến cần thiết
- [ ] Không có hardcoded secret, API key, password trong code
- [ ] `README.md` có: mô tả, install steps, run steps
- [ ] Không có debug output / console.log còn sót trong production code
- [ ] `docs/guides/how-to-run.md` đã được tạo và accurate

---

## Web App / API (Node.js / Next.js)

- [ ] `npm test` → tất cả pass
- [ ] `npm run build` → SUCCESS
- [ ] `npm audit` → không có critical vulnerabilities
- [ ] Không có hardcoded `localhost` URL trong code (dùng env var)
- [ ] Error pages (404, 500) tồn tại và hoạt động
- [ ] Database migrations đã chạy / chuẩn bị sẵn
- [ ] CORS config đúng (không dùng `*` trên production)
- [ ] Rate limiting bật trên auth endpoints

## Python App / Script / Bot

- [ ] `pytest` hoặc `python -m pytest` → tất cả pass
- [ ] `pip freeze > requirements.txt` đã cập nhật
- [ ] `pip audit` hoặc `safety check` → không có critical
- [ ] Entry point chạy được: `python main.py --help`
- [ ] Tất cả env vars được validate khi startup
- [ ] Không có `print()` debug còn sót (dùng `logging`)

## CLI Tool

- [ ] `--help` output đầy đủ và chính xác
- [ ] `--dry-run` hoạt động đúng
- [ ] Exit codes đúng (0 success, 1 error, 2 usage)
- [ ] Binary/entrypoint chạy được trên target OS
- [ ] Distribution package build thành công (`npm pack` / `pip wheel`)

## Desktop App (Electron/Tauri)

- [ ] App launch không có console errors
- [ ] Tất cả IPC handlers hoạt động
- [ ] Auto-updater config đúng (nếu có)
- [ ] Installer build thành công (`npm run make`)
- [ ] Code signing setup (nếu distribute public)

## Mobile App (React Native/Expo)

- [ ] `expo doctor` → không có warnings nghiêm trọng
- [ ] Build thành công: `eas build --platform all --profile preview`
- [ ] Không có native module conflict
- [ ] App icon + splash screen đúng
- [ ] Deep link scheme không conflict

## Extension (VSCode / Browser)

- [ ] Manifest version bump
- [ ] Tất cả permissions trong manifest có lý do
- [ ] Package build thành công (`vsce package` / `web-ext build`)
- [ ] Install from local source và test thủ công

## Automation / Workflow

- [ ] Dry-run đã chạy thành công
- [ ] Error/retry handlers đã test
- [ ] Webhook URLs đúng (staging vs production)
- [ ] Credentials trong secret store (không trong workflow file)
- [ ] Trigger conditions đúng (không trigger sai)

---

Output format:
```
DEPLOY STATUS: READY ✅ / NOT READY ❌

Passed: X/Y checks
Failed:
  - [check nào fail + lý do]
  - ...

Next: [action cần làm trước khi deploy]
```
