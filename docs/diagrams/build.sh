#!/usr/bin/env bash
# Render every Mermaid source in src/ to an SVG with a white background.
#
# Usage (from any directory):
#   bash docs/diagrams/build.sh            # render all diagrams
#   bash docs/diagrams/build.sh NAME ...   # render only src/NAME.mmd
#
# Requirements: Node.js and @mermaid-js/mermaid-cli. Version 10.9.1 is pinned
# because it runs on Node 18; newer releases require Node >= 22.13.
# Set MMDC to an installed mmdc binary to avoid the npx download, for example:
#   MMDC=/path/to/node_modules/.bin/mmdc bash docs/diagrams/build.sh
# Set PNG_DIR to also write PNG previews (useful for visual review).
set -euo pipefail

DIAGRAM_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIAGRAM_DIR"
MMDC="${MMDC:-npx -y @mermaid-js/mermaid-cli@10.9.1}"
CONFIG="$DIAGRAM_DIR/mermaid-config.json"

if [ "$#" -gt 0 ]; then
    sources=()
    for name in "$@"; do sources+=("src/$name.mmd"); done
else
    sources=(src/*.mmd)
fi

for source in "${sources[@]}"; do
    name="$(basename "$source" .mmd)"
    echo "Rendering $name.svg"
    $MMDC -q -i "$source" -o "$name.svg" -b white -c "$CONFIG"
    if [ -n "${PNG_DIR:-}" ]; then
        mkdir -p "$PNG_DIR"
        $MMDC -q -i "$source" -o "$PNG_DIR/$name.png" -b white -c "$CONFIG" -s 2
    fi
done
echo "Rendered ${#sources[@]} diagram(s) into $DIAGRAM_DIR"
