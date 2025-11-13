#!/usr/bin/env bash
################################################################################
# Savrli City V1 – Staging Deployment Script
#
# Deploys the Flutter web app to Firebase Hosting (staging or prod).
#
# Usage:
#   ./scripts/deploy-staging.sh
#
# Env vars (optional):
#   DEPLOY_TARGET   – "staging" (default) or "production"
#   SKIP_TESTS      – "true" to skip Flutter tests/analyze
#   CYPRESS_RUN     – "true" to run Cypress smoke locally after deploy
#
# Prerequisites:
#   • Flutter SDK (≥ 3.24.0)
#   • Firebase CLI (npm install -g firebase-tools)
#   • `firebase login` already done
################################################################################
set -euo pipefail   # strict mode

# ──────────────────────────────────────────────────────────────
# Colors
# ──────────────────────────────────────────────────────────────
RED='\033[0;31m' YELLOW='\033[1;33m' GREEN='\033[0;32m' BLUE='\033[0;34m' NC='\033[0m'

log()   { echo -e "${BLUE}[INFO]${NC} $*"; }
succ()  { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*"; }

# ──────────────────────────────────────────────────────────────
# Config
# ──────────────────────────────────────────────────────────────
DEPLOY_TARGET="${DEPLOY_TARGET:-staging}"
SKIP_TESTS="${SKIP_TESTS:-false}"
RUN_CYPRESS="${CYPRESS_RUN:-false}"
BUILD_DIR="build/web"
STAGING_URL="https://staging.savrli.city"
PROD_URL="https://savrli.city"

# ──────────────────────────────────────────────────────────────
# Helpers
# ──────────────────────────────────────────────────────────────
check_cmd() {
  if ! command -v "$1" &>/dev/null; then
    err "$1 is required but not installed."
    exit 1
  fi
}

check_prereqs() {
  log "Checking prerequisites…"
  check_cmd flutter
  check_cmd firebase
  [[ -f pubspec.yaml ]] || { err "pubspec.yaml not found – run from project root."; exit 1; }

  succ "Flutter $(flutter --version | head -n1 | cut -d' ' -f2)"
  succ "Firebase CLI $(firebase --version)"
}

run_flutter_tests() {
  [[ "$SKIP_TESTS" == "true" ]] && { warn "SKIP_TESTS=true → skipping tests"; return; }

  log "Running static analysis…"
  flutter analyze || warn "Analysis issues (continuing)"

  log "Running unit tests…"
  flutter test || warn "Some tests failed (continuing)"
}

build_web() {
  log "Cleaning previous build…"
  flutter clean >/dev/null

  log "Fetching dependencies…"
  flutter pub get

  log "Building web release…"
  flutter build web --release --web-renderer=canvaskit || { err "Build failed"; exit 1; }

  [[ -d "$BUILD_DIR" ]] || { err "Build dir $BUILD_DIR missing"; exit 1; }
  succ "Web build ready → $BUILD_DIR"
}

deploy_firebase() {
  log "Deploying to Firebase Hosting ($DEPLOY_TARGET)…"
  firebase deploy --only "hosting:${DEPLOY_TARGET}" || { err "Deploy failed"; exit 1; }
  succ "Deployed successfully"
}

run_local_smoke() {
  [[ "$RUN_CYPRESS" != "true" ]] && return
  log "Running local Cypress smoke test…"
  CYPRESS_baseUrl="$(url_for_target)" \
    npx cypress run --spec "cypress/e2e/smoke_spec.cy.js" --browser chrome || \
    warn "Cypress smoke failed – check manually"
}

url_for_target() {
  [[ "$DEPLOY_TARGET" == "staging" ]] && echo "$STAGING_URL" || echo "$PROD_URL"
}

summary() {
  local url
  url="$(url_for_target)"
  log "=================================================="
  succ "DEPLOYMENT COMPLETE – $DEPLOY_TARGET"
  log "=================================================="
  log "URL: $url"
  log "Build: $BUILD_DIR"
  log "Time: $(date)"
  log "=================================================="
  log "Next steps:"
  log "  • Open $url and manually verify the flow"
  log "  • Check Firebase Console → Hosting"
  log "  • Review docs/RUNBOOK.md for full verification"
  [[ "$RUN_CYPRESS" == "true" ]] && log "  • Cypress smoke result above"
  log "=================================================="
}

# ──────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────
main() {
  log "Savrli City V1 – Deploy to $DEPLOY_TARGET"
  check_prereqs
  run_flutter_tests
  build_web
  deploy_firebase
  run_local_smoke
  summary
}

trap 'err "Script failed at line $LINENO"' ERR
main "$@"
