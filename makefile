-include .env

DOCKER_USER ?= knplabs
PROJECT_NAME ?= qui-paie-quoi-gael
STAGE ?= $(APP_ENV)

help: ## Display this current help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ General

.PHONY=copy-env build start stop cc php react npm-install composer-install composer-update migrations fixtures

copy-env: ## Copy .env.dist to .env
	cp --update=none .env.dist .env


build: ## Build the docker images
	docker compose --env-file .env -f docker/compose.$(STAGE).yml build

start: ## Start project
	docker compose --env-file .env -f docker/compose.$(STAGE).yml up --remove-orphans -d

stop: ## Stop project
	docker compose --env-file .env -f docker/compose.$(STAGE).yml stop

cc:  ## Clear cache
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console cache:clear --env=$(APP_ENV)

cw:  ## Warmup cache
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console cache:warmup --env=$(APP_ENV)

##@ Containers
php: ## Run bash console in php container
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm php bash

react: ## Run bash console in php container
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm react sh

##@ npm
npm-install: ## install npm dependencies
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm react npm install

##@ Composer
composer-install: ## Install composer dependencies
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php composer install

composer-update: ## Update composer dependencies
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php composer update

##@ Symfony
migrations: ## Execute migrations
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console doctrine:migrations:migrate

fixtures: ## Load fixtures
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console doctrine:fixtures:load
