MAKEFLAGS += --no-print-directory -s

default: help

run: ## Start project
	docker compose up --force-recreate --build --remove-orphans
help: ## Show this help menu
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF}' $(MAKEFILE_LIST)