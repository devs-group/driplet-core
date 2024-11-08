migrate:
	docker compose exec backend deno run -A npm:node-pg-migrate up -j sql

logs:
	docker compose logs -f backend

start:
	docker compose up -d

stop:
	docker compose down
