# Savrli City V1 Operations Runbook

## Overview
This runbook provides operational procedures for deploying, verifying, and managing the Savrli City restaurant concierge application V1. It covers staging deployment, smoke test verification, rollback procedures, and concierge onboarding steps.

**Last Updated:** 2025-11-12  
**Version:** 1.0.0  
**Owner:** Kaistable Team

---

## Table of Contents
1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [Staging Deployment](#staging-deployment)
3. [Smoke Test Verification](#smoke-test-verification)
4. [Production Deployment](#production-deployment)
5. [Rollback Procedures](#rollback-procedures)
6. [Concierge Onboarding Steps](#concierge-onboarding-steps)
7. [Monitoring and Alerts](#monitoring-and-alerts)
8. [Troubleshooting](#troubleshooting)
9. [Emergency Contacts](#emergency-contacts)

---

## Pre-Deployment Checklist

Before deploying to staging or production, ensure:

- [ ] All tests pass in CI/CD pipeline
- [ ] Code review completed and approved
- [ ] OpenAPI spec is up-to-date (`openapi.yaml`)
- [ ] Environment variables configured correctly
- [ ] Database migrations (if any) tested in staging
- [ ] Firebase project configuration verified
- [ ] Rollback plan documented
- [ ] On-call engineer notified
- [ ] Maintenance window scheduled (if needed)

---

## Staging Deployment

### Prerequisites
- Flutter SDK installed (v3.24.0 or higher)
- Firebase CLI installed and authenticated (`firebase login`)
- Access to staging Firebase project
- Repository cloned and on correct branch

### Deployment Steps

#### 1. Prepare Environment
```bash
# Navigate to project directory
cd /path/to/restaurant-app

# Ensure on correct branch
git checkout feature/savrli-v1-setup
git pull origin feature/savrli-v1-setup

# Verify environment
flutter doctor
firebase projects:list
```

#### 2. Run Pre-Deployment Tests
```bash
# Run code analysis
flutter analyze

# Run unit tests
flutter test

# Optional: Run integration tests
# flutter test integration_test/
```

#### 3. Execute Deployment Script
```bash
# Standard deployment
./scripts/deploy-staging.sh

# Skip tests (if already run)
SKIP_TESTS=true ./scripts/deploy-staging.sh

# Specify deployment target explicitly
DEPLOY_TARGET=staging ./scripts/deploy-staging.sh
```

#### 4. Verify Deployment
```bash
# Check Firebase deployment status
firebase hosting:channel:list

# View deployment logs
firebase hosting:channel:open staging
```

#### 5. Record Deployment
- Document deployment time and version
- Note any issues encountered
- Update deployment log in project management tool

**Expected Deployment Time:** 5-10 minutes

---

## Smoke Test Verification

After staging deployment, run smoke tests to verify critical flows.

### Automated Smoke Tests

#### 1. Run Cypress Tests
```bash
# Install dependencies (first time only)
npm install --save-dev cypress@13

# Run smoke tests against staging
CYPRESS_baseUrl=https://staging.savrli.city npx cypress run \
  --spec "cypress/integration/smoke_spec.cy.js" \
  --browser chrome

# Run with headed browser (for debugging)
CYPRESS_baseUrl=https://staging.savrli.city npx cypress open
```

#### 2. Review Test Results
- Check for any test failures
- Review screenshots (if failures occurred)
- Examine video recordings
- Verify all critical flows passed:
  - ✅ Application loads
  - ✅ User signup flow
  - ✅ Concierge onboarding
  - ✅ Primary task creation

### Manual Verification

#### 1. Basic Application Health
- [ ] Navigate to staging URL: `https://staging.savrli.city`
- [ ] Verify app loads without console errors
- [ ] Check responsive design on mobile and desktop
- [ ] Confirm all assets load correctly (images, fonts, etc.)

#### 2. User Signup Flow
- [ ] Navigate to signup page
- [ ] Create test account with valid credentials
- [ ] Verify email validation works
- [ ] Confirm successful signup redirects to onboarding

#### 3. Concierge Onboarding
- [ ] Complete all onboarding steps
- [ ] Select cuisine preferences
- [ ] Set dietary restrictions
- [ ] Configure location settings
- [ ] Verify onboarding completion

#### 4. Primary Task Creation
- [ ] Create a restaurant reservation request
- [ ] Enter all required details
- [ ] Submit task successfully
- [ ] Verify task appears in dashboard
- [ ] Check task status updates

#### 5. API Endpoint Verification
```bash
# Test signup endpoint
curl -X POST https://staging-api.savrli.city/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123!",
    "firstName": "Test",
    "lastName": "User"
  }'

# Test onboarding endpoint (requires auth token)
curl -X POST https://staging-api.savrli.city/v1/onboarding \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "preferences": {
      "cuisines": ["Italian", "Japanese"],
      "priceRange": "moderate"
    },
    "location": {
      "city": "San Francisco",
      "zipCode": "94102"
    }
  }'

# Test primary task endpoint (requires auth token)
curl -X POST https://staging-api.savrli.city/v1/tasks/primary \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "taskType": "reservation",
    "details": {
      "restaurantName": "The Blue Duck",
      "partySize": 4
    }
  }'
```

**Verification Time:** 15-20 minutes

---

## Production Deployment

### Pre-Production Checklist
- [ ] Staging verification completed successfully
- [ ] All smoke tests passed
- [ ] Product owner approval obtained
- [ ] Release notes prepared
- [ ] Monitoring dashboards ready
- [ ] On-call team notified
- [ ] Rollback plan reviewed

### Deployment Steps

#### 1. Create Production Build
```bash
# Switch to main branch
git checkout main
git pull origin main

# Merge staging branch (if applicable)
git merge feature/savrli-v1-setup

# Build for production
flutter clean
flutter pub get
flutter build web --release
```

#### 2. Deploy to Production
```bash
# Deploy to production Firebase hosting
DEPLOY_TARGET=production ./scripts/deploy-staging.sh

# Or manually with Firebase CLI
firebase deploy --only hosting:production
```

#### 3. Post-Deployment Verification
- Run smoke tests against production
- Monitor error rates and performance metrics
- Verify critical user flows
- Check analytics for any anomalies

#### 4. Communication
- Notify team of successful deployment
- Update status page
- Send release announcement
- Document deployment in changelog

**Expected Deployment Time:** 10-15 minutes

---

## Rollback Procedures

### When to Rollback
- Critical bugs affecting user experience
- Data integrity issues
- Performance degradation
- Security vulnerabilities discovered
- Failed smoke tests

### Quick Rollback Steps

#### Method 1: Firebase Hosting Rollback
```bash
# List recent deployments
firebase hosting:channel:list

# Rollback to previous version
firebase hosting:rollback

# Or rollback to specific version
firebase hosting:rollback --site=savrli-city --version=VERSION_ID
```

#### Method 2: Git Revert and Redeploy
```bash
# Revert to previous commit
git revert HEAD
git push origin main

# Redeploy previous version
./scripts/deploy-staging.sh
```

#### Method 3: Manual Rollback
1. Navigate to Firebase Console
2. Go to Hosting section
3. Select deployment history
4. Choose previous version
5. Click "Rollback"

### Post-Rollback Actions
- [ ] Verify application functionality
- [ ] Notify team of rollback
- [ ] Document rollback reason
- [ ] Create incident report
- [ ] Schedule post-mortem
- [ ] Plan fix and redeployment

**Expected Rollback Time:** 5-10 minutes

---

## Concierge Onboarding Steps

### New Concierge Setup

#### 1. Account Creation
- Access admin panel: `https://admin.savrli.city`
- Navigate to "Concierge Management"
- Click "Add New Concierge"
- Enter concierge details:
  - Full name
  - Email address
  - Phone number
  - Languages spoken
  - Service areas (cities/neighborhoods)
  - Specialties (cuisine types, restaurant types)

#### 2. Training Materials
Provide concierge with:
- [ ] Platform overview presentation
- [ ] User flow documentation
- [ ] Restaurant database access
- [ ] Communication guidelines
- [ ] Reservation system training
- [ ] Customer service protocols

#### 3. System Access
Grant concierge access to:
- [ ] Task management dashboard
- [ ] Restaurant partner database
- [ ] Communication platform
- [ ] Reservation systems
- [ ] Customer profiles (limited)
- [ ] Reporting tools

#### 4. Trial Period
- Assign test tasks for practice
- Monitor first 10 real requests
- Provide feedback and coaching
- Evaluate performance metrics
- Conduct weekly check-ins

#### 5. Full Activation
After successful trial:
- [ ] Remove training wheels
- [ ] Assign full task queue
- [ ] Add to on-call rotation
- [ ] Grant full platform access
- [ ] Include in team communications

### Concierge Performance Metrics
- Response time to new requests
- Task completion rate
- Customer satisfaction scores
- Restaurant partner feedback
- Adherence to protocols

---

## Monitoring and Alerts

### Key Metrics to Monitor

#### Application Health
- Uptime (target: 99.9%)
- Page load time (target: <3s)
- Error rate (target: <0.1%)
- API response time (target: <500ms)

#### User Metrics
- New signups per day
- Onboarding completion rate
- Task creation rate
- User retention rate
- Active users (DAU/MAU)

#### Business Metrics
- Reservations completed
- Concierge response time
- Customer satisfaction (CSAT)
- Restaurant partner utilization

### Monitoring Tools
- **Firebase Analytics:** User behavior and app performance
- **Firebase Crashlytics:** Error tracking and crash reporting
- **Google Analytics:** Web traffic and conversions
- **Uptime Robot:** Application availability monitoring
- **Custom Dashboard:** Business metrics and KPIs

### Alert Configuration
Set up alerts for:
- App downtime > 2 minutes
- Error rate > 1% for 5 minutes
- API response time > 1s for 10 minutes
- Failed deployment
- Database connection issues
- Auth service failures

### Alert Channels
- **Critical:** PagerDuty + SMS + Slack #ops-critical
- **Warning:** Slack #ops-warnings + Email
- **Info:** Slack #ops-info

---

## Troubleshooting

### Common Issues

#### Issue: App Won't Load
**Symptoms:** Blank screen, loading spinner doesn't stop
**Diagnosis:**
```bash
# Check browser console for errors
# Verify Firebase hosting is up
firebase hosting:channel:list

# Check build artifacts
ls -la build/web/
```
**Resolution:**
- Clear browser cache
- Redeploy if needed
- Check Firebase status page

#### Issue: Signup Fails
**Symptoms:** Error message on signup form, API returns 400/500
**Diagnosis:**
```bash
# Check Firebase Auth logs
firebase auth:export users.json

# Test API endpoint
curl -X POST https://api.savrli.city/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123!"}'
```
**Resolution:**
- Verify Firebase Auth is enabled
- Check API credentials
- Review error logs
- Validate input data

#### Issue: Cypress Tests Fail
**Symptoms:** Tests timeout, selectors not found
**Diagnosis:**
```bash
# Run tests with debug output
DEBUG=cypress:* npx cypress run

# Check test screenshots
open cypress/screenshots/
```
**Resolution:**
- Update selectors if UI changed
- Increase timeouts
- Verify app is running
- Check test data

#### Issue: Deployment Fails
**Symptoms:** Deploy script errors, Firebase CLI errors
**Diagnosis:**
```bash
# Check Flutter build
flutter build web --verbose

# Check Firebase auth
firebase projects:list

# Review deploy script logs
./scripts/deploy-staging.sh 2>&1 | tee deploy.log
```
**Resolution:**
- Re-authenticate with Firebase
- Clear Flutter cache: `flutter clean`
- Check network connectivity
- Verify project permissions

---

## Emergency Contacts

### On-Call Rotation
- **Primary On-Call:** [Name] - [Phone] - [Email]
- **Secondary On-Call:** [Name] - [Phone] - [Email]
- **Escalation:** [Manager Name] - [Phone] - [Email]

### Team Contacts
- **Engineering Lead:** engineering@kaistable.com
- **Product Manager:** product@kaistable.com
- **DevOps:** devops@kaistable.com
- **Support Team:** support@kaistable.com

### External Services
- **Firebase Support:** https://firebase.google.com/support
- **Google Cloud Support:** [Account Number]
- **Third-Party APIs:** [Contact Info]

### Escalation Path
1. **Level 1:** On-call engineer (Response: 15 min)
2. **Level 2:** Engineering lead (Response: 30 min)
3. **Level 3:** VP Engineering (Response: 1 hour)
4. **Level 4:** CTO (Critical incidents only)

### Communication Channels
- **Slack Channels:**
  - #ops-critical (critical incidents)
  - #ops-warnings (warnings and issues)
  - #ops-info (deployments and updates)
  - #engineering (general engineering)
- **Status Page:** status.savrli.city
- **Incident Management:** [PagerDuty/Incident.io]

---

## Appendix

### Useful Commands

```bash
# Flutter commands
flutter doctor -v
flutter pub get
flutter pub upgrade
flutter clean
flutter build web --release

# Firebase commands
firebase login
firebase projects:list
firebase use staging
firebase deploy --only hosting
firebase hosting:channel:list
firebase hosting:rollback

# Git commands
git status
git log --oneline -10
git checkout -b feature/my-feature
git push origin feature/my-feature

# Cypress commands
npx cypress open
npx cypress run
npx cypress run --spec "cypress/integration/smoke_spec.cy.js"
```

### Environment Variables

```bash
# Staging
export FIREBASE_PROJECT=savrli-city-staging
export API_BASE_URL=https://staging-api.savrli.city/v1
export DEPLOY_TARGET=staging

# Production
export FIREBASE_PROJECT=savrli-city-prod
export API_BASE_URL=https://api.savrli.city/v1
export DEPLOY_TARGET=production
```

### Links
- [Firebase Console](https://console.firebase.google.com/)
- [GitHub Repository](https://github.com/Kaistable1/restaurant-app)
- [API Documentation](./openapi.yaml)
- [CI/CD Pipeline](./.github/workflows/ci.yml)
- [Architecture Docs](./city-savrli-phase1.md)

---

## Changelog

### Version 1.0.0 (2025-11-12)
- Initial V1 runbook creation
- Added staging deployment procedures
- Added smoke test verification steps
- Added rollback procedures
- Added concierge onboarding guide
- Added monitoring and troubleshooting sections

---

**Document Maintained By:** Kaistable Engineering Team  
**Review Frequency:** Monthly  
**Next Review Date:** 2025-12-12
