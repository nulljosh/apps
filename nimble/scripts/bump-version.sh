#!/usr/bin/env bash
# Usage: ./scripts/bump-version.sh 1.3.0
set -e

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

BASE="$(cd "$(dirname "$0")/.." && pwd)"
WEB="$BASE/../nimble-web"
IOS="$BASE/../nimble-ios"

# macOS
sed -i '' "s/MARKETING_VERSION: \".*\"/MARKETING_VERSION: \"$VERSION\"/" "$BASE/project.yml"
sed -i '' "s/version-v.*-blue/version-v$VERSION-blue/" "$BASE/README.md"
sed -i '' "s/^v[0-9].*/v$VERSION/" "$BASE/CLAUDE.md"

# iOS
sed -i '' "s/MARKETING_VERSION: \".*\"/MARKETING_VERSION: \"$VERSION\"/" "$IOS/project.yml"
sed -i '' "s/version-v.*-blue/version-v$VERSION-blue/" "$IOS/README.md"
sed -i '' "s/^v[0-9].*/v$VERSION/" "$IOS/CLAUDE.md"

# Web (semver major stays at 3.x, minor tracks feature releases)
# Edit package.json version manually or pass WEB_VERSION env override
WEB_VERSION="${WEB_VERSION:-}"
if [ -n "$WEB_VERSION" ]; then
  sed -i '' "s/\"version\": \".*\"/\"version\": \"$WEB_VERSION\"/" "$WEB/package.json"
  sed -i '' "s/version-v.*-blue/version-v$WEB_VERSION-blue/" "$WEB/README.md"
  sed -i '' "s/^v[0-9].*/v$WEB_VERSION/" "$WEB/CLAUDE.md"
fi

echo "Bumped nimble (macOS + iOS) to v$VERSION${WEB_VERSION:+ and nimble-web to v$WEB_VERSION}"
