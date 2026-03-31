# VaultShare Infrastructure

This repository contains the local development environment and Docker orchestration for the VaultShare file-sharing platform. It mounts the codebase from the sibling `vaultshare-api` and `vaultshare-frontend` directories and wires them up to PostgreSQL and Redis.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine + Docker Compose

## Getting Started

1. Ensure the backend and frontend are located alongside this repository in your local workspace:
   ```bash
   projects/
     ├── vaultshare-api/
     ├── vaultshare-frontend/
     └── vaultshare-infra/
   ```

2. Clone this repository and configure credentials:
   ```bash
   git clone https://github.com/secjur-vault-share/vaultshare-infra
   cd vaultshare-infra
   cp .env.example .env
   ```

3. Spin up the cluster:
   ```bash
   make up
   ```
   *(Wait for PostgreSQL and Redis to initialize, which triggers the Django/Celery/Vite servers. Use `docker compose logs -f` if you want to tail the logs.)*

## Architecture

This orchestration layer controls the following background services:

- **api:** The Django 6 REST API running on port `8000`.
- **frontend:** The Vue 3 SPA running on port `3000`.
- **db:** PostgreSQL database.
- **redis:** In-memory message broker for Celery tasks and caching.
- **celery:** Background task worker processing the async queue.
- **celery-beat:** Scheduled task worker.

## Further Documentation

Please refer to the [vaultshare-docs](https://github.com/secjur-vault-share/vaultshare-docs) repository for comprehensive system architecture, technical requirements, and detailed design documentation.
