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

CACHE_DIR=/data/cache
mkdir -p "$CONF_DIR" "$LOG_DIR" "$CACHE_DIR"

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
  <AppDataDir value="/usr/share/pokerth/data/"/>
  <CacheDir value="$CACHE_DIR"/>
 </Configuration>
</PokerTH>
XML
else
  P="$(esc "$(printf '%s' "$PASS" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/"/\&quot;/g')")"
  sed -i -E "s|(<ServerPassword value=\")[^\"]*(\")|\1${P}\2|" "$CONF"
  sed -i -E "s|(<ServerPort value=\")[^\"]*(\")|\17234\2|" "$CONF"
  # patch the managed paths; insert the element when an older config lacks it
  for kv in "AppDataDir=/usr/share/pokerth/data/" "CacheDir=${CACHE_DIR}"; do
    K="${kv%%=*}"; V="${kv#*=}"
    if grep -q "<$K " "$CONF"; then
      sed -i -E "s|(<$K value=\")[^\"]*(\")|\1${V}\2|" "$CONF"
    else
      sed -i "s|</Configuration>|  <$K value=\"${V}\"/>\n </Configuration>|" "$CONF"
    fi
  done
fi

echo "[run] starting pokerth_dedicated_server (log-level $LOGLEVEL, port 7234)"
# Release builds call daemon(0,0): the process forks to the background and the
# parent returns immediately. Launch it, wait for the pid file, surface the
# server log into the add-on log, and hold PID 1 while the daemon is alive.
rm -f /tmp/pokerth.pid
/usr/local/bin/pokerth_dedicated_server --log-level "$LOGLEVEL" --pid-file /tmp/pokerth.pid

i=0
while [ ! -s /tmp/pokerth.pid ] && [ $i -lt 50 ]; do i=$((i+1)); sleep 0.2; done
PID="$(cat /tmp/pokerth.pid 2>/dev/null)"
if [ -z "$PID" ] || ! kill -0 "$PID" 2>/dev/null; then
  echo "[run] server failed to start — last log lines:"
  tail -n 40 "$LOG_DIR/server_messages.log" 2>/dev/null || true
  exit 1
fi
echo "[run] server running (pid $PID)"

touch "$LOG_DIR/server_messages.log"
tail -n 0 -F "$LOG_DIR/server_messages.log" &

while kill -0 "$PID" 2>/dev/null; do sleep 3; done
echo "[run] server exited — last log lines:"
tail -n 40 "$LOG_DIR/server_messages.log" 2>/dev/null || true
exit 1
