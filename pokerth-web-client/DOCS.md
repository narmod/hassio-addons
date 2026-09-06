# PokerTH Web Client

This add-on runs the official [PokerTH web client](https://github.com/narmod/pokerth-web-client): a browser PWA plus its Node.js WebSocket-to-TCP proxy, the same stack that powers https://webclient.pokerth.net.

## How to use

1. Install and start the add-on.
2. Click **Open Web UI** (or browse to `http://<your-ha-host>:8080`).
3. Pick a login mode:
   - **Guest / Account** — play on the official pokerth.net servers.
   - **LAN server** — point the client at a PokerTH dedicated server on your network (host + port, default 7234).

The proxy bridges the browser WebSocket to the PokerTH TCP protocol; TLS towards the official servers is verified by default.

## Configuration

No options are required. The host port can be changed in the add-on's **Network** section (default 8080).

## Notes

- The add-on embeds a fixed client release (see the add-on version). Updates ship as new add-on versions.
- Runtime data (statistics, caches) lives inside the container and is reset when the add-on is rebuilt.
