# OxideAuth Project

Multi-tenant Identity and Access Management (IAM) platform — OIDC authentication, role-based authorization, workspace management, and an admin dashboard.

## Project Structure

```
oxideauth-project/
  oxideauth/             API (Rust / Axum / SQLx)
  oxideauth-macros/      Procedural macros
  dashboard/             Admin dashboard (web UI)
  docs/                  MkDocs site — API reference, concepts, architecture
  docker-compose.yaml    Orchestrates all services (Postgres, Redis, API, dashboard)
```

## Quick Start

```sh
# Start everything with Docker Compose
docker compose up -d
```

| Service | URL |
|---------|-----|
| API | http://localhost:8000 |
| Docs | http://localhost:8001 |
| Postgres | localhost:5432 |
| Redis | localhost:6379 |

```sh
# Or run services individually:
cd oxideauth && cargo db-dev-run && cargo run --bin oxideauth
cd dashboard && npm run dev
cd docs && make serve   # docs at http://localhost:8000
```

## API

See [oxideauth/README.md](oxideauth/README.md) for API-specific documentation.

## Documentation

Built with [MkDocs](https://www.mkdocs.org/) + [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).

```sh
cd docs
pip install -r requirements.txt   # mkdocs, mkdocs-material, plugins
mkdocs serve                      # live-reload at http://127.0.0.1:8000
mkdocs build                      # static site → site/
```

### Sections

| Section | Contents |
|---------|----------|
| **Home** | Architecture overview with Mermaid diagrams |
| **Getting Started** | Setup guide, first API calls, recommended workflow |
| **API Reference** | 39 endpoints across 9 resources — Health, Workspaces, Accounts, Projects, Roles, Permissions, Memberships, Credentials, Tokens |
| **Concepts** | Multi-tenancy & workspaces, RBAC & permissions, membership model |
| **Architecture** | Design docs — request flow, entities, auth flow, login flow, token architecture, service factory, store module, SQLx vs Diesel, embedded worker, and more |
| **CI/CD** | Deployment pipelines with Git tags and manual scripts for each sub-module (API, docs, dashboard, macros) |
