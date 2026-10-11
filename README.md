# REFFIX Monokai Pro for LuCI

A REFFIX-maintained Monokai Pro colour edition of the Footstrap-based OpenWrt LuCI theme, tuned to match the REFFIX Firewall Log dashboard.

**Release:** [v2.0.1 for OpenWrt 25.12/APK](https://github.com/REFFIX-X/luci-theme-footstrap/releases/tag/v2.0.1)

## Features

- Monokai Pro dark surfaces with cyan, purple, pink, orange, green and yellow accents.
- Responsive Footstrap layout and LuCI-wide styling, including third-party LuCI applications.
- Appearance controls, browser-local preferences and optional router-wide defaults.
- Designed to pair with [REFFIX Log Viewer](https://github.com/REFFIX-X/luci-app-log).

## Navigation performance

Supported LuCI pages use in-place navigation: the theme keeps the LuCI shell loaded and renders
the next view without a full page reload. In the repository's 1 August 2026 OpenWrt 25.12.2
benchmark, this covered 38 stock pages and was 2.29× faster by total median time than stock
Bootstrap; each transition made 0–7 requests instead of 15–47. Results depend on the router and
page: views that spend most of their time rendering large datasets have less room to improve.
See the [benchmark method and per-page results](docs/benchmark.md), and measure again on your own
router before comparing changes.

## Compatibility

This release targets **OpenWrt 25.12 using APK**. The workflow builds the package with the official OpenWrt SDK. IPK/opkg packages are not published in this release.

## Installation

### One-line installation (OpenWrt 25.12/APK)

Run this over SSH as root on the router:

```sh
uclient-fetch -qO- https://raw.githubusercontent.com/REFFIX-X/luci-theme-footstrap/main/install-online.sh | sh
```

The installer downloads the release APK, verifies its SHA-256 checksum, and installs or upgrades the existing `luci-theme-footstrap` package.

### Manual APK installation

1. Open the [v2.0.1 release](https://github.com/REFFIX-X/luci-theme-footstrap/releases/tag/v2.0.1) and download `reffix-luci-theme-footstrap-openwrt-25.12.apk` plus any language APK you need.
2. Copy the theme APK from Windows PowerShell, in the folder containing the download:

   ```powershell
   scp .\reffix-luci-theme-footstrap-openwrt-25.12.apk root@192.168.1.1:/tmp/
   ```

3. SSH into the router and install the package:

   ```sh
   apk add --allow-untrusted /tmp/reffix-luci-theme-footstrap-openwrt-25.12.apk
   ```

   Install any downloaded language package the same way, using its exact filename.

4. In LuCI, open **System → System → Language and Style** and choose **Monokai Pro** under **Design**. If the old styles remain visible, hard-refresh the page with **Ctrl+F5**.

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
