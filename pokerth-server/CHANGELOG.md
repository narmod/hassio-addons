# Changelog

## 1.0.4

- Ship the default avatars (AppDataDir) and create a cache directory — fixes the "Avatar directory does not exist / Missing files" startup errors


## 1.0.3

- Fix restart loop: release builds daemonize (`daemon(0,0)`), so the container's main process exited immediately — the launcher now waits for the pid file, streams `server_messages.log` into the add-on log, and keeps the container alive while the server runs


## 1.0.2

- Rebuilt as a multi-stage image: the final image installs the runtime libraries explicitly and copies the compiled binary — the fragile purge/autoremove cleanup is gone
- Build-time smoke test (`ldd` + `--version`) fails the build immediately if a runtime library is missing


## 1.0.1

- Fix install step: the compiled binary lands in `build/bin/`, not `build/src/` (install failed right after a successful link)


## 1.0.0

- First release: PokerTH dedicated server 2.1.8 built from the official sources (pinned commit), TCP port 7234, `server_password` and `log_level` options, persistent configuration under `/data`
