#!/usr/bin/env bash
# Copies web/index.html into the Android app and makes it run with no internet:
# downloads pdf.js, three.js and the two web fonts, then points the page at the local copies.
set -euo pipefail
cd "$(dirname "$0")/.."
W=app/src/main/assets/www
rm -rf "$W"; mkdir -p "$W/lib" "$W/fonts"
cp web/index.html "$W/index.html"

PDFJS=https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174
THREE=https://cdnjs.cloudflare.com/ajax/libs/three.js/r128
curl -fsSL "$PDFJS/pdf.min.js"        -o "$W/lib/pdf.min.js"
curl -fsSL "$PDFJS/pdf.worker.min.js" -o "$W/lib/pdf.worker.min.js"
curl -fsSL "$THREE/three.min.js"      -o "$W/lib/three.min.js"
sed -i "s#$PDFJS/#lib/#g; s#$THREE/#lib/#g" "$W/index.html"

# Fonts (Archivo + IBM Plex Mono). If this fails the app still works with system fonts.
UA="Mozilla/5.0 (Linux; Android 14; SM-X710) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36"
FONT_CSS='https://fonts.googleapis.com/css2?family=Archivo:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500&display=swap'
if curl -fsSL -A "$UA" "$FONT_CSS" -o "$W/fonts/fonts.css"; then
  n=0
  for u in $(grep -oE 'https://fonts\.gstatic\.com/[^)]+' "$W/fonts/fonts.css" | sort -u); do
    n=$((n+1)); f="f$n.woff2"
    curl -fsSL "$u" -o "$W/fonts/$f"
    sed -i "s#$u#$f#g" "$W/fonts/fonts.css"
  done
  sed -i -E 's#https://fonts\.googleapis\.com/css2\?family=[^"]*#fonts/fonts.css#' "$W/index.html"
  echo "Bundled $n font files."
else
  echo "Fonts not downloaded; using system fonts." >&2
fi
# Drop the now-useless preconnect hints.
sed -i '/rel="preconnect"/d' "$W/index.html"

if grep -qE 'cdnjs\.cloudflare\.com' "$W/index.html"; then
  echo "ERROR: page still references the CDN:" >&2; grep -noE 'https://cdnjs[^"'"'"' ]+' "$W/index.html" >&2; exit 1
fi
echo "Offline web bundle ready in $W"
