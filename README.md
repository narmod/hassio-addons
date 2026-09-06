# PokerTH Add-ons for Home Assistant

[![Add repository to my Home Assistant](https://img.shields.io/badge/Home%20Assistant-add%20repository-41BDF5?logo=home-assistant&logoColor=white)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fnarmod%2Fhassio-addons)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)
![Architectures](https://img.shields.io/badge/arch-aarch64%20%7C%20amd64-green)

Home Assistant add-ons for [PokerTH](https://www.pokerth.net), the open-source Texas Hold'em poker game: play in your browser, host your own game server, or pin the official hosted client to your sidebar.

Maintained by a member of the PokerTH development team; the web client is the same code that powers the official https://webclient.pokerth.net.

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fnarmod%2Fhassio-addons)

## Add-ons

### [PokerTH Web Client](./pokerth-web-client)

The official PokerTH web client (PWA) with its WebSocket-to-TCP proxy. Play on the official pokerth.net servers, or point it at any PokerTH server on your LAN — straight from a browser tab served by your Home Assistant box.

### [PokerTH Online](./pokerth-online)

A sidebar shortcut embedding the **official hosted client** at https://webclient.pokerth.net. Nothing runs locally, so it also works through remote access (Nabu Casa).

### [PokerTH Server](./pokerth-server)

The PokerTH dedicated server (2.1.x) built from the official sources. Host your own games on your Home Assistant box and join them from the web client add-on (LAN mode) or the official desktop/mobile clients. aarch64/amd64; compiled at install time.

## Installation

1. In Home Assistant go to **Settings → Add-ons → Add-on store**.
2. Menu (⋮) → **Repositories** → paste `https://github.com/narmod/hassio-addons` → **Add**.
3. Install **PokerTH Web Client** from the store, start it, then click **Open Web UI**.

> **Note — remote access:** Nabu Casa (and the HA cloud URL in general) only tunnels the Home Assistant interface, not the add-on's port. The client served by this add-on is therefore reachable on your **local network only**. To play away from home, use the official hosted client at https://webclient.pokerth.net — same client, same servers.
