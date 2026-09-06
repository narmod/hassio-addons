# PokerTH Web Client

This add-on runs the official [PokerTH web client](https://github.com/narmod/pokerth-web-client): a browser PWA plus its Node.js WebSocket-to-TCP proxy, the same stack that powers https://webclient.pokerth.net.

Embedded client release: **v2.1.8-web.20**.

## How to use

1. Install and start the add-on.
2. Click **Open Web UI** (or browse to `http://<your-ha-host>:8080`), or use the **PokerTH** entry in the Home Assistant sidebar — it opens the client in its own tab.
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
| `external_port` | `0` | Port shown by the sidebar panel. `0` = detect the mapped host port automatically; set it manually if the sidebar button targets the wrong port. |
| `allowed_hosts` | `[]` | Extra PokerTH server hostnames/IPs the proxy may bridge to (loopback and pokerth.net are always allowed). |
| `allowed_ports` | `[]` | Extra upstream ports besides the defaults 7234/7236. |

The host port can be changed in the add-on's **Network** section (default 8080). The sidebar panel follows the remapped port automatically.

Note: the client always runs on plain HTTP on your LAN. If you reach Home Assistant over HTTPS (e.g. Nabu Casa), the sidebar panel still works — it opens the client in a new tab on the local port.

## Data

Runtime data (leaderboard stats, admin configuration, saved preferences) is stored in `/data/pokerth` and survives add-on updates and rebuilds.
