# PokerTH Web Client

This add-on runs the official [PokerTH web client](https://github.com/narmod/pokerth-web-client): a browser PWA plus its Node.js WebSocket-to-TCP proxy, the same stack that powers https://webclient.pokerth.net.

Embedded client release: **v2.1.8-web.20**.

## How to use

1. Install and start the add-on.
2. Click **Open Web UI** (or browse to `http://<your-ha-host>:8080`).
3. Pick a login mode:
   - **Guest / Account** — play on the official pokerth.net servers.
   - **LAN server** — point the client at a PokerTH dedicated server on your network (host + port, default 7234).

The proxy bridges the browser WebSocket to the PokerTH TCP protocol; TLS towards the official servers is verified by default.

## Admin page

The instance admin panel lives at `http://<your-ha-host>:8080/admin`.

1. Set `admin_token` in the add-on **Configuration** tab (any long random string).
2. Restart the add-on.
3. Open `/admin` and sign in with that token.

With an empty token the panel is inert (every request answers "admin disabled"). Setting `admin_enabled: false` hides `/admin` entirely — it answers a plain 404.

## Configuration

| Option | Default | Description |
| ------ | ------- | ----------- |
| `admin_token` | *(empty)* | Token that unlocks the `/admin` panel. Empty = admin inert. |
| `admin_enabled` | `true` | `false` fully hides the admin panel (404). |
| `allowed_hosts` | `[]` | Extra PokerTH server hostnames/IPs the proxy may bridge to (loopback and pokerth.net are always allowed). |
| `allowed_ports` | `[]` | Extra upstream ports besides the defaults 7234/7236. |

The host port can be changed in the add-on's **Network** section (default 8080).

## Data

Runtime data (leaderboard stats, admin configuration, saved preferences) is stored in `/data/pokerth` and survives add-on updates and rebuilds.
