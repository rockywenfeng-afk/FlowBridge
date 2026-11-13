#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"
CACHE="$ROOT/.vendor-cache"
VERSION=4.1
APP_VERSION=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$ROOT/macOS/Info.plist")
INTEL_ARCHIVE="$CACHE/scrcpy-x86_64-v$VERSION.tar.gz"
mkdir -p "$CACHE"

download_and_verify() {
  url=$1
  output=$2
  expected=$3
  if [ ! -f "$output" ]; then curl -fL "$url" -o "$output"; fi
  actual=$(shasum -a 256 "$output" | awk '{print $1}')
  if [ "$actual" != "$expected" ]; then
    echo "Checksum mismatch: $output" >&2
    exit 1
  fi
}

download_and_verify \
  "https://github.com/Genymobile/scrcpy/releases/download/v$VERSION/scrcpy-macos-x86_64-v$VERSION.tar.gz" \
  "$INTEL_ARCHIVE" \
  "ee2a7223bc8dbdc4f482db1134bcf441178dafb833492b71ca4c22090c58ce72"

swift build -c release --arch x86_64
APP="$ROOT/dist/Flow Bridge.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$ROOT/.build/x86_64-apple-macosx/release/DXManagerMac" "$APP/Contents/MacOS/DXManagerMac"
cp "$ROOT/macOS/Info.plist" "$APP/Contents/Info.plist"
cp "$ROOT/macOS/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"
cp "$ROOT/LICENSE" "$APP/Contents/Resources/FlowBridge-LICENSE.txt"
cp "$ROOT/licenses/DX-MANAGER-MIT.txt" "$APP/Contents/Resources/DX-Manager-MIT-LICENSE.txt"
cp -R "$ROOT/macOS/Resources/en.lproj" "$APP/Contents/Resources/"
cp -R "$ROOT/macOS/Resources/ko.lproj" "$APP/Contents/Resources/"
cp "$ROOT/DexManager/licenses/THIRD_PARTY_NOTICES.md" "$APP/Contents/Resources/THIRD_PARTY_NOTICES.md"
mkdir -p "$APP/Contents/Resources/runtime/x86_64"
tar -xzf "$INTEL_ARCHIVE" --strip-components=1 -C "$APP/Contents/Resources/runtime/x86_64"
chmod +x "$APP/Contents/Resources/runtime/x86_64/adb" "$APP/Contents/Resources/runtime/x86_64/scrcpy"
codesign --force --deep --sign - "$APP"
rm -f "$ROOT/dist/FlowBridge-Monterey-Intel-v$APP_VERSION.zip"
ditto -c -k --sequesterRsrc --keepParent "$APP" "$ROOT/dist/FlowBridge-macOS-universal-v$APP_VERSION.zip"
echo "$APP"

