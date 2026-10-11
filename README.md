# REFFIX Monokai Pro for LuCI

A REFFIX-maintained Monokai Pro colour edition of the Footstrap-based OpenWrt LuCI theme, tuned to match the REFFIX Firewall Log dashboard.

## Features

- Monokai Pro dark surfaces and matching cyan, purple, pink, orange, green and yellow accents.
- Responsive Footstrap layout and LuCI-wide styling, including third-party LuCI applications.
- Appearance controls, browser-local preferences and optional router-wide defaults.
- Designed to pair visually with [REFFIX Log Viewer](https://github.com/REFFIX-X/luci-app-log).

## Compatibility

Designed for OpenWrt 24.10 and newer with LuCI's ucode templates. Browser support follows the underlying Footstrap implementation.

## Installation

The package currently retains the identifier `luci-theme-footstrap` so an existing installation can be upgraded without a package-name migration. Install or upgrade the package using your configured package feed, then open **System → System → Language and Style** and select **Monokai Pro**.

The package source is in [`luci-theme-footstrap/`](luci-theme-footstrap/). The generated CSS is built from the source files in `luci-theme-footstrap/styles/`.

## Palette

| Token | Hex |
|---|---|
| Background | `#2D2A2E` |
| Panel | `#221F22` |
| Surface | `#343136` |
| Border | `#514D52` |
| Text | `#FCFCFA` |
| Yellow | `#FFD866` |
| Orange | `#FC9867` |
| Pink | `#FF6188` |
| Green | `#A9DC76` |
| Cyan | `#78DCE8` |
| Purple | `#AB9DF2` |

## Credits and licensing

This is a colour and branding adaptation of [VizzleTF/luci-theme-footstrap](https://github.com/VizzleTF/luci-theme-footstrap). The upstream code and license notices are retained. Licensed under Apache-2.0 where stated by the source project.
