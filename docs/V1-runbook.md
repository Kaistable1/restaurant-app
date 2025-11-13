# Savrli City V1 – Operations Runbook

**Purpose**  
Quick guide to deploy, verify, monitor, and rollback the **Savrli City** restaurant concierge app (V1) in **staging** and **production**.

**Staging URL**: `https://staging.savrli.city`  
**Production URL**: `https://savrli.city`  
**Last Updated**: 2025-11-12  
**Version**: 1.0.0  
**Owner**: Kaistable Engineering Team

---

## Table of Contents
1. [Pre-Deployment Checklist](#pre-deployment-checklist)  
2. [Staging Deployment](#staging-deployment)  
3. [Smoke Test Verification](#smoke-test-verification)  
4. [Production Deployment](#production-deployment)  
5. [Rollback Procedures](#rollback-procedures)  
6. [Concierge Onboarding](#concierge-onboarding)  
7. [Monitoring & Alerts](#monitoring--alerts)  
8. [Troubleshooting](#troubleshooting)  
9. [Emergency Contacts](#emergency-contacts)  
10. [Appendix](#appendix)

---

## Pre-Deployment Checklist
Before deploying:
- [ ] All CI tests pass
- [ ] Code review approved
- [ ] `openapi.yaml` is up-to-date
- [ ] Firebase config verified
- [ ] Secrets injected (Google Services, API keys)
- [ ] Rollback plan ready
- [ ] On-call notified

---

## Staging Deployment

### Prerequisites
```bash
flutter --version  # ≥3.24.0
firebase --version
git checkout feature/savrli-v1-setup
git pull
