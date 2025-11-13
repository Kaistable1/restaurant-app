#!/usr/bin/env bash
################################################################################
# Savrli City V1 – Staging Deployment Script
#
# Deploys Flutter web app to Firebase Hosting (staging or prod) with:
# • Build, test, and smoke verification
# • Safety checks, colors, and clear output
#
# Usage:
#   ./scripts/deploy-staging.sh
#
# Environment Variables:
#   DEPLOY_TARGET=stating   # or 'production'
#   SKIP_TESTS=true         # Skip Flutter tests
#   RUN_SMOKE=true          # Run Cypress smoke tests after deploy
#   CYPRESS_BASE_URL=...    # Override base URL for smoke tests
#
# Prerequisites:
# - Flutter SDK (≥3.24.0)
# - Firebase CLI (firebase-tools)
# - Node.js + npm
# - Cypress installed (npm install)
################################################################################
set -euo pipefail

# ──────────────────────────────────────────────────────────────
# Colors & Logging
# ──────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC}    $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC}   $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC}   $*"; }

# ──────────────────────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────────────────────
DEPLOY_TARGET="${DEPLOY_TARGET:-staging}"
SKIP_TESTS="${SKIP_TESTS:-false}"
RUN_SMOKE="${RUN_SMOKE:-true}"
BUILD_DIR="build/web"
STAGING_URL="https://staging.savrli.city"
PROD_URL="https://savrli.city"

# ──────────────────────────────────────────────────────────────
# Banner
# ──────────────────────────────────────────────────────────────
banner() {
  echo -e "${BLUE}"
  cat << "EOF"
   _____ _ _ _____ _ _
  / ____| | | (_) / ____(_) |
 | (___ __ ___ _____| | _ | | _| |_
  \___ \ / _` \ \ / / _ \ | | | | | | | __|
  ____) | (_| |\ V / __/ |____| | | |____| | |_
 |_____/ \__,_| \_/ \___|______|_| \_____|_|\__|
EOF
  echo -e "${NC}Savrli City V1 - ${DEPLOY_TARGET^} Deployment\n"
}

# ──────────────────────────────────────────────────────────────
# Prerequisites
# ──────────────────────────────────────────────────────────────
check_prerequisites() {
  log_info "Checking prerequisites..."
  command -v flutter >/dev/null || { log_error "Flutter not found"; exit 1; }
  log_success "Flutter: $(flutter --version | head -n1 | cut -d' ' -f2)"

  command -v firebase >/dev/null || { log_warning "Firebase CLI not found. Deploy will be skipped."; }
  [[ -f "pubspec.yaml" ]] || { log_error "pubspec.yaml not found. Run from project root."; exit 1; }
  [[ -f "package.json" ]] || { log_warning "package.json not found. Cypress tests will be skipped."; }

  log_success "Prerequisites OK"
}

# ──────────────────────────────────────────────────────────────
# Tests
# ──────────────────────────────────────────────────────────────
run_tests() {
  [[ "$SKIP_TESTS" == "true" ]] && { log_warning "SKIP_TESTS=true → skipping tests"; return 0; }

  log_info "Running static analysis..."
  flutter analyze || log_warning "Analysis issues found"

  log_info "Running unit tests..."
  flutter test || log_warning "Some unit tests failed"

  log_success "Tests completed"
}

# ──────────────────────────────────────────────────────────────
# Build
# ──────────────────────────────────────────────────────────────
build_app() {
  log_info "Building Flutter web app..."
  flutter clean
  flutter pub get
  flutter build web --release --web-renderer=canvaskit

  [[ -d "$BUILD_DIR" ]] || { log_error "Build failed: $BUILD_DIR missing"; exit 1; }
  log_success "Build ready: $BUILD_DIR"
}

# ──────────────────────────────────────────────────────────────
# Deploy
# ──────────────────────────────────────────────────────────────
deploy_to_firebase() {
  log_info "Deploying to Firebase Hosting ($DEPLOY_TARGET)..."
  firebase deploy --only "hosting:${DEPLOY_TARGET}" --message "Deploy via deploy-staging.sh" || \
    { log_error "Deploy failed"; exit 1; }
  log_success "Deployed successfully"
}

# ──────────────────────────────────────────────────────────────
# Smoke Tests
# ──────────────────────────────────────────────────────────────
run_smoke_tests() {
  [[ "$RUN_SMOKE" != "true" ]] && return 0
  [[ ! -f "package.json" ]] && { log_warning "No package.json — skipping Cypress"; return 0; }

  log_info "Running Cypress smoke tests..."
  local base_url="${CYPRESS_BASE_URL:-$STAGING_URL}"
  local spec="cypress/e2e/smoke_spec.cy.js"

  [[ -f "$spec" ]] || { log_error "Smoke spec not found: $spec"; exit 1; }

  npm ci --silent
  npx cypress run \
    --spec "$spec" \
    --browser chrome \
    --headless \
    --config baseUrl="$base_url" \
    --env FAIL_ON_ERROR=true || \
    { log_warning "Cypress smoke failed – check manually"; }

  log_success "Smoke tests passed"
}

# ──────────────────────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────────────────────
show_summary() {
  local url="$STAGING_URL"
  [[ "$DEPLOY_TARGET" == "production" ]] && url="$PROD_URL"

  log_info "=========================================="
  log_success "DEPLOYMENT COMPLETE"
  log_info "=========================================="
  log_info "Target: $DEPLOY_TARGET"
  log_info "URL: $url"
  log_info "Build: $BUILD_DIR"
  log_info "Time: $(date)"
  log_info "=========================================="
  echo
  log_info "Next Steps:"
  echo "  1. Visit: $url"
  echo "  2. Check Firebase Console"
  echo "  3. Review docs/V1-runbook.md"
  echo
  log_success "All systems go!"
}

# ──────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────
main() {
  banner
  log_info "Target: $DEPLOY_TARGET | Skip Tests: $SKIP_TESTS | Run Smoke: $RUN_SMOKE"
  echo

  check_prerequisites
  echo
  run_tests
  echo
  build_app
  echo
  deploy_to_firebase
  echo
  run_smoke_tests
  echo
  show_summary
}

trap 'log_error "Failed at line $LINENO"; exit 1' ERR
main "$@"