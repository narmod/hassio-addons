#!/usr/bin/env sh
# PokerTH Web Client add-on launcher (docker-git install).
# Clones the web client into /data/app on first start, maps Home Assistant
# add-on options (/data/options.json) to the environment variables understood
# by proxy.js, then execs the proxy from the checkout.
set -e

OPTS=/data/options.json
REPO=https://github.com/narmod/pokerth-web-client.git
APP=/data/app

jqr() { jq -r "$1 // empty" "$OPTS" 2>/dev/null; }

# ── Git checkout (docker-git) ────────────────────────────────────────────
REF="$(jqr .git_ref)"
[ -n "$REF" ] || REF=main

if [ ! -d "$APP/.git" ]; then
  echo "[run] first start: cloning $REPO @ $REF into $APP"
  git clone --depth 1 --branch "$REF" "$REPO" "$APP"
else
  if [ "$(jqr .auto_update)" = "true" ]; then
    echo "[run] auto_update: syncing $REF"
    ( cd "$APP" \
      && git checkout -- public/themes/themes.json public/seats/seats.json 2>/dev/null || true \
      && git fetch --depth 1 origin "$REF" \
      && git checkout -q -f -B "$REF" FETCH_HEAD ) \
      || echo "[run] auto_update failed — keeping current checkout"
  fi
fi

# npm install only when dependencies changed (hash of package.json).
cd "$APP"
HASH="$(sha1sum package.json | cut -d' ' -f1)"
if [ ! -d node_modules ] || [ "$HASH" != "$(cat /data/.pkghash 2>/dev/null)" ]; then
  echo "[run] installing npm dependencies"
  npm install --omit=dev --no-audit --no-fund
  echo "$HASH" > /data/.pkghash
fi

# proxy.js self-update follows this ref (admin page Update button).
export GIT_BRANCH="$REF"

# ── Admin panel ──────────────────────────────────────────────────────────
# STATS_ADMIN_TOKEN gates every /admin route; empty token = panel inert.
TOKEN="$(jqr .admin_token)"
[ -n "$TOKEN" ] && export STATS_ADMIN_TOKEN="$TOKEN"

# ADMIN_ENABLED=0 hides /admin entirely (plain 404).
AE="$(jqr .admin_enabled)"
[ "$AE" = "false" ] && export ADMIN_ENABLED=0

# ── Extra LAN servers (anti-SSRF allowlists) ─────────────────────────────
AH="$(jq -r '(.allowed_hosts // []) | join(",")' "$OPTS" 2>/dev/null)"
[ -n "$AH" ] && export ALLOWED_HOSTS="$AH"
AP="$(jq -r '(.allowed_ports // []) | map(tostring) | join(",")' "$OPTS" 2>/dev/null)"
[ -n "$AP" ] && export ALLOWED_PORTS="$AP"

# ── Persist runtime data across add-on rebuilds ──────────────────────────
DATA=/data/pokerth
mkdir -p "$DATA"
export STATS_FILE="$DATA/stats.json"
export STATS_META_FILE="$DATA/stats.meta.json"
export ADMIN_CONFIG_FILE="$DATA/admin-config.json"
export PREFS_DIR="$DATA/prefs"
export POLLS_FILE="$DATA/polls.json"
export VISITS_FILE="$DATA/visits.json"
export AUDIT_FILE="$DATA/audit.log"
export BROADCASTS_FILE="$DATA/broadcasts.json"
export DB_CONFIG_FILE="$DATA/db-config.json"
export SCOPED_TOKENS_FILE="$DATA/scoped-tokens.json"
export DEPLOY_HISTORY_FILE="$DATA/deploy-history.json"

export PORT=8080

# Sidebar landing page: manual host-port override (0 = ask the Supervisor).
EP="$(jqr .external_port)"
[ -n "$EP" ] && [ "$EP" != "0" ] && export EXTERNAL_PORT="$EP"

# Ingress landing page (sidebar panel) — redirects to the mapped host port.
node /ingress.mjs &

exec node "$APP/proxy.js"
