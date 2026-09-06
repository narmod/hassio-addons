#!/usr/bin/env sh
# PokerTH Web Client add-on launcher.
# Reads Home Assistant add-on options (/data/options.json) and maps them to
# the environment variables understood by proxy.js, then execs the proxy.
set -e

OPTS=/data/options.json

jqr() { jq -r "$1 // empty" "$OPTS" 2>/dev/null; }

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
exec node /opt/pokerth-web-client/proxy.js
