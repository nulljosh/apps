# Spark

Version: v3.0.0

## Rules

- No emojis
- No build step -- everything runs from index.html
- Mobile-first layout
- Respect the existing visual language; keep UI minimal and fast to scan
- Seed data fallback when Supabase is unreachable

## Run

```bash
npx serve .
npm test
node daemon/spark-daemon.js --once   # test daemon manually
```

## Layout

Feed uses CSS grid (`repeat(auto-fill, minmax(320px, 1fr))`), 3-line content clamp. No box-shadows anywhere.

## Key Files

- index.html (all frontend: HTML + CSS + JS)
- api/posts.js (GET/POST posts, seed data fallback)
- api/enrich.js (POST=user requests enrichment, GET=daemon poll, PATCH=daemon writes)
- api/idea-base.js (POST=create ideabase, GET=list, PATCH=daemon updates post_ids)
- api/notes.js (GET=export post as markdown download)
- api/_lib/supabase.js (Supabase REST wrapper)
- daemon/spark-daemon.js (local Mac daemon: polls, runs CLAUDECODE="" claude --print, patches back)
- daemon/prompts.js (Claude prompt templates for enrichment + ideabase)
- daemon/notes.js (markdown export/import helpers)
- sw.js

## Daemon

- Runs every 5 min via LaunchAgent: `~/Library/LaunchAgents/com.spark.daemon.plist`
- Invokes: `CLAUDECODE="" claude --print "..."` (no API key -- uses Claude Max)
- Secret: `SPARK_DAEMON_SECRET` env var (set in Vercel + `~/.spark/daemon.env`)
- Logs: `~/.spark/daemon.log`
- Symlink: `~/.local/bin/spark-daemon -> daemon/spark-daemon.js`

## Load LaunchAgent

```bash
launchctl load ~/Library/LaunchAgents/com.spark.daemon.plist
launchctl list | grep spark
tail -f ~/.spark/daemon.log
```

## Set Vercel Env

```bash
vercel env add SPARK_DAEMON_SECRET
# value: ea2cf4d44dc578641c7375188a01a3133a501899ee03bfbb4829dfc8c78c6cf7
```

## Migration

Run `supabase/migrations/20260410000006_llm_enrichment.sql` via Supabase SQL editor.
