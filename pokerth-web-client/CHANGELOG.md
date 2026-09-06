# Changelog

## 1.4.3

- Show the sidebar panel to all users, not only administrators (`panel_admin: false`)


## 1.4.2

- Fix the Configuration editor for `allowed_hosts` / `allowed_ports` (the optional-entry schema kept the HA list picker from adding values)
- "Admin page →" link on the sidebar landing page; admin URL shown on the Info tab


## 1.4.1

- Drop deprecated armv7 architecture (Supervisor warning)


## 1.4.0

- docker-git install: the image ships only the runtime; the web client is cloned into `/data/app` on first start and survives image rebuilds
- Self-update from the client's admin page now works (static and full update; enable the add-on Watchdog for the full update's restart)
- New options: `git_ref` (branch or tag to check out), `auto_update` (sync on every start)

## 1.3.1

- Official PokerTH chip as add-on icon and logo
- Ingress landing page restyled after the client's boot splash (official background, chip, colors)

## 1.3.0

- New `external_port` option to override the port shown by the sidebar button
- Supervisor API diagnostics in the log when port detection fails

## 1.2.0

- PokerTH entry in the Home Assistant sidebar (ingress landing page opening the client in its own tab, mapped port detected automatically)

## 1.1.0

- Options: `admin_token`, `admin_enabled`, `allowed_hosts`, `allowed_ports`
- Runtime data persisted in `/data/pokerth` across rebuilds

## 1.0.0

- First release: web client + WebSocket proxy on port 8080, multi-arch (aarch64/amd64/armv7)
