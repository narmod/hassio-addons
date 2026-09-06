# Changelog

## 1.0.2

- Rebuilt as a multi-stage image: the final image installs the runtime libraries explicitly and copies the compiled binary — the fragile purge/autoremove cleanup is gone
- Build-time smoke test (`ldd` + `--version`) fails the build immediately if a runtime library is missing


## 1.0.1

- Fix install step: the compiled binary lands in `build/bin/`, not `build/src/` (install failed right after a successful link)


## 1.0.0

- First release: PokerTH dedicated server 2.1.8 built from the official sources (pinned commit), TCP port 7234, `server_password` and `log_level` options, persistent configuration under `/data`
