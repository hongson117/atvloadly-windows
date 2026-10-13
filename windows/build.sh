#!/usr/bin/env bash
# Build atvloadly for Windows x64 (cross-compiled on Linux) + plumesign.exe + the
# portable zip and the NSIS installer.
#
# Requirements (Debian/Ubuntu): golang >= 1.25 (or GOTOOLCHAIN=auto), nodejs/npm,
#   gcc-mingw-w64-x86-64, rustup (stable) with target x86_64-pc-windows-gnu,
#   cmake, nasm, nsis (makensis), git, python3.
# Output: windows/dist/atvloadly-setup.exe, windows/dist/atvloadly-windows.zip, SHA256SUMS.txt
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WIN="$ROOT/windows"
DIST="$WIN/dist"
WORK="$WIN/.work"
PLUME_REPO="https://github.com/bitxeno/PlumeImpactor"
PLUME_TAG="v2.2.3-patch.8"
export GOTOOLCHAIN="${GOTOOLCHAIN:-auto}"
export PATH="$HOME/.cargo/bin:$PATH"

rm -rf "$DIST" && mkdir -p "$DIST" "$WORK"

echo "==> frontend"
(cd "$ROOT/web/static" && npm install && npm run build)

echo "==> atvloadly.exe (CGO via mingw-w64: needed by github.com/blacktop/lzfse-cgo)"
VERSION="$(cd "$ROOT" && git describe --tags --always)-win"
PKG=github.com/bitxeno/atvloadly/internal/app/build
(cd "$ROOT" && CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 \
  go build -trimpath -ldflags "-w -s -X $PKG.Version=$VERSION -X $PKG.BuildDate=$(date +%F) -X $PKG.Commit=$(git rev-parse HEAD) -X $PKG.Mode=production" \
  -o "$WORK/atvloadly.exe" .)

echo "==> plumesign.exe from $PLUME_REPO $PLUME_TAG (unmodified)"
if [ ! -d "$WORK/PlumeImpactor" ]; then
  git clone --branch "$PLUME_TAG" --depth 1 "$PLUME_REPO" "$WORK/PlumeImpactor"
fi
(cd "$WORK/PlumeImpactor" && \
  sed -i -E '/^\[workspace\.package\]/,/^\[/ s/^version = ".*"/version = "'"${PLUME_TAG#v}"'"/' Cargo.toml && \
  cargo build --release -p plumesign --target x86_64-pc-windows-gnu)
cp "$WORK/PlumeImpactor/target/x86_64-pc-windows-gnu/release/plumesign.exe" "$WORK/plumesign.exe"
cp "$WORK/PlumeImpactor/LICENSE" "$WORK/PlumeImpactor-LICENSE-MIT.txt"

common_files() { # $1 = destination dir
  mkdir -p "$1/licenses" "$1/source"
  cp "$WORK/atvloadly.exe" "$WORK/plumesign.exe" "$1/"
  cp "$ROOT/LICENSE" "$1/licenses/atvloadly-LICENSE-AGPL3.txt"
  cp "$WORK/PlumeImpactor-LICENSE-MIT.txt" "$1/licenses/"
  cp "$WIN/patches/atvloadly-windows.patch" "$1/source/"
  printf 'atvloadly source: https://github.com/hongson117/atvloadly-windows (fork of https://github.com/bitxeno/atvloadly), commit %s\r\nplumesign built from: %s tag %s, unmodified, target x86_64-pc-windows-gnu\r\n' \
    "$(cd "$ROOT" && git rev-parse HEAD)" "$PLUME_REPO" "$PLUME_TAG" > "$1/source/SOURCE.txt"
  (cd "$1" && sha256sum atvloadly.exe plumesign.exe > SHA256SUMS.txt)
}

echo "==> portable zip"
P="$WORK/portable/atvloadly-windows"; rm -rf "$WORK/portable"; mkdir -p "$P/data" "$P/scripts"
common_files "$P"
cp "$WIN"/portable/{start.bat,start-hidden.vbs,install-autostart.bat,remove-autostart.bat,firewall-allow.bat} "$WIN/launcher/stop.bat" "$P/"
cp "$WIN/portable/config.yaml" "$P/data/config.yaml"
cp "$WIN/portable/setup-anisette.ps1" "$P/scripts/"
cp "$WIN/portable/README_VI.txt" "$P/README_VI.txt" 2>/dev/null || cp "$WIN/launcher/README_VI.txt" "$P/README_VI.txt"
cp "$WIN/portable/README_EN.txt" "$P/README_EN.txt" 2>/dev/null || cp "$WIN/launcher/README_EN.txt" "$P/README_EN.txt"
(cd "$WORK/portable" && python3 -c "import shutil; shutil.make_archive('$DIST/atvloadly-windows','zip','.','atvloadly-windows')")

echo "==> installer"
I="$WIN/installer/payload"; rm -rf "$I"; mkdir -p "$I/scripts"
common_files "$I"
cp "$WIN"/launcher/{atvloadly.vbs,stop.bat,README_VI.txt,README_EN.txt} "$I/"
cp "$WIN/launcher/setup-anisette.ps1" "$I/scripts/"
(cd "$WIN/installer" && makensis -V2 -DOUTFILE="$DIST/atvloadly-setup.exe" atvloadly.nsi)
rm -rf "$I"

(cd "$DIST" && sha256sum atvloadly-setup.exe atvloadly-windows.zip > SHA256SUMS.txt && cat SHA256SUMS.txt)
