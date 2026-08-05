# OxideAuth Project

Multi-tenant Identity and Access Management (IAM) platform — OIDC authentication, role-based authorization, workspace management, and an admin dashboard.

## Project Structure

```
oxideauth-project/
  oxideauth/             API (Rust / Axum / SQLx)
  oxideauth-macros/      Procedural macros
  dashboard/             Admin dashboard (web UI)
  docs/                  Architecture & design docs
  docker-compose.yaml    Orchestrates all services (Postgres, Redis, API, dashboard)
```

## Quick Start

```sh
# Start everything with Docker Compose
docker-compose up -d

# Or run services individually:
cd oxideauth && cargo db-dev-run && cargo run --bin oxideauth
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
