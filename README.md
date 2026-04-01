# VaultShare Infrastructure

Docker Compose orchestration and development environment for the VaultShare platform.
This is the **composition root** — start here to run the full stack.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine + Docker Compose

## Getting Started

1. Ensure all repositories are cloned as siblings:

   ```
   projects/
   ├── vaultshare-api/
   ├── vaultshare-frontend/
   ├── vaultshare-infra/         # You are here
   └── vaultshare-docs/          # Architecture & design decisions
   ```

2. Configure environment:

   ```bash
   cp .env.example .env
   ```

3. Start the stack:

   ```bash
   make up
   ```

   Wait for PostgreSQL and Redis health checks to pass, then Django, Celery, and the
   frontend dev server start automatically. Use `make logs` to tail output.

4. Seed demo data:

   ```bash
   make seed
   ```

5. Verify features:

   ```bash
   make verify
   ```

## Services

| Service | Description | Port |
|---|---|---|
| `api` | Django 6 REST API via gunicorn | 8000 |
| `frontend` | Vue 3 SPA via Vite dev server | 3000 |
| `db` | PostgreSQL 16 (volume-mounted) | 5432 |
| `redis` | Redis 7 (message broker + cache) | 6379 |
| `celery` | Celery worker (same image as api) | — |
| `celery-beat` | Celery Beat scheduler (periodic tasks) | — |

Health checks on `db` and `redis` ensure that `api`, `celery`, and `celery-beat` wait
until dependencies are ready before starting.

## Make Commands

All commands delegate to the API Makefile and execute inside Docker containers.

```bash
make up              # docker compose up -d --build
make down            # docker compose down
make test            # Run unit and integration tests (excludes acceptance)
make test-coverage   # Run tests with HTML coverage report
make seed            # Populate DB with demo data (5 users, shared files, audit entries)
make verify          # Run acceptance tests against the live stack
make check           # Ruff + Mypy — read-only CI gate
make format          # Ruff auto-fix + format
make logs            # Tail all container logs
```

The API repo also exposes `make shell` for a Django shell inside the container.

## Environment Variables

Configured via `.env` (copy from `.env.example`):

| Variable | Purpose | Default |
|---|---|---|
| `POSTGRES_USER` | PostgreSQL username | `vaultshare` |
| `POSTGRES_PASSWORD` | PostgreSQL password | `postgres` |
| `POSTGRES_DB` | Database name | `vaultshare` |
| `DATABASE_URL` | Full connection string | `postgres://vaultshare:postgres@db:5432/vaultshare` |
| `REDIS_URL` | Redis connection string | `redis://redis:6379/0` |
| `DJANGO_SETTINGS_MODULE` | Settings module path | `config.settings.development` |
| `SECRET_KEY` | Django secret key | `django-insecure-replace-me-in-production` |
| `DEBUG` | Debug mode toggle | `True` |
| `LOG_LEVEL` | structlog log level | `INFO` |
| `VITE_API_URL` | Frontend API base URL | `http://localhost:8000/api/v1` |

> **Production note**: `SECRET_KEY` uses a placeholder default suitable only for local
> development. In production, this must be injected via a secret manager or environment
> variable with a cryptographically random value. `DEBUG` must be `False` and
> `POSTGRES_PASSWORD` must use a strong, unique credential.

## Further Documentation

- [vaultshare-docs](https://github.com/secjur-vault-share/vaultshare-docs) — system architecture, design decisions, and implementation history
- [vaultshare-api](https://github.com/secjur-vault-share/vaultshare-api) — API endpoints, project structure, and known trade-offs
- [vaultshare-frontend](https://github.com/secjur-vault-share/vaultshare-frontend) — frontend scaffold and planned UI

## What I'd Do Next

- **Nginx reverse proxy** — add an nginx service that routes `/api/` to the Django
  container and `/` to the frontend, providing a single entry point on port 80
- **CI/CD pipeline** — GitHub Actions workflow running `make check` and `make test`
  on every PR, `make verify` on merge to main
- **Production Docker builds** — multi-stage Dockerfiles with `uv sync --frozen --no-dev`,
  gunicorn with proper worker count, and nginx serving pre-built Vue assets
- **Secret management** — replace `.env` file with injected secrets via Docker Swarm
  secrets or a cloud secret manager
- **Monitoring** — add a Prometheus metrics endpoint and Grafana dashboard for request
  latency, error rates, and Celery queue depth
