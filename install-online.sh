#!/bin/sh
# REFFIX Monokai Pro for LuCI installer: OpenWrt 25.12 / APK.
set -eu

REPO="REFFIX-X/luci-theme-footstrap"
FALLBACK_VERSION="v2.0.0"
PACKAGE="reffix-luci-theme-footstrap-openwrt-25.12.apk"
SUMS="SHA256SUMS-openwrt-25.12.txt"
TMP="/tmp/reffix-theme-install.$$"
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT INT TERM

fetch() {
  url="$1"
  dest="$2"
  if command -v uclient-fetch >/dev/null 2>&1; then
    uclient-fetch -q -O "$dest" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$dest" "$url"
  else
    echo "ERROR: install uclient-fetch or wget first." >&2
    return 1
  fi
}

command -v apk >/dev/null 2>&1 || {
  echo "ERROR: this release requires OpenWrt 25.12/APK. IPK/opkg is not supported." >&2
  exit 1
}

if [ -r /etc/openwrt_release ]; then . /etc/openwrt_release; fi
case "${DISTRIB_RELEASE:-}:${DISTRIB_TARGET:-}" in
  25.12*:*) ;;
  SNAPSHOT:mediatek/filogic*) ;;
  *)
    echo "ERROR: expected OpenWrt 25.12/APK (or a MediaTek Filogic snapshot). Detected release=${DISTRIB_RELEASE:-unknown}, target=${DISTRIB_TARGET:-unknown}." >&2
    exit 1
    ;;
esac

command -v sha256sum >/dev/null 2>&1 || {
  echo "ERROR: sha256sum is required to verify the release download." >&2
  exit 1
}

download_release() {
  base="$1"
  fetch "$base/$PACKAGE" "$TMP/$PACKAGE" &&
    fetch "$base/$SUMS" "$TMP/$SUMS"
}

LATEST="https://github.com/$REPO/releases/latest/download"
if download_release "$LATEST"; then
  echo "Using the latest REFFIX Monokai Pro release."
else
  rm -f "$TMP/$PACKAGE" "$TMP/$SUMS"
  BASE="https://github.com/$REPO/releases/download/$FALLBACK_VERSION"
  echo "Latest download failed; trying the $FALLBACK_VERSION release." >&2
  download_release "$BASE" || {
    echo "ERROR: could not download the theme APK and checksum from GitHub Releases." >&2
    echo "Check router DNS/TLS access and visit https://github.com/$REPO/releases." >&2
    exit 1
  }
fi

EXPECTED="$(awk -v f="$PACKAGE" '$2 == f { print $1; exit }' "$TMP/$SUMS")"
ACTUAL="$(sha256sum "$TMP/$PACKAGE" | awk '{ print $1 }')"
[ -n "$EXPECTED" ] || {
  echo "ERROR: the release checksum file does not name $PACKAGE." >&2
  exit 1
}
[ "$EXPECTED" = "$ACTUAL" ] || {
  echo "ERROR: SHA-256 mismatch for $PACKAGE; refusing to install." >&2
  exit 1
}

echo "Checksum verified. Installing/upgrading REFFIX Monokai Pro..."
apk add --allow-untrusted "$TMP/$PACKAGE"
echo "Done. Open LuCI → System → System → Language and Style, then select Monokai Pro."
echo "Existing package identity luci-theme-footstrap is retained for in-place upgrades."
