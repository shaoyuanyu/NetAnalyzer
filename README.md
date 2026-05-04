# NetAnalyzer

A WiFi network analysis tool for HarmonyOS NEXT, built with ArkTS and ArkUI.

## Features

- **Connection Info** — View SSID, BSSID, security type, frequency band, and channel details of the current WiFi connection
- **Signal Monitoring** — Real-time RSSI and signal strength with visual indicators
- **Speed Info** — Display link speed, uplink/downlink bandwidth
- **Network Address** — Show IP address, subnet mask, gateway, DNS, interface name, and MTU
- **WiFi Scanning** — Scan and list nearby WiFi networks with detailed information for each AP
- **Dark Mode** — Support Light / Dark / Follow System themes
- **i18n** — Chinese and English language support, switchable in settings

## Screenshots

| WiFi Info | Scan List | Settings |
|:---------:|:---------:|:--------:|
| Connection details | Nearby networks | Theme & language |

## Tech Stack

- **Platform**: HarmonyOS NEXT (API 23, SDK 6.1.0)
- **Language**: ArkTS
- **UI Framework**: ArkUI (declarative)
- **Build Tool**: hvigorw
- **Kits Used**:
  - `@kit.ConnectivityKit` — WiFi management (`wifiManager`)
  - `@kit.NetworkKit` — Network connection info (`connection`)
  - `@kit.ArkData` — Preferences storage
  - `@kit.AbilityKit` — Application lifecycle and bundle info

## Project Structure

```
NetAnalyzer/
├── AppScope/                    # Application-level config and resources
├── entry/
│   └── src/main/
│       ├── ets/
│       │   ├── entryability/    # UIAbility entry point
│       │   ├── entrybackupability/
│       │   ├── model/           # Data models (WifiFullInfo, WifiScanItem)
│       │   ├── pages/           # UI pages
│       │   │   ├── MainPage.ets  # Tab container
│       │   │   ├── Index.ets     # WiFi info page
│       │   │   ├── ScanList.ets  # WiFi scan list page
│       │   │   └── Settings.ets  # Settings page
│       │   └── utils/           # Utilities
│       │       ├── WifiInfoService.ets  # WiFi data fetching
│       │       └── I18n.ets            # Internationalization
│       └── resources/           # String, color, and media resources
├── hvigor/                     # Build tool config
├── build-profile.json5         # Build configuration
└── oh-package.json5            # Package dependencies
```

## Prerequisites

- DevEco Studio or HarmonyOS command-line tools
- HarmonyOS NEXT device or emulator
- JDK 17+

## Build & Deploy

```bash
# Build and deploy (build → sign → install → launch)
./build-and-deploy.sh

# Build only
./build-and-deploy.sh build-only

# Sign only
./build-and-deploy.sh sign-only

# Launch only (app must already be installed)
./build-and-deploy.sh run-only
```

Or use hvigorw directly:

```bash
hvigorw assembleHap
```

## Permissions

| Permission | Purpose |
|:-----------|:--------|
| `ohos.permission.GET_WIFI_INFO` | Get WiFi connection and scan info |
| `ohos.permission.GET_NETWORK_INFO` | Get network connection properties |
| `ohos.permission.INTERNET` | Network access |

## License

MIT
