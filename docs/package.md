# REFFIX Monokai Pro packaging

## Supported build

The theme is built and published for **OpenWrt 25.12 and newer using APK only**. IPK/opkg packages are no longer generated or published.

The package is architecture-independent. The theme payload is built by the shared owfeed pipeline from `owfeed.yml` and `tools/stage.sh`.

## Package names

- Main theme: `luci-theme-footstrap`
- Translations: `luci-i18n-footstrap-<lang>`

The installed package identifier remains `luci-theme-footstrap` for upgrade compatibility. The LuCI-visible name is **Monokai Pro**, and the version/About link identifies REFFIX Monokai Pro.

## Build and validation

The main CI workflow runs the static gates, stages the package, builds APK files with owfeed, opens each APK to verify its payload, installs the package on OpenWrt 25.12, and checks the rendered LuCI pages.

Local build outline:

```sh
npm ci
npm run check:fast
./tools/stage.sh
owfeed plan
owfeed check
owfeed build
sh tools/check-packages.sh
```

Artifacts are emitted under `dist/noarch/`. The package-checking script verifies the theme and each translation package and fails if an IPK is present.

## Install

On a supported OpenWrt 25.12+ system with APK, use the configured package feed or the signed installer asset attached to the release. The installer rejects systems that do not have APK or whose OpenWrt release does not match the supported release line.

## Upstream and license

This is a palette and branding adaptation of Footstrap. Upstream source and license notices are retained. Review the repository's `LICENSE` and upstream attribution before redistributing the code.
