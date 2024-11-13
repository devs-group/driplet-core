# 🌊 Driplet Core

A lightweight backend service for authentication and data streaming management
built with DENO 🦕.

## 🌟 Overview

Driplet Core serves as the authentication backbone and data ingestion service
for the Driplet ecosystem. The service currently handles:

- User authentication and authorization
- Data insertion into PubSub topic

## 🚀 Getting Started

### Prerequisites

- Docker and Docker Compose installed on your system
- Make (optional, but recommended for easier command execution)

### Running the Service

You can start the service using either Docker Compose directly or the prepared
Makefile commands.

#### Using Makefile

Start the service:

```bash
make start
```

Stop the service:

```bash
make stop
```

Run database migrations:

```bash
make migrate
```

Create a new database migration file

```bash
make migration name=<migration_name>
```

View backend logs:

```bash
make logs
```

#### Using Docker Compose Directly

Start the service:

```bash
docker compose up -d
```

Stop the service:

```bash
docker compose down
```

Run migrations:

```bash
docker compose exec backend deno run -A npm:node-pg-migrate up -j sql
```

View logs:

```bash
docker compose logs -f backend
```
