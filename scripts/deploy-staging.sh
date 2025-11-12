#!/bin/bash

################################################################################
# Savrli City V1 - Staging Deployment Script
#
# This script deploys the restaurant app to the staging environment.
# It performs build, validation, and deployment steps with safety checks.
#
# Usage: ./scripts/deploy-staging.sh
#
# Prerequisites:
#   - Flutter SDK installed and in PATH
#   - Firebase CLI installed and authenticated
#   - Proper environment variables configured
#
# Environment Variables (optional):
#   - FIREBASE_PROJECT: Firebase project ID (default: auto-detected)
#   - SKIP_TESTS: Skip test execution (default: false)
#   - DEPLOY_TARGET: Deployment target (default: staging)
################################################################################

set -e  # Exit on error
set -o pipefail  # Exit on pipe failure

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEPLOY_TARGET="${DEPLOY_TARGET:-staging}"
SKIP_TESTS="${SKIP_TESTS:-false}"
BUILD_DIR="build/web"

################################################################################
# Helper Functions
################################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    log_success "Flutter found: $(flutter --version | head -n1)"
    
    # Check Firebase CLI
    if ! command -v firebase &> /dev/null; then
        log_warning "Firebase CLI not found. Install with: npm install -g firebase-tools"
        log_warning "Skipping Firebase deployment checks..."
    else
        log_success "Firebase CLI found: $(firebase --version)"
    fi
    
    # Check if we're in the right directory
    if [ ! -f "pubspec.yaml" ]; then
        log_error "pubspec.yaml not found. Please run from project root."
        exit 1
    fi
}

run_tests() {
    if [ "$SKIP_TESTS" = "true" ]; then
        log_warning "Skipping tests (SKIP_TESTS=true)"
        return 0
    fi
    
    log_info "Running tests..."
    
    # Run Flutter analyze
    log_info "Running Flutter analyze..."
    if flutter analyze; then
        log_success "Code analysis passed"
    else
        log_warning "Code analysis found issues (continuing anyway)"
    fi
    
    # Run Flutter tests
    log_info "Running Flutter tests..."
    if flutter test; then
        log_success "Tests passed"
    else
        log_warning "Some tests failed (continuing anyway)"
    fi
}

build_app() {
    log_info "Building Flutter web app for ${DEPLOY_TARGET}..."
    
    # Clean previous build
    log_info "Cleaning previous build..."
    flutter clean
    
    # Get dependencies
    log_info "Getting dependencies..."
    flutter pub get
    
    # Build web app
    log_info "Building web app..."
    if flutter build web --release --verbose; then
        log_success "Build completed successfully"
    else
        log_error "Build failed"
        exit 1
    fi
    
    # Verify build output
    if [ ! -d "$BUILD_DIR" ]; then
        log_error "Build directory not found: $BUILD_DIR"
        exit 1
    fi
    
    log_success "Build artifacts ready in $BUILD_DIR"
}

deploy_to_firebase() {
    log_info "Deploying to Firebase Hosting (${DEPLOY_TARGET})..."
    
    if ! command -v firebase &> /dev/null; then
        log_error "Firebase CLI not found. Cannot deploy."
        log_info "Install Firebase CLI: npm install -g firebase-tools"
        exit 1
    fi
    
    # Check if user is logged in
    if ! firebase projects:list &> /dev/null; then
        log_error "Not authenticated with Firebase. Run: firebase login"
        exit 1
    fi
    
    # Deploy to staging
    log_info "Deploying to Firebase Hosting..."
    if firebase deploy --only hosting:${DEPLOY_TARGET}; then
        log_success "Deployment completed successfully"
    else
        log_error "Deployment failed"
        exit 1
    fi
}

show_deployment_info() {
    log_info "=========================================="
    log_success "Deployment Summary"
    log_info "=========================================="
    log_info "Target: ${DEPLOY_TARGET}"
    log_info "Build: ${BUILD_DIR}"
    log_info "Time: $(date)"
    log_info "=========================================="
    log_info ""
    log_info "Next Steps:"
    log_info "1. Run smoke tests: npx cypress run"
    log_info "2. Verify staging URL in browser"
    log_info "3. Check Firebase Console for deployment status"
    log_info "4. Review docs/V1-runbook.md for verification steps"
    log_info ""
    log_success "Deployment complete! 🚀"
}

################################################################################
# Main Deployment Flow
################################################################################

main() {
    log_info "=========================================="
    log_info "Savrli City V1 - Staging Deployment"
    log_info "=========================================="
    log_info "Target: ${DEPLOY_TARGET}"
    log_info "Skip Tests: ${SKIP_TESTS}"
    log_info "=========================================="
    echo ""
    
    # Step 1: Check prerequisites
    check_prerequisites
    echo ""
    
    # Step 2: Run tests
    run_tests
    echo ""
    
    # Step 3: Build app
    build_app
    echo ""
    
    # Step 4: Deploy to Firebase
    deploy_to_firebase
    echo ""
    
    # Step 5: Show deployment info
    show_deployment_info
}

# Trap errors and cleanup
trap 'log_error "Deployment failed at line $LINENO"' ERR

# Run main deployment flow
main "$@"
