#!/usr/bin/env bash
# Simple deploy script (placeholder) — replace the commands with your actual deploy steps.
set -e

echo "Building..."
npm ci
npm run build

echo "Deploying to staging..."
# Example: rsync, scp, or a cloud provider CLI (replace with real commands)
# rsync -avz build/ user@staging-server:/var/www/savrli-city
# or: gcloud app deploy --version=staging
echo "(REPLACE this line with your deploy command)"

echo "Running smoke tests (local quick check)..."
# Optionally run local smoke tests
# npx cypress run --spec "cypress/integration/smoke_spec.cy.js"

echo "Deploy complete. Visit: https://staging.example.com"
