// Minimal Ingress endpoint for the PokerTH Web Client add-on.
//
// The web client itself uses absolute asset paths (PWA + service worker
// scope), so it cannot live under the Home Assistant ingress sub-path.
// Instead, ingress serves this small landing page whose only job is to
// open the real client on the add-on's mapped host port, in a full tab.
//
// The mapped port is read from the Supervisor API (the user may have
// remapped 8080 in the add-on's Network section); 8080 is the fallback.
import http from 'node:http';

const SUPERVISOR_TOKEN = process.env.SUPERVISOR_TOKEN || '';
const INGRESS_PORT = 8099;

let _cache = { port: 8080, ts: 0 };
async function mappedHostPort() {
  if (Date.now() - _cache.ts < 60_000) return _cache.port;
  try {
    const r = await fetch('http://supervisor/addons/self/info', {
      headers: { Authorization: 'Bearer ' + SUPERVISOR_TOKEN },
    });
    const j = await r.json();
    const p = j && j.data && j.data.network && j.data.network['8080/tcp'];
    if (p) _cache = { port: p, ts: Date.now() };
  } catch (_) { /* keep fallback */ }
  return _cache.port;
}

http.createServer(async (req, res) => {
  const port = await mappedHostPort();
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-store' });
  res.end(`<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PokerTH Web Client</title>
<style>
  body { margin:0; height:100vh; display:flex; align-items:center; justify-content:center;
         background:#14532d; color:#f2f2ee; font-family:system-ui,sans-serif; text-align:center; }
  a.btn { display:inline-block; margin-top:14px; padding:12px 28px; border-radius:10px;
          background:#b22222; color:#fff; text-decoration:none; font-weight:600; font-size:1.05rem; }
  a.btn:hover { background:#8f1b1b; }
  p.small { opacity:.75; font-size:.85rem; margin-top:18px; }
</style></head><body>
<div>
  <h2>PokerTH Web Client</h2>
  <a class="btn" id="open" href="#" target="_blank" rel="noopener">Open PokerTH</a>
  <p class="small">The table opens in its own tab on port ${port}.</p>
</div>
<script>
  var u = 'http://' + location.hostname + ':${port}/';
  document.getElementById('open').href = u;
</script>
</body></html>`);
}).listen(INGRESS_PORT, () => console.log('[ingress] landing page on :' + INGRESS_PORT));
