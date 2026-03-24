# Rabbit 2.0 Deployment Guide

## Frontend (Vercel)

### Quick Deploy
```bash
npm install -g vercel
vercel
```

Follow prompts:
- Connect GitHub repo: `nulljosh/rabbit`
- Framework: Vite
- Build command: `npm run build`
- Output directory: `dist`
- Environment: Add `VITE_API_URL` (see below)

### Environment Variables
In Vercel dashboard, set:
```
VITE_API_URL=http://localhost:3001
```

(In production, you can update this to a cloud indexer URL later. For now, users run indexer locally.)

### Vercel Config
`vercel.json` is already in repo. Deploy with:
```bash
vercel --prod
```

Live at: https://rabbit-lyart.vercel.app

## Backend (Local Indexer)

### Setup on Your Mac

1. **Clone repo** (if not already)
```bash
git clone https://github.com/nulljosh/rabbit.git ~/Documents/Code/rabbit
cd ~/Documents/Code/rabbit
```

2. **Install dependencies**
```bash
npm install
cd backend
npm install
cd ..
```

3. **Start indexer**
```bash
npm run index
```

Runs on `http://localhost:3001`. Watches current directory for file changes.

4. **Test API**
```bash
curl http://localhost:3001/health
```

Should return: `{ "status": "ok", "stats": { ... } }`

### Configuration

Create `.env.local` in rabbit root:
```
VITE_API_URL=http://localhost:3001
```

### First Index

Indexer auto-crawls current directory on startup. To index a specific path:

```bash
curl -X POST http://localhost:3001/api/reindex -H "Content-Type: application/json" -d '{"dir": "~/Documents"}'
```

### Keep Running

For development:
```bash
npm run index:dev   # Auto-reload on code change
```

For production (background daemon):
```bash
nohup npm run index > indexer.log 2>&1 &
```

Or use a process manager (pm2, systemd, launchd on macOS).

### macOS LaunchAgent (Optional)

Create `~/Library/LaunchAgents/com.rabbit.indexer.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.rabbit.indexer</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/npm</string>
        <string>run</string>
        <string>index</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/joshua/Documents/Code/rabbit</string>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/joshua/Library/Logs/rabbit-indexer.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/joshua/Library/Logs/rabbit-indexer.log</string>
</dict>
</plist>
```

Then:
```bash
launchctl load ~/Library/LaunchAgents/com.rabbit.indexer.plist
launchctl start com.rabbit.indexer
```

Check status:
```bash
launchctl list | grep rabbit
```

## Troubleshooting

### Frontend not finding API
- Check `VITE_API_URL` env var in Vercel dashboard
- Make sure indexer is running on your Mac
- Browser console should show API errors if indexer is down

### Indexer not finding files
- Verify you're in the right directory when you run `npm run index`
- Check that files aren't in ignored paths: `.git`, `node_modules`, `.vercel`, `dist`
- Run `/api/reindex` with explicit directory

### File changes not being picked up
- Chokidar file watcher has limits on Linux. On macOS should work fine.
- If stuck, restart indexer: `npm run index`

---

Frontend is live. Indexer runs on your Mac. Have fun. 🚀
