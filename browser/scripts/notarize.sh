#!/bin/bash
set -euo pipefail

DMG_PATH="${1:?Usage: notarize.sh <path-to-dmg>}"
TEAM_ID="QMM486NPYC"
BUNDLE_ID="com.nulljosh.browser"

if [ ! -f "$DMG_PATH" ]; then
    echo "ERROR: DMG not found: ${DMG_PATH}"
    exit 1
fi

echo "Submitting ${DMG_PATH} for notarization..."
xcrun notarytool submit "$DMG_PATH" \
    --team-id "$TEAM_ID" \
    --keychain-profile "notarization" \
    --wait

echo "Stapling notarization ticket..."
xcrun stapler staple "$DMG_PATH"

echo "Notarization complete."
