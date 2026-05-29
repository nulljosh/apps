#!/usr/bin/env bash
# Deploy apps/brief/web -> nulljosh.github.io/brief (live heyitsmejosh.com/brief).
# Idempotent: only bumps cache + commits + pushes when web CONTENT actually changed.
# Run manually, or let the apps pre-push hook run it automatically.
set -euo pipefail
export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8   # BSD sed chokes on em-dashes under C locale

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"          # apps/brief/web
DEST="$(cd "$SRC/../../../nulljosh.github.io/brief" && pwd)" # portfolio deploy folder
PORTFOLIO="$(cd "$DEST/.." && pwd)"                          # nulljosh.github.io repo root
FILES=(index.html script.js style.css sw.js manifest.json icon.svg apple-touch-icon.png)

# Syntax gate — never ship a script.js that won't parse.
node --check "$SRC/script.js"

# Content fingerprint (version stamps stripped) — skip if nothing changed since last deploy.
# Text files get version-stripped + hashed; binary (png) is hashed as-is (sed can't read it).
TEXT=(index.html script.js style.css sw.js manifest.json icon.svg)
FP=$( { cat "${TEXT[@]/#/$SRC/}" | sed -E 's/v=[0-9]+//g; s/brief-v[0-9]+//g'; md5 -q "$SRC/apple-touch-icon.png"; } | md5 -q)
if [ -f "$DEST/.deployhash" ] && [ "$(cat "$DEST/.deployhash")" = "$FP" ]; then
  echo "brief: no content change, skipping deploy"; exit 0
fi

# Next cache version = current live ?v=N + 1.
CUR=$(grep -oE 'script\.js\?v=[0-9]+' "$DEST/index.html" | grep -oE '[0-9]+' | head -1 || echo 0)
N=$(( CUR + 1 ))

for f in "${FILES[@]}"; do cp "$SRC/$f" "$DEST/$f"; done
sed -i '' -E "s/(style\.css\?v=)[0-9]+/\1$N/; s/(script\.js\?v=)[0-9]+/\1$N/" "$DEST/index.html"
sed -i '' -E "s/(brief-v)[0-9]+/\1$N/g; s/(\?v=)[0-9]+/\1$N/g" "$DEST/sw.js"
echo "$FP" > "$DEST/.deployhash"

node --check "$DEST/script.js"
cd "$PORTFOLIO"
git add brief/
git commit -m "chore(brief): auto-deploy web v$N"
git push
echo "brief: deployed v$N -> heyitsmejosh.com/brief"
