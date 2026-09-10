# PokerTH Apps for Home Assistant

**Run a complete open-source Texas Hold'em setup directly on Home Assistant OS.**

[![Open your Home Assistant instance and show the app store with this repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_store.svg)](https://my.home-assistant.io/redirect/supervisor_store/?repository_url=https%3A%2F%2Fgithub.com%2Fnarmod%2Fhassio-addons)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)
![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)

Play [PokerTH](https://www.pokerth.net), the open-source Texas Hold'em poker game, from your Home Assistant box: open the official client from your sidebar, self-host the web client, or run your own game server for private home games.

Maintained by a member of the PokerTH development team. The web client is the same code that powers the official https://webclient.pokerth.net.

> **Apps = add-ons.** Home Assistant 2026.2 renamed *add-ons* to *apps*. Nothing else changed: if your Home Assistant still shows **Add-ons**, everything below works the same way.

## App catalog

| | App | What it does | Runs on your box | Remote access | Version |
|:-:|---|---|:-:|:-:|---|
| <img src="pokerth-online/icon.png" width="48" alt=""> | **[PokerTH Online](./pokerth-online)** | The official hosted client in your sidebar. Zero setup. | No | ✅ Yes | ![version](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fnarmod%2Fhassio-addons%2Fmain%2Fpokerth-online%2Fconfig.yaml&query=%24.version&label=version) |
| <img src="pokerth-web-client/icon.png" width="48" alt=""> | **[PokerTH Web Client](./pokerth-web-client)** | Self-hosted web client (PWA) + proxy, with an admin page. Plays on pokerth.net or on LAN servers. | Yes | LAN only | ![version](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fnarmod%2Fhassio-addons%2Fmain%2Fpokerth-web-client%2Fconfig.yaml&query=%24.version&label=version) |
| <img src="pokerth-server/icon.png" width="48" alt=""> | **[PokerTH Server](./pokerth-server)** | Dedicated game server (2.1.x) built from the official sources. Host your own private games. | Yes | LAN only | ![version](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fnarmod%2Fhassio-addons%2Fmain%2Fpokerth-server%2Fconfig.yaml&query=%24.version&label=version) |

## Which app do I need?

| I want to… | Install |
|---|---|
| Play right away, at home or away | **PokerTH Online** |
| Host the client myself and manage it from an admin page | **PokerTH Web Client** |
| Run private games for family and friends on my network | **PokerTH Server** + **PokerTH Web Client** |

For private games, add your Home Assistant machine's IP to the Web Client's `allowed_hosts` option before connecting to the server (see the [PokerTH Server documentation](./pokerth-server/DOCS.md)).

## Installation

**One click:** use the **Open your Home Assistant instance** button above, then select **Add**.

**Manually:**

1. In Home Assistant, go to **Settings → Apps** and select **Install app**.
2. In the top-right corner, open the three dots menu (⋮) and select **Repositories**.
3. Paste `https://github.com/narmod/hassio-addons` and select **Add**.
4. Close the dialog, find the **PokerTH** apps in the store, and install the one you need.

Each app has its own **Documentation** tab in Home Assistant with setup and configuration details.

## Requirements

- **Home Assistant OS.** Apps need the Supervisor; they are not available on Home Assistant Container installs.
- **aarch64 or amd64** hardware (Raspberry Pi 4/5, Home Assistant Green/Yellow, x86 mini PCs, VMs). armv7 is not supported.
- **PokerTH Server** is compiled from source at install time: expect 30–60 minutes on a Raspberry Pi (one-time cost).

## Remote access

Nabu Casa and other Home Assistant remote access methods tunnel the Home Assistant interface, not the network ports opened by apps. As a result:

- **PokerTH Online** works everywhere: your browser talks directly to the official servers.
- **PokerTH Web Client** and **PokerTH Server** are reachable on your local network only. Away from home, play on https://webclient.pokerth.net (same client, same servers).

## Support

- Bugs and feature requests for these apps: [open an issue](https://github.com/narmod/hassio-addons/issues).
- The game itself: [PokerTH on GitHub](https://github.com/pokerth/pokerth) and https://www.pokerth.net.

## License

[AGPL-3.0](LICENSE). PokerTH is free and open-source software.
