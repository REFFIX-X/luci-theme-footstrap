# REFFIX Monokai Pro LuCI Theme

REFFIX's Monokai Pro colour edition of the Footstrap-based LuCI theme for OpenWrt 25.12 and newer, using APK packages only.

The theme keeps the existing layout, responsive shell, LuCI form styling, appearance controls and local assets while aligning the dark interface with the REFFIX Log Viewer.

## Colour system

The dark palette uses the same Monokai Pro-inspired colours as the REFFIX Firewall Log:

| Role | Colour |
|---|---|
| Page background | `#2D2A2E` |
| Panels | `#221F22` |
| Raised controls | `#343136` |
| Borders | `#514D52` |
| Main text | `#FCFCFA` |
| Yellow | `#FFD866` |
| Orange | `#FC9867` |
| Pink | `#FF6188` |
| Green | `#A9DC76` |
| Cyan | `#78DCE8` |
| Purple | `#AB9DF2` |

## Build and install

The package remains named `luci-theme-footstrap` to preserve package-manager upgrade compatibility with existing Flint4 installations. The LuCI-visible theme and package metadata are branded **REFFIX Monokai Pro**.

The release workflow builds the package with the official OpenWrt SDK, using this directory's `Makefile`. The generated stylesheet is built from `styles/` by `build-css.sh`. Do not edit generated `htdocs/luci-static/footstrap/cascade.css`.

## Credits and license

This project is based on the Footstrap theme source and retains its upstream notices and license. Original project: [VizzleTF/luci-theme-footstrap](https://github.com/VizzleTF/luci-theme-footstrap). Source package license: Apache-2.0. REFFIX changes the palette and project branding; upstream copyright and license notices are retained.
