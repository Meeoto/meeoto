-include .env

DOCKER_USER ?= knplabs
PROJECT_NAME ?= qui-paie-quoi-gael
STAGE ?= $(APP_ENV)

help: ## Display this current help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ General

.PHONY=install-dev copy-env build push install-hooks start stop cc php phpstan php-cs-fixer composer-install composer-update create-database migrations fixtures

copy-env: ## Copy .env.dist to .env
	cp --update=none .env.dist .env


build: ## Build the docker images (options: STAGE and SERVICES)
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml build --no-cache $(SERVICES)

push: ## Push the docker images to the registry (options: STAGE)
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose -f docker/compose.$(STAGE).yml push

install-hooks: ## Add hooks to the .git
	git config core.hooksPath git/hooks
	chmod +x git/hooks/*

start: ## Start project
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml up --remove-orphans -d

stop: ## Stop project
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml stop

cc:  ## Clear cache
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console cache:clear --env=$(APP_ENV)

cw:  ## Warmup cache
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console cache:warmup --env=$(APP_ENV)

php: ## Run bash console in php container
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm php bash

phpstan: ## Run phpstan.neon
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php vendor/bin/phpstan analyse -c phpstan.neon --memory-limit=512M

php-cs-fixer: ## Run PHP CS Fixer fix command in src directory
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php vendor/bin/php-cs-fixer fix src

deptrac: ## Run deptrac
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php vendor/bin/deptrac analyse

##@ Composer
composer-install: ## Install composer dependencies
	$(MAKE) .ensure-stage-exists
		if [ "$(STAGE)" = "preprod" ] ; then \
			$(MAKE) .validate-image-tag ; \
		fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php composer install

composer-update: ## Update composer dependencies
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php composer update

##@ Symfony
create-database: ## Create database
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console doctrine:database:create

migrations: ## Execute migrations
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console doctrine:migrations:migrate

fixtures: ## Load fixtures
	$(MAKE) .ensure-stage-exists
	if [ "$(STAGE)" = "preprod" ] ; then \
		$(MAKE) .validate-image-tag ; \
	fi
	docker compose --env-file .env -f docker/compose.$(STAGE).yml run --rm --no-deps php php bin/console doctrine:fixtures:load

##@ internal targets

.ensure-stage-exists:
ifeq (,$(wildcard docker/compose.$(STAGE).yml))
	@echo "Env $(STAGE) not supported."
	@exit 1
endif

.validate-image-tag:
ifeq ($(IMAGE_TAG),)
	@echo "You can't build, push or deploy to prod without an IMAGE_TAG.\n"
	@exit 1
endif