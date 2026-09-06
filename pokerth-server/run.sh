#!/usr/bin/env sh
# PokerTH Server add-on launcher.
# Maps Home Assistant options (/data/options.json) onto the server's
# config.xml (managed keys only; the server fills in every other default),
# then execs the dedicated server. HOME=/data → config and logs persist.
set -e

OPTS=/data/options.json
CONF_DIR=/data/.pokerth
CONF="$CONF_DIR/config.xml"
LOG_DIR=/data/log

jqr() { jq -r "$1 // empty" "$OPTS" 2>/dev/null; }

command -v jq >/dev/null 2>&1 || JQ_MISSING=1
PASS=""
LOGLEVEL=1
if [ -z "$JQ_MISSING" ]; then
  PASS="$(jqr .server_password)"
  LL="$(jqr .log_level)"
  case "$LL" in 0|1|2) LOGLEVEL="$LL";; esac
fi

mkdir -p "$CONF_DIR" "$LOG_DIR"

# sed-escape the replacement (password may contain &, |, \)
esc() { printf '%s' "$1" | sed 's/[&|\\]/\\&/g'; }

if [ ! -f "$CONF" ]; then
  cat > "$CONF" <<XML
<?xml version="1.0" encoding='utf-8'?>
<PokerTH>
 <Configuration>
  <ServerPassword value="$(printf '%s' "$PASS" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/"/\&quot;/g')"/>
  <ServerPort value="7234"/>
  <LogDir value="$LOG_DIR"/>
 </Configuration>
</PokerTH>
XML
else
  P="$(esc "$(printf '%s' "$PASS" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/"/\&quot;/g')")"
  sed -i -E "s|(<ServerPassword value=\")[^\"]*(\")|\1${P}\2|" "$CONF"
  sed -i -E "s|(<ServerPort value=\")[^\"]*(\")|\17234\2|" "$CONF"
fi

echo "[run] starting pokerth_dedicated_server (log-level $LOGLEVEL, port 7234)"
exec /usr/local/bin/pokerth_dedicated_server --log-level "$LOGLEVEL" --pid-file /tmp/pokerth.pid
