create-network:
	if ! docker network inspect bobapp; then \
		docker network create bobapp; \
	fi

run: create-network ## Start project
	docker compose up --force-recreate --build --remove-orphans