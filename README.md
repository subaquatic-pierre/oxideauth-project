# OxideAuth Project

Multi-tenant Identity and Access Management (IAM) platform — OIDC authentication, role-based authorization, workspace management, and an admin dashboard.

## Project Structure

```
oxideauth-project/
  api/                   API (Rust / Axum / SQLx)
  macros/                Procedural macros
  dashboard/             Admin dashboard (web UI)
  docs/                  MkDocs site — API reference, concepts, architecture
  scripts/               Deployment & CI orchestration tools
  docker-compose.yaml    Orchestrates all services (Postgres, Redis, API, dashboard)
```

## Quick Start

```sh
# Start everything with Docker Compose
docker compose up -d
```

| Service   | URL                   |
| --------- | --------------------- |
| API       | http://localhost:8000 |
| Docs      | http://localhost:7000 |
| Dashboard | http://localhost:5000 |
| Postgres  | localhost:5432        |
| Redis     | localhost:6379        |

```sh
# Or run services individually:
cd api && cargo db-dev-run && cargo run --bin oxideauth
cd dashboard && npm run dev
cd docs && make serve   # docs at http://localhost:7000
```

## API

See [api/README.md](api/README.md) for API-specific documentation.

## Documentation

Built with [MkDocs](https://www.mkdocs.org/) + [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).

```sh
cd docs
source .venv/bin/activate        # or use docs/.venv/bin/python3 directly
pip install -r requirements.txt  # mkdocs, mkdocs-material, plugins
mkdocs serve                     # live-reload at http://127.0.0.1:7000
mkdocs build --strict            # static site → site/
```

### Sections

| Section             | Contents                                                                                                                                                  |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Home**            | Architecture overview with Mermaid diagrams                                                                                                               |
| **Getting Started** | Setup guide, first API calls, recommended workflow                                                                                                        |
| **API Reference**   | 62 endpoints across 12 resources — Health, Auth, Workspaces, Accounts, Projects, Profiles, Clients, Roles, Permissions, Policies, Memberships, Credentials       |
| **Concepts**        | Multi-tenancy & workspaces, RBAC & permissions, membership model                                                                                          |
| **Architecture**    | Design docs — request flow, entities, auth flow, login flow, token architecture, service factory, store module, SQLx vs Diesel, embedded worker, and more |

## CI/CD & Deployment

Each sub-module has an independent deployment pipeline with two methods:

| Method            | Trigger                                             | Description                                              |
| ----------------- | --------------------------------------------------- | -------------------------------------------------------- |
| **Git Tag Push**  | Push `*.*.*` tag to sub-module remote               | GitHub Actions workflow builds and deploys automatically |
| **Manual Script** | `make deploy [patch\|minor\|major]` from sub-module | Script bumps version, builds, tags, and pushes locally   |

### Per Sub-Module Deployment

| Sub-Module   | Deploy Type               | Commands                              | Deployment Target        |
| ------------ | ------------------------- | ------------------------------------- | ------------------------ |
| `api/`       | Build-only verification   | `make deploy patch` from `api/`       | None (verification only) |
| `docs/`      | Static site               | `make deploy patch` from `docs/`      | GitHub Pages             |
| `dashboard/` | Static site (placeholder) | `make deploy patch` from `dashboard/` | GitHub Pages             |
| `macros/`    | Crate publish             | `make deploy patch` from `macros/`    | crates.io                |

### Unified Deploy (All Sub-Modules)

```sh
# From the project root, deploy all sub-modules with a single command:
make deploy-all patch    # bump all sub-modules by patch
make deploy-all minor    # bump all sub-modules by minor
make deploy-all major    # bump all sub-modules by major

# Preview what would happen without executing:
./scripts/deploy-all.sh --dry-run patch
```

### Commit Across Sub-Modules

```sh
# Stage, commit, and push all sub-modules first, then root:
./scripts/commit-all.sh "Update all sub-modules"
# or:
make commit-all "Update all sub-modules"
```

### Tag Convention

All deployments use **semantic versioning** (e.g., `1.2.3`). Tags are created on the `main` branch. Each sub-module maintains its own independent version history.

See individual sub-module READMEs for detailed deployment instructions:

- [API Deployment](api/README.md#deployment)
- [Docs Deployment](docs/README.md#deploying-to-github-pages)
- [Dashboard Deployment](dashboard/README.md#deployment)
- [Macros Deployment](macros/README.md#deployment)
