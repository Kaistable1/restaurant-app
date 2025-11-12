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
  - git revert <commit_hash>
  - git push origin staging

Contacts
- Engineering: #savrli-city-dev
- PM: #savrli-city-product
- On-call: See PagerDuty schedule

Concierge steps (manual onboarding assist)
1. Have the concierge team member sign up through the normal flow.
2. Walk them through the onboarding steps, noting any UI issues.
3. Guide them to complete the primary task (e.g., create first reservation or event).
4. Document any feedback or blockers in the #concierge-feedback channel.
5. Ensure they can repeat the flow independently before full rollout.
