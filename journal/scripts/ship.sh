#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# Lint: warn when a post's filename slug disagrees with the kebab-cased title.
# URLs are built from the filename slug (permalink /:year/:month/:day/:slug/),
# so a post titled "Cadence Ships" in 2026-04-13-week.md ships at /2026/04/13/week/
# not /2026/04/13/cadence-ships/. Surprising URL = broken share link.
for f in _posts/*.md; do
  base=$(basename "$f" .md)
  slug=${base#????-??-??-}
  title=$(sed -n 's/^title: *"\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' "$f" | head -1)
  title_slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//')
  if [ -n "$title_slug" ] && [ "$slug" != "$title_slug" ]; then
    echo "warn: $f slug '$slug' != title-slug '$title_slug' (URL will use filename)"
  fi
done

git add -A
git commit -m "deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
git push origin main
echo "pushed — CI building at https://github.com/nulljosh/journal/actions"
