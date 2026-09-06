// Minimal Ingress endpoint for the PokerTH Web Client add-on.
//
// The web client itself uses absolute asset paths (PWA + service worker
// scope), so it cannot live under the Home Assistant ingress sub-path.
// Instead, ingress serves this small landing page — styled after the
// client's own boot splash — whose only job is to open the real client
// on the add-on's mapped host port, in a full tab.
//
// The mapped port is read from the Supervisor API (the user may have
// remapped 8080 in the add-on's Network section); the `external_port`
// option overrides it; 8080 is the final fallback.
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';

const SUPERVISOR_TOKEN = process.env.SUPERVISOR_TOKEN || '';
const INGRESS_PORT = 8099;
// Manual override from the add-on option `external_port` (0 = automatic).
const OPT_PORT = parseInt(process.env.EXTERNAL_PORT || '0', 10) || 0;
const PUB = '/opt/pokerth-web-client/public';

let _cache = { port: 8080, ts: 0 };
async function mappedHostPort() {
  if (OPT_PORT) return OPT_PORT;
  if (Date.now() - _cache.ts < 10_000) return _cache.port;
  try {
    const r = await fetch('http://supervisor/addons/self/info', {
      headers: { Authorization: 'Bearer ' + SUPERVISOR_TOKEN },
    });
    if (!r.ok) {
      console.error('[ingress] supervisor API HTTP ' + r.status + ' — using port ' + _cache.port);
    } else {
      const j = await r.json();
      const p = j && j.data && j.data.network && j.data.network['8080/tcp'];
      if (p) _cache = { port: p, ts: Date.now() };
      else console.error('[ingress] no 8080/tcp mapping in supervisor reply — network=' +
                         JSON.stringify(j && j.data && j.data.network));
    }
  } catch (e) {
    console.error('[ingress] supervisor API unreachable (' + e.message + ') — using port ' + _cache.port);
  }
  return _cache.port;
}

// Official client assets re-served under the ingress path (relative URLs).
const ASSETS = {
  '/logo-chip.png':  { file: path.join(PUB, 'logo-chip.png'),            type: 'image/png' },
  '/login-bg.webp':  { file: path.join(PUB, 'img', 'pokerth-login-bg.webp'), type: 'image/webp' },
  '/favicon.png':    { file: path.join(PUB, 'favicon-32.png'),           type: 'image/png' },
};

http.createServer(async (req, res) => {
  const url = (req.url || '/').split('?')[0];
  const suffix = Object.keys(ASSETS).find((k) => url.endsWith(k));
  if (suffix) {
    const a = ASSETS[suffix];
    return fs.readFile(a.file, (err, buf) => {
      if (err) { res.writeHead(404); return res.end(); }
      res.writeHead(200, { 'Content-Type': a.type, 'Cache-Control': 'public, max-age=3600' });
      res.end(buf);
    });
  }

  const port = await mappedHostPort();
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-store' });
  res.end(`<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PokerTH Web Client</title>
<link rel="icon" type="image/png" href="favicon.png">
<style>
  * { box-sizing:border-box; }
  html,body { margin:0; height:100%; }
  body {
    display:flex; align-items:center; justify-content:center;
    background:#10141c; color:#eff1f5;
    font-family:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;
    overflow:hidden; position:relative;
  }
  body::before {
    content:''; position:absolute; inset:-12px;
    background:url('login-bg.webp') center / cover no-repeat;
    filter:blur(3px) brightness(.55); z-index:0;
  }
  .card {
    position:relative; z-index:1; text-align:center;
    background:rgba(29,34,43,.88); border-radius:5px;
    padding:34px 42px 30px; max-width:340px;
    box-shadow:0 10px 40px rgba(0,0,0,.55);
  }
  .card img.chip { width:96px; height:96px; display:block; margin:0 auto 14px;
    filter:drop-shadow(0 4px 10px rgba(0,0,0,.5)); }
  h1 { font-size:1.25rem; margin:0 0 4px; letter-spacing:.02em; }
  p.sub { margin:0 0 22px; font-size:.82rem; color:#cdd3e0; opacity:.75; }
  a.btn {
    display:inline-block; padding:12px 30px; border-radius:6px;
    background:#2b3444; color:#fff; text-decoration:none;
    font-weight:600; font-size:1rem; transition:background .15s, box-shadow .15s;
  }
  a.btn:hover { background:#384252; box-shadow:0 6px 24px rgba(0,0,0,.4); }
  p.small { margin:16px 0 0; font-size:.75rem; color:#cdd3e0; opacity:.6; }
</style></head><body>
<div class="card">
  <img class="chip" src="logo-chip.png" alt="PokerTH">
  <h1>PokerTH Web Client</h1>
  <p class="sub">Texas Hold'em — play in your browser</p>
  <a class="btn" id="open" href="#" target="_blank" rel="noopener">Open PokerTH</a>
  <p class="small">The table opens in its own tab on port ${port}.</p>
</div>
<script>
  var u = 'http://' + location.hostname + ':${port}/';
  document.getElementById('open').href = u;
</script>
</body></html>`);
}).listen(INGRESS_PORT, () => console.log('[ingress] landing page on :' + INGRESS_PORT));
