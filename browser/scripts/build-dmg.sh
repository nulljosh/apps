#!/bin/bash
set -euo pipefail

APP_NAME="Browser"
VERSION="${1:-2.0.0}"
BUILD_DIR="build"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
STAGING_DIR="${BUILD_DIR}/dmg-staging"

echo "Building ${APP_NAME} v${VERSION}..."

cd "$(dirname "$0")/.."

xcodegen generate
xcodebuild -scheme Browser -configuration Release -derivedDataPath "${BUILD_DIR}/derived" build

APP_PATH=$(find "${BUILD_DIR}/derived" -name "${APP_NAME}.app" -type d | head -1)
if [ -z "$APP_PATH" ]; then
    echo "ERROR: ${APP_NAME}.app not found"
    exit 1
fi

echo "Creating DMG..."
rm -rf "${STAGING_DIR}"
mkdir -p "${STAGING_DIR}"
cp -R "$APP_PATH" "${STAGING_DIR}/"
ln -s /Applications "${STAGING_DIR}/Applications"

rm -f "${BUILD_DIR}/${DMG_NAME}"
hdiutil create -volname "${APP_NAME}" -srcfolder "${STAGING_DIR}" -ov -format UDZO "${BUILD_DIR}/${DMG_NAME}"

rm -rf "${STAGING_DIR}"
echo "DMG created: ${BUILD_DIR}/${DMG_NAME}"
