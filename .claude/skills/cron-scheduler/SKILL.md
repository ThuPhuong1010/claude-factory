---
name: cron-scheduler
description: "Scheduled tasks, cron jobs, recurring automation. Trigger khi cần chạy task theo lịch, định kỳ, hoặc sau một khoảng thời gian."
---

# Cron & Scheduled Tasks

## Node.js — node-cron
```bash
npm install node-cron
```
```js
const cron = require('node-cron');

// Chạy mỗi ngày lúc 8:00 sáng
cron.schedule('0 8 * * *', async () => {
  try {
    await runTask();
    console.log(`[${new Date().toISOString()}] Task completed`);
  } catch (err) {
    console.error('Task failed:', err);
    // RAISE: notify nếu cần (email, Slack, etc.)
  }
}, { timezone: 'Asia/Ho_Chi_Minh' });
```

Cron expression: `* * * * *` = minute hour day month weekday
```
┌─── minute (0-59)
│ ┌─── hour (0-23)
│ │ ┌─── day of month (1-31)
│ │ │ ┌─── month (1-12)
│ │ │ │ ┌─── day of week (0-7, 0&7=Sunday)
* * * * *
```
Ví dụ:
- `0 8 * * 1-5` — 8:00 sáng thứ 2-6
- `*/15 * * * *` — mỗi 15 phút
- `0 0 1 * *` — đầu mỗi tháng

## Python — schedule
```bash
pip install schedule
```
```python
import schedule
import time

def job():
    print("Running task...")

schedule.every().day.at("08:00").do(job)
schedule.every(15).minutes.do(job)
schedule.every().monday.at("09:00").do(job)

while True:
    schedule.run_pending()
    time.sleep(60)
```

## Python — APScheduler (production-grade)
```bash
pip install apscheduler
```
```python
from apscheduler.schedulers.blocking import BlockingScheduler

scheduler = BlockingScheduler(timezone='Asia/Ho_Chi_Minh')

@scheduler.scheduled_job('cron', hour=8, minute=0)
def morning_job():
    run_task()

scheduler.start()
```

## System Cron (Linux/Mac)
```bash
crontab -e
# 0 8 * * * /usr/bin/python3 /path/to/script.py >> /var/log/task.log 2>&1
```

## Windows Task Scheduler
```powershell
# Tạo task chạy mỗi ngày lúc 8:00
schtasks /create /tn "MyTask" /tr "python C:\scripts\task.py" /sc daily /st 08:00
```

## Best Practices
- Luôn log: timestamp, duration, result/error
- Idempotent: chạy nhiều lần = kết quả giống nhau
- Lock file để tránh chạy concurrent: dùng `filelock` (Python) hoặc check PID
- Graceful shutdown: handle SIGTERM
- Retry logic với exponential backoff cho external calls
- Health check endpoint nếu deploy lên server

## Deployment Options
| Option | Phù hợp |
|--------|---------|
| Process trên server (systemd) | Long-running Python/Node |
| Docker + restart policy | Container-based |
| GitHub Actions schedule | Không cần server |
| AWS Lambda + EventBridge | Serverless |
| Railway / Render cron | PaaS đơn giản |
