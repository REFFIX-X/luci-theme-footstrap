# REFFIX Monokai Pro for LuCI

A REFFIX-maintained Monokai Pro colour edition of the Footstrap-based OpenWrt LuCI theme, tuned to match the REFFIX Firewall Log dashboard.

**Release:** [v2.0.0 for OpenWrt 25.12/APK](https://github.com/REFFIX-X/luci-theme-footstrap/releases/tag/v2.0.0)

## Features

- Monokai Pro dark surfaces with cyan, purple, pink, orange, green and yellow accents.
- Responsive Footstrap layout and LuCI-wide styling, including third-party LuCI applications.
- Appearance controls, browser-local preferences and optional router-wide defaults.
- Designed to pair with [REFFIX Log Viewer](https://github.com/REFFIX-X/luci-app-log).

## Compatibility

This release targets **OpenWrt 25.12 using APK**. The workflow builds the package with the official OpenWrt SDK. IPK/opkg packages are not published in this release.

## Installation

### Install from the v2.0.0 release

1. Open [**REFFIX Monokai Pro v2.0.0 Releases**](https://github.com/REFFIX-X/luci-theme-footstrap/releases/tag/v2.0.0).
2. Download `reffix-luci-theme-footstrap-openwrt-25.12.apk` and, if you need a translation, the matching language package.
3. Copy the downloaded APK to your router. From Windows PowerShell, in the folder containing the downloaded file:

   ```powershell
   scp .\reffix-luci-theme-footstrap-openwrt-25.12.apk root@192.168.1.1:/tmp/
   ```

4. SSH into the router and install the package:

   ```sh
   apk add --allow-untrusted /tmp/reffix-luci-theme-footstrap-openwrt-25.12.apk
   ```

   Install any downloaded language package the same way, using its exact filename.

5. In LuCI, open **System → System → Language and Style** and choose **Monokai Pro** under **Design**. If the old styles remain visible, hard-refresh the page with **Ctrl+F5**.

### Verify the download

The release includes `SHA256SUMS-openwrt-25.12.txt`. From a Linux shell, verify the APK with:

```sh
sha256sum -c SHA256SUMS-openwrt-25.12.txt
```

**Upgrade note:** the package identifier remains `luci-theme-footstrap`, preserving the package identity for upgrades.

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

This is a colour and branding adaptation of [VizzleTF/luci-theme-footstrap](https://github.com/VizzleTF/luci-theme-footstrap). Upstream code and license notices are retained. Licensed under Apache-2.0 where stated by the source project.
