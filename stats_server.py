from flask import Flask, Response, render_template_string
import os
import socket

app = Flask(__name__)

HTML_TMPL = """
<html>
<head><title>PROBEd Stats</title><meta charset="utf-8"><style>body{font-family:Arial,Helvetica,sans-serif}table{border-collapse:collapse}td,th{padding:6px;border:1px solid #ddd}</style></head>
<body>
<h1>PROBEd Stats</h1>
<table>
  <thead><tr><th>Metric</th><th>Value</th></tr></thead>
  <tbody>
  {% for k,v in items %}
    <tr><td>{{k}}</td><td>{{v}}</td></tr>
  {% endfor %}
  </tbody>
</table>
<p>Raw output: <a href="/raw">/raw</a></p>
</body></html>
"""


def read_stats():
    host = os.getenv('PROBED_HOST', '127.0.0.1')
    port = int(os.getenv('PROBED_PORT', '555'))
    try:
        with socket.create_connection((host, port), timeout=10) as sock:
            data = bytearray()
            while True:
                chunk = sock.recv(8192)
                if not chunk:
                    break
                data.extend(chunk)
            out = data.decode('utf-8', errors='replace')
    except Exception as e:
        out = f"error: {e}\n"
    items = []
    for line in out.splitlines():
        if not line.strip():
            continue
        if ':' in line:
            k, v = line.split(':', 1)
            items.append((k, v))
        else:
            items.append((line, ''))
    return items, out


@app.route('/')
def index():
    items, _ = read_stats()
    return render_template_string(HTML_TMPL, items=items)


@app.route('/raw')
def raw():
    _, out = read_stats()
    return Response(out, mimetype='text/plain; charset=utf-8')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
