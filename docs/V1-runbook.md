# Savrli City — V1 Runbook (staging)

Purpose
- Quick guide to deploy to staging, verify core flow, and rollback if needed.

Staging URL
- https://staging.example.com (replace with your staging URL)

Deploy to staging
- Command:
  - ./scripts/deploy-staging.sh
  - OR replace with your CI trigger: gh workflow run deploy-staging.yml
- Verify:
  - Open staging URL and complete the smoke flow below.
  - Check Sentry for new errors and Slack #alerts channel.

Smoke verification (manual)
1. Signup as a new user (use a test email).
2. Complete onboarding steps.
3. Perform the primary task and verify success.
4. Check analytics dashboard for events:
   - signup
   - onboarding_start
   - onboarding_complete
   - primary_task_success

Rollback
- If deploy causes issues:
  - Revert the last commit on staging branch and redeploy, or
  - Use your host's rollback mechanism (e.g., previous version in cloud console).
- Command example (git):
  - git checkout staging
  - git revert <commit-sha>
  - git push
  - ./scripts/deploy-staging.sh

On-call & contacts
- On-call engineer: See PagerDuty schedule
- Slack: #savrli-city-alerts
- Email: oncall@example.com

Manual concierge onboarding (V1 process)
1. User signs up via /signup endpoint
2. Concierge team receives notification
3. Concierge manually verifies user info
4. Concierge updates onboarding_state via admin panel or API
5. User can proceed to primary task

Known issues & workarounds
- Issue: Onboarding step 2 may timeout on slow connections
  - Workaround: Retry or increase timeout in client
- Issue: Primary task payload validation may be strict
  - Workaround: Ensure payload matches schema in openapi.yaml

Monitoring & metrics
- CloudWatch/DataDog dashboard: [staging-savrli-city]
- Key metrics:
  - signup_success_rate
  - onboarding_completion_rate
  - primary_task_success_rate
  - api_response_time_p95
