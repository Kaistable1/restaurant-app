# City Savrli Manifest

project: City Savrli
branch: feature/city-savrli
phase: Phase 1 (Pilot)

repo layout suggestion:
- apps/city-savrli (mobile/web client)
- services/api (REST API, OpenAPI)
- services/jobs (event ingestion, sync)
- infra (cdn, caching, image service)
- docs (wireframes, sitemap, db-schema, qa)

primary endpoints (Phase 1):
- GET /api/v1/city-savrli/{slug}/hub
- POST /api/v1/city-savrli/offers/{id}/redeem
