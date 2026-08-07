#!/usr/bin/env bash
#
# commit-all.sh — Stage, commit, and push all sub-modules first,
# then the root project.
#
# Usage:
#   ./scripts/commit-all.sh "My commit message"
#   ./scripts/commit-all.sh                 # defaults to "chore: update sub-modules"

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# ── helpers ────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { printf "${GREEN}[commit-all]${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}[commit-all] WARNING:${NC} %s\n" "$*" >&2; }
err()  { printf "${RED}[commit-all] ERROR:${NC} %s\n" "$*" >&2; exit 1; }

# ── message ────────────────────────────────────────────────────────────

MESSAGE="${1:-chore: update sub-modules}"

SUB_MODULES=("api" "docs" "dashboard" "macros")

# ── sub-modules ────────────────────────────────────────────────────────

for sub in "${SUB_MODULES[@]}"; do
  log "Processing sub-module: ${sub}/"

  if [ ! -d "${sub}" ]; then
    warn "Directory ${sub}/ does not exist. Skipping."
    continue
  fi

  cd "${sub}"

  git add .

  if git diff --cached --quiet; then
    log "Nothing to commit in ${sub}/. Skipping commit and push."
  else
    git commit -m "${MESSAGE}"
    git push origin main
    log "Pushed ${sub}/ to origin/main."
  fi

  cd "$ROOT_DIR"
done

# ── root project ───────────────────────────────────────────────────────

log "Processing root project..."

git add .

if git diff --cached --quiet; then
  log "Nothing to commit in root project. Skipping commit and push."
else
  git commit -m "${MESSAGE}"
  git push origin main
  log "Pushed root project to origin/main."
fi

log "Done."
