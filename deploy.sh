#!/usr/bin/env bash
# ──────────────────────────────────────────────────────
#  Favour Economy — one-command deploy
#  Usage:
#    ./deploy.sh               # push to GitHub Pages (live ~60s)
#    ./deploy.sh netlify       # deploy to Netlify (requires netlify login once)
#    ./deploy.sh netlify-draft # Netlify draft preview URL
# ──────────────────────────────────────────────────────
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

MODE="${1:-github}"

# ── Commit any changes ──
if [[ -n "$(git status --porcelain)" ]]; then
  git add -A
  MSG="Update: $(date '+%Y-%m-%d %H:%M')"
  git commit -m "$MSG"
  echo "✓ Committed: $MSG"
else
  echo "✓ Nothing new to commit."
fi

if [[ "$MODE" == "github" ]]; then
  git push origin main
  echo ""
  echo "✓ Pushed to GitHub."
  echo "  Live at: https://boarderonatrip.github.io/favour-economy/"
  echo "  (GitHub Pages takes ~60s to rebuild)"

elif [[ "$MODE" == "netlify" ]]; then
  if ! command -v netlify &>/dev/null; then
    echo "Installing Netlify CLI..."
    npm install -g netlify-cli
  fi
  git push origin main
  netlify deploy --dir="$DIR" --prod
  echo "✓ Deployed to Netlify."

elif [[ "$MODE" == "netlify-draft" ]]; then
  if ! command -v netlify &>/dev/null; then
    npm install -g netlify-cli
  fi
  netlify deploy --dir="$DIR"
  echo "✓ Draft deploy ready — check URL above."

else
  echo "Unknown mode: $MODE"
  echo "Usage: ./deploy.sh [github|netlify|netlify-draft]"
  exit 1
fi
