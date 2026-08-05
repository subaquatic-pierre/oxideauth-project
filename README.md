# OxideAuth Project

Multi-tenant Identity and Access Management (IAM) platform — OIDC authentication, role-based authorization, workspace management, and an admin dashboard.

## Project Structure

```
oxideauth-project/
  oxideauth/             API (Rust / Axum / SQLx)
  oxideauth-macros/      Procedural macros
  dashboard/             Admin dashboard (web UI)
  docs/                  Architecture & design docs
  docker-compose.yaml    Infrastructure (Postgres, Redis)
  Dockerfile.dev         Dev container with hot-reload
```

## Quick Start

```sh
# 1. Start infrastructure
docker-compose up -d

# 2. Run migrations
cd oxideauth && cargo db-dev-run

# 3. Start API (with hot-reload)
make dev
# or: cargo watch -x "run --bin oxideauth"

# 4. Start dashboard
cd dashboard && npm run dev
```

## API

See [oxideauth/README.md](oxideauth/README.md) for API-specific documentation.

## Documentation

- [Architecture Overview](docs/overview.md)
- [Request Flow](docs/request_flow.md)
- [Entities & Schema](docs/entities.md)
- [Roles & Permissions](docs/roles.md)
- [Membership](docs/membership.md)
