#!/usr/bin/env bash
# Builds dist/build-it-right.{epub,html,pdf} from chapters/*.md.
# Needs pandoc. The PDF also needs Chromium or Google Chrome.
set -euo pipefail

cd "$(dirname "$0")"
name=build-it-right
mkdir -p dist

if ! command -v pandoc >/dev/null; then
  echo "pandoc is required. Install it from https://pandoc.org/installing.html" >&2
  exit 1
fi

chapters=(chapters/*.md)

pandoc --from markdown-smart metadata.yaml "${chapters[@]}" \
  --toc --toc-depth=1 \
  --css style.css \
  --split-level=1 \
  -o "dist/$name.epub"

pandoc --from markdown-smart metadata.yaml "${chapters[@]}" \
  --standalone --embed-resources \
  --toc --toc-depth=1 \
  --css style.css \
  -o "dist/$name.html"

browser=""
for candidate in chromium chromium-browser google-chrome google-chrome-stable; do
  if command -v "$candidate" >/dev/null; then
    browser=$candidate
    break
  fi
done

if [[ -z $browser ]]; then
  echo "Skipped the PDF because Chromium or Chrome was not found." >&2
else
  "$browser" --headless --disable-gpu --no-pdf-header-footer \
    --print-to-pdf="dist/$name.pdf" "file://$PWD/dist/$name.html" 2>/dev/null
fi

ls -1 dist/
