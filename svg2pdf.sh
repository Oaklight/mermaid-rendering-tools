#!/bin/sh
#
# Convert an SVG file to a PDF file by using headless Chrome.
# Compatible with POSIX shell
#

if [ $# -ne 2 ]; then
    echo "Usage: ./svg2pdf.sh input.svg output.pdf" >&2
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

# Create HTML template with proper escaping for shell
HTML="<html>
  <head>
    <style>
body {
  margin: 0;
}
    </style>
    <script>
function init() {
  const element = document.getElementById('targetsvg');
  const positionInfo = element.getBoundingClientRect();
  const height = positionInfo.height;
  const width = positionInfo.width;
  const style = document.createElement('style');
  style.innerHTML = \`@page {margin: 0; size: \${width}px \${height}px}\`;
  document.head.appendChild(style);
}
window.onload = init;
    </script>
  </head>
  <body>
    <img id=\"targetsvg\" src=\"${INPUT}\">
  </body>
</html>"

# Create temporary file
tmpfile=$(mktemp XXXXXX.html)
if [ $? -ne 0 ]; then
    echo "Failed to create temporary file" >&2
    exit 1
fi

# Clean up temporary file on exit
trap "rm -f \"$tmpfile\"" EXIT INT TERM

# Write HTML to temporary file
printf "%s" "$HTML" >"$tmpfile"

# Find Chrome or Chromium binary
if [ -n "$CHROME_BIN" ]; then
    CHROME="$CHROME_BIN"
else
    CHROME=""
    for bin in google-chrome chromium chromium-browser; do
        # Use 'which' instead of 'command -v' for better compatibility
        if which "$bin" >/dev/null 2>&1; then
            CHROME=$(which "$bin")
            break
        fi
    done

    if [ -z "$CHROME" ]; then
        echo "Could not find Chrome or Chromium. Set CHROME_BIN or install Chrome/Chromium." >&2
        exit 2
    fi
fi

# Convert SVG to PDF using Chrome
"$CHROME" --headless --disable-gpu --print-to-pdf="$OUTPUT" "$tmpfile"

if [ $? -eq 0 ]; then
    echo "Successfully converted $INPUT to $OUTPUT"
else
    echo "Failed to convert $INPUT to $OUTPUT" >&2
    exit 3
fi
