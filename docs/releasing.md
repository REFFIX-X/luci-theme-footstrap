# Releasing REFFIX Monokai Pro

## Supported package line

The theme is built for OpenWrt **25.12 and newer** using APK only. The package is architecture-independent and its files are emitted under `dist/noarch/`. No IPK/opkg package is generated or published.

## Before a release

Run the checks on the branch you intend to release:

```sh
npm ci
npm run check:fast
npm run check:mid
npm run check:slow
./tools/stage.sh
owfeed plan
owfeed check
owfeed build
sh tools/check-packages.sh
owlab test --release 25.12.4 --install 'dist/noarch/luci-theme-footstrap-*.apk' --assert …
```

The package checker opens the actual APK payloads, verifies the theme and translation packages, and fails if it sees any IPK. The router test installs the built APK and checks the LuCI pages and templates on OpenWrt 25.12.

## Release pipeline

The GitHub Actions workflow validates the source, builds the APK, installs it on a real OpenWrt 25.12 test router, runs the live browser checks, and verifies the tagged release before publication. A tag is not a substitute for a green run: inspect the workflow's failed step and package artifacts before treating the release as available.

The release package keeps the established identifier `luci-theme-footstrap` for upgrade compatibility. LuCI presents it as **Monokai Pro** and the About/version link identifies REFFIX.

## Package contents

- `luci-theme-footstrap`: the theme.
- `luci-i18n-footstrap-<lang>`: one translation catalogue per supported language.

The generated stylesheet is built from `luci-theme-footstrap/styles/`; do not edit the generated `cascade.css` directly.

## Licensing

This project is a REFFIX colour and branding adaptation of Footstrap. Preserve the upstream attribution and license notices in source and release artifacts.


## Changelog mirror

`CHANGELOG.md` is required. `CHANGELOG_ru.md` is optional: leave it empty when no Russian mirror is maintained. If it contains content, the version list, dates, section order and bullet counts must match the English changelog, and the current release notes must have a Russian section. The release-note generator appends the Russian summary only when that mirror is non-empty.
