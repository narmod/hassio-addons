# PokerTH Server

This app builds and runs the official [PokerTH](https://github.com/pokerth/pokerth) dedicated server (branch `stable`, currently version 2.1.8), pinned to an exact upstream commit for reproducible builds.

## How to use

1. Install the app (the server is **compiled from source** during installation — expect 30–60 minutes on a Raspberry Pi, a few minutes on x86).
2. Start it. The server listens on TCP port **7234** (plain).
3. Connect from:
   - the **PokerTH Web Client app**: first add your HA machine's IP to that app's `allowed_hosts` option (its proxy rejects unknown hosts by design), then login mode *LAN server*, host = that same IP, port 7234, TLS unchecked;
   - the official desktop/mobile clients: *Internet game → manual server* (or LAN), same host and port.

## Configuration

| Option | Default | Description |
| ------ | ------- | ----------- |
| `server_password` | *(empty)* | Password players must enter to join. Empty = open server. |
| `log_level` | `1` | 0 = minimal, 1 = default, 2 = verbose. |

The host port can be remapped in the app's **Network** section; the internal port stays 7234.

## Data

The server's own configuration (`config.xml`), databases and logs live under `/data` and survive updates and rebuilds. Only the managed keys above are rewritten from the app options at each start — any other setting you tune in `/data/.pokerth/config.xml` is preserved.

## Notes

- The app manages a plain-TCP server on your LAN; it does not register itself on the official pokerth.net server list.
- Architectures: aarch64 and amd64. armv7 is not provided (the upstream build environment does not target it).
