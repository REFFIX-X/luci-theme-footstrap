#!/bin/sh
# Boot this run's routers and install the build under test — the `live`/`motion` and `anchors`
# jobs (.github/workflows/build.yml) did this by hand, byte-for-byte except which env var each one
# also set around it, so this is the one copy both call.
#
#   sh tools/ci-boot.sh
#
# Needs GITHUB_EVENT_NAME, GITHUB_ENV and owlab already on PATH — true of any step after
# owfeed/owlab/setup in these jobs, never true outside CI.
set -eu

# NOT `. "$GITHUB_ENV"` after this — that file is a KEY=VALUE list, not a script, so a value with a
# space in it ("owrt2512 owrtsnap") would run its second word as a command.
#
# The published package targets OpenWrt 25.12/APK. Snapshot remains a compatibility smoke test
# against current luci-base; the 24.10/opkg router is intentionally not built or installed.
if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then ROUTERS="owrt2512"; else ROUTERS="owrt2512 owrtsnap"; fi
echo "ROUTERS=$ROUTERS" >> "$GITHUB_ENV"

owlab up $ROUTERS
for r in $ROUTERS; do
	case "$r" in
		*2512|*snap) owlab install "$r" dist/noarch/luci-theme-footstrap-*.apk ;;
		*) echo "Unsupported test router for the APK-only release: $r" >&2; exit 1 ;;
	esac
done
