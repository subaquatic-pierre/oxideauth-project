#!/usr/bin/env bash
#
# deploy-all.sh — Orchestrate deployment of all 4 sub-modules.
#
# Usage:
#   ./scripts/deploy-all.sh major|minor|patch
#   ./scripts/deploy-all.sh --dry-run major|minor|patch
#
# Each sub-module must have its own ./scripts/deploy.sh script.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# ── helpers ────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { printf "${GREEN}[deploy-all]${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}[deploy-all] WARNING:${NC} %s\n" "$*" >&2; }
err()  { printf "${RED}[deploy-all] ERROR:${NC} %s\n" "$*" >&2; exit 1; }

SUBMODULES=("api" "docs" "dashboard" "macros")

# ── parse arguments ────────────────────────────────────────────────────

DRY_RUN=false
LEVEL=""

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    major|minor|patch) LEVEL="$1"; shift ;;
    *) err "Unknown argument: $1. Usage: ./scripts/deploy-all.sh [--dry-run] major|minor|patch" ;;
  esac
done

if [ -z "${LEVEL}" ]; then
  err "Bump level is required. Usage: ./scripts/deploy-all.sh [--dry-run] major|minor|patch"
fi

log "Bump level: ${LEVEL}"
if [ "${DRY_RUN}" = true ]; then
  log "DRY RUN mode — no changes will be made."
fi

# ── pre-flight checks ──────────────────────────────────────────────────

log "Running pre-flight checks..."

for sub in "${SUBMODULES[@]}"; do
  log "[pre-flight] Checking working tree of ${sub}/…"

  if [ ! -d "${sub}" ]; then
    err "[pre-flight] Directory ${sub}/ does not exist."
  fi

  if ! git -C "${sub}" diff-index --quiet HEAD --; then
    err "[pre-flight] Working tree in ${sub}/ is dirty. Commit or stash changes before deploying."
  fi

  CURRENT_BRANCH="$(git -C "${sub}" branch --show-current)"
  if [ "${CURRENT_BRANCH}" != "main" ]; then
    err "[pre-flight] Sub-module ${sub}/ is not on main branch (current: ${CURRENT_BRANCH})."
  fi
done

log "[pre-flight] Checking root working tree…"

if ! git diff-index --quiet HEAD --; then
  err "[pre-flight] Root working tree is dirty. Commit or stash changes before deploying."
fi

ROOT_BRANCH="$(git branch --show-current)"
if [ "${ROOT_BRANCH}" != "main" ]; then
  err "[pre-flight] Root is not on main branch (current: ${ROOT_BRANCH})."
fi

log "All pre-flight checks passed."

# ── dry-run: show projected versions ────────────────────────────────────

if [ "${DRY_RUN}" = true ]; then
  echo ""
  for sub in "${SUBMODULES[@]}"; do
    LATEST="$(git -C "${sub}" describe --tags --abbrev=0 2>/dev/null || echo "0.0.0")"
    BASE="${LATEST}"
    MAJOR_V="${BASE%%.*}"
    REST="${BASE#*.}"
    MINOR_V="${REST%%.*}"
    PATCH_V="${REST#*.}"

    case "${LEVEL}" in
      major)
        MAJOR_V=$((MAJOR_V + 1))
        MINOR_V=0
        PATCH_V=0
        ;;
      minor)
        MINOR_V=$((MINOR_V + 1))
        PATCH_V=0
        ;;
      patch)
        PATCH_V=$((PATCH_V + 1))
        ;;
    esac

    NEXT="${MAJOR_V}.${MINOR_V}.${PATCH_V}"
    printf "  ${GREEN}${sub}/:${NC} ${LATEST} → ${YELLOW}${NEXT}${NC}\n"
  done
  echo ""
  log "Dry-run complete. No changes were made."
  exit 0
fi

# ── deploy each sub-module ─────────────────────────────────────────────

for sub in "${SUBMODULES[@]}"; do
  echo ""
  log "Deploying sub-module: ${sub}/"
  cd "${ROOT_DIR}/${sub}"

  if ! ./scripts/deploy.sh --yes "${LEVEL}"; then
    err "Deployment of ${sub}/ failed. See output above for details."
  fi

  log "Sub-module ${sub}/ deployed successfully."
  cd "${ROOT_DIR}"
done

# ── update root project references ─────────────────────────────────────

echo ""
log "All sub-modules deployed. Updating root project references…"

git add .

git commit -m "chore: deploy-all — bump versions"

log "Pushing root project to origin/main…"
git push origin main

echo ""
log "Done. All sub-modules deployed and root project updated."
