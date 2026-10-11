# REFFIX Monokai Pro for LuCI

A REFFIX-maintained Monokai Pro colour edition of the Footstrap-based OpenWrt LuCI theme, tuned to match the REFFIX Firewall Log dashboard.

**Current release:** [v2.0.0 for OpenWrt 25.12/APK](https://github.com/REFFIX-X/luci-theme-footstrap/releases/tag/v2.0.0).

## Features

- Monokai Pro dark surfaces and matching cyan, purple, pink, orange, green and yellow accents.
- Responsive Footstrap layout and LuCI-wide styling, including third-party LuCI applications.
- Appearance controls, browser-local preferences and optional router-wide defaults.
- Designed to pair visually with [REFFIX Log Viewer](https://github.com/REFFIX-X/luci-app-log).

## Compatibility

Built and tested for OpenWrt 25.12+ using APK packages only. IPK/opkg builds are not published. Browser support follows the underlying Footstrap implementation.

## Installation

### Option 1: Install the v2.0 APK release

1. Open [**REFFIX Monokai Pro v2.0 Releases**](https://github.com/REFFIX-X/luci-theme-footstrap/releases/tag/v2.0.0).
2. Download the theme package named `luci-theme-footstrap-*.apk` and the language package you want, `luci-i18n-footstrap-<lang>-*.apk`, if provided.
3. Copy the APK files to your OpenWrt 25.12 router. For example, from Windows PowerShell:

   ```powershell
   scp .\luci-theme-footstrap-*.apk root@192.168.1.1:/tmp/
   ```

4. SSH into the router and install the downloaded APK package(s):

   ```sh
   apk add --allow-untrusted /tmp/luci-theme-footstrap-*.apk
   ```

   If you downloaded a translation package, install that too using its exact filename. Use only APK packages built for OpenWrt 25.12+; this project does not publish IPK/opkg packages.

5. In LuCI, open **System → System → Language and Style**, then choose **Monokai Pro** under Design.

### Option 2: Install from a configured package feed

If the v2.0 package feed is configured on your router, run:

```sh
apk update
apk add luci-theme-footstrap
```

Then select **Monokai Pro** under **System → System → Language and Style**.

**Upgrade note:** the installed package identifier remains `luci-theme-footstrap` to preserve compatibility with existing installations.

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
