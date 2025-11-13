# Savrli City V1 — Operations Runbook

**Last Updated:** 2025-11-13  
**Version:** 1.0.0  
**Owner:** Kaistable Engineering Team  
**Staging URL:** `https://staging.savrli.city`  
**Production URL:** `https://savrli.city`

---

## Purpose
Quick-reference guide to **deploy, verify, monitor, and rollback** the Savrli City concierge web app (Flutter + Firebase).

---

## Table of Contents
1. [Pre-Deployment Checklist](#pre-deployment-checklist)  
2. [Staging Deployment](#staging-deployment)  
3. [Smoke Test Verification](#smoke-test-verification)  
4. [Production Deployment](#production-deployment)  
5. [Rollback Procedures](#rollback-procedures)  
6. [Monitoring & Alerts](#monitoring--alerts)  
7. [Troubleshooting](#troubleshooting)  
8. [Emergency Contacts](#emergency-contacts)  
9. [Appendix](#appendix)

---

## Pre-Deployment Checklist
| Item | Status |
|------|--------|
| CI/CD pipeline passed (unit + integration) | [ ] |
| Code review approved | [ ] |
| OpenAPI spec up-to-date | [ ] |
| Environment variables configured | [ ] |
| Database migrations tested (if any) | [ ] |
| Rollback plan documented | [ ] |
| On-call engineer notified | [ ] |

---

## Staging Deployment

### 1. Prerequisites
```bash
flutter --version    # ≥ 3.24.0
firebase --version
git status           # clean working tree
