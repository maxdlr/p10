MAKEFLAGS += --no-print-directory -s

default: help

run: ## Start project
	docker compose up --force-recreate --build --remove-orphans

back-tests: ## Run Back-end tests
	cd back && mvn clean test
	make back-tests-report

back-tests-report: ## Open tests coverage report
	open back/target/site/jacoco/index.html

update-docker-image: ## Build and Push new Docker image
	docker build -t maxdlr/bobapp:latest .
	docker push maxdlr/bobapp:latest

help: ## Show this help menu
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF}' $(MAKEFILE_LIST)