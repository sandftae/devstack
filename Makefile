# ============================================================================================
# ============================================================================================
#
# Makefile command list
#
# This Makefile contains list of BAse CLI commands needed to configure and manage env.
#
#
# If you really want to feel the power yuo should copy Powermake file content into this file
#
# ============================================================================================
# ============================================================================================

# include some base configs and vars
include ./env/etc/make/config.mk

SHELL := /bin/bash -c

# local variables to use thorough the Makefile
PROJECT_ROOT := $(shell pwd)/env
HOST_LINES := $(shell tput lines)
HOST_COLUMNS := $(shell tput cols)

# to run the builder, you must specify the host ID, otherwise it may block the
# creation and copying of the docker compose file to the host machine.
HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)

# ==============================================================================
# @@ helper command(s)
# ==============================================================================
.PHONY: help
help: ## show command list
	@printf "\033[1;33m================================================================================================\n"; \
	printf "  NOTE: This output is generated from '##' comments.   \n"; \
	printf "  Please do not change '##' location.\n"; \
	printf "  You can safely update the comment text.\n"; \
	printf "  Use the same pattern to add new command to helper list: \n"; \
	printf "\n"; \
	printf "   		.PHONY: command \n"; \
	printf "   		command: ## your fancy comment will go here after these double hashtags \n"; \
	printf "   			command execution content: \n"; \
	printf "\n"; \
	printf "================================================================================================\033[00m\n"; \
	grep -h -E '^[a-zA-Z0-9_-]+:.*##|^# @@|^[ \t]*##' $(MAKEFILE_LIST) | \
	awk ' \
	BEGIN {FS = ":.*?##"}; \
	/##/ && !/@@/ {printf "\033[1;32m%-24s\033[00m  %s\n", $$1, $$2}; \
	/^# @@/ { \
		print ""; \
		printf "\033[1;37m--- %s ---\033[00m\n", toupper(substr($$0, index($$0, "@@") + 3)); \
	}'

# ==============================================================================
# @@ docker container related commands
# ==============================================================================
.PHONY: up
up: magma-pre-check ## up docker environment
	@GREETING="$(GET_UI_GREETING)"; \
	echo -e "$(value HEADER_ART)" | sed "s/{{GREETING}}/$$GREETING/"
	@export HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) && \
	docker compose -f $(DOCKER_COMPOSER_FILE) up -d
	@echo -e "\n$(FOOTER_ART)"

.PHONY: down
down: ## down docker environment
	@/bin/bash env/bash/make/container/shutdown.sh $(PROJECT_ROOT)
	@printf "\033[1;32m[%s]\033[0m %s\n" "AMAZING DAY" "You did a great job today! Have a great evening with your loved ones!"
	@printf "\033[1;32m[%s]\033[0m %s\n" "GRATITUDE" "Grateful, Blessed, and highly Favored!"
	@printf "\n"

.PHONY: php-app
php-app: ## execute php-app docker container interactively [-it]
	docker exec -it -u php $(PHP_CONTAINER) sh

.PHONY: web-app
web-app: ## execute web-app docker container interactively [-it]
	docker exec -it devstack_web-app sh

.PHONY: rebuild-image
rebuild-image: ## rebuild a docker image based on name given. Usage: make rebuild-image name=image_name
	@if [ -z "$(name)" ]; then \
		echo -e "\033[1;31mERROR:\033[00m 'name' arg is not specified!\nUsage: \033[1mmake rebuild-image name=image_name\033[00m \n"; \
		exit 1; \
	fi
	@export HOST_UID=$(shell id -u) && \
	export HOST_GID=$(shell id -g) && \
	echo -e "\nTrying to re-built \033[1m$(name)\033[00m image... \n" && \
	docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) build --no-cache $(name) && \
    docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) up -d $(name)
	@echo -e "\nThe \033[1m$(name)\033[00m image is successfully \033[1;32mre-built.\033[00m\n"

# ==============================================================================
# @@ magento daily manipulation commands
# ==============================================================================
.PHONY: mode-production
mode-production: ## run bin/magento deploy:mode:set production and rebuild NGINX image
	@chmod +x env/bash/make/container/deploy_mode_prompt.sh
	@$(DEPLOYMENT_WARNING)
	@$(PROMPT_FOR_REBUILD)
	@env/bash/make/container/deploy_mode_prompt.sh
	-@if [ $$? -eq 0 ]; then \
		docker exec -u php $(PHP_CONTAINER) sh -c '$(BIN_MAGENTO_SET_DEPLOY_MODE_PRODUCTION)' ; \
		printf "$(_SUCCESS)" "2" "Magento deploy mode changed to PRODUCTION successfully!" ; \
		printf "$(_SUCCESS)" "3" "Changing NGINX MAGE_MODE [fastcgi_param] to PRODUCTION..." ; \
        sed -i 's/$(COMMERCE_MODE_VARIABLE)=.*/$(COMMERCE_MODE_VARIABLE)=$(PRODUCTION_MODE)/g' ./env/.env ; \
        sed -i 's/$(BYPASS_VARNISH)=.*/$(BYPASS_VARNISH)="false"/g' ./env/.env ; \
		printf "$(_SUCCESS)" "4" "NGINX MAGE_MODE changed to PRODUCTION successfully!" ; \
		printf "$(_SUCCESS)" "5" "Rebuilding NGINX image..." ; \
		export HOST_UID=$(shell id -u) && \
		export HOST_GID=$(shell id -g) && \
		docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) up -d --build  $(NGINX_IMAGE) > /dev/null 2>&1 ; \
		printf "$(_SUCCESS)" "6" "NGINX image successfully rebuilt!" ; \
		docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) up -d --build  $(SSL_PROXY_IMAGE) > /dev/null 2>&1 ; \
		printf "$(_SUCCESS)" "7" "PROXY and VARNISH are aligned with new NGINX configuration!" ; \
		printf "$(_SUCCESS)" "OK" "Great! All is Done!" ; \
		printf "$(_SUCCESS)" "OK" "If the mode hasn't changed, try restarting your Docker environment." ; \
	fi

.PHONY: mode-developer
mode-developer: ## run bin/magento deploy:mode:set developer and rebuild NGINX image
	@chmod +x env/bash/make/container/deploy_mode_prompt.sh
	@$(DEPLOYMENT_WARNING)
	@$(PROMPT_FOR_REBUILD)
	@env/bash/make/container/deploy_mode_prompt.sh
	-@if [ $$? -eq 0 ]; then \
		docker exec -u php $(PHP_CONTAINER) sh -c '$(BIN_MAGENTO_SET_DEPLOY_MODE_DEVELOPER)' > /dev/null 2>&1 ; \
		printf "$(_SUCCESS)" "2" "Magento deploy mode changed to DEVELOPER successfully!" ; \
		printf "$(_SUCCESS)" "3" "Changing NGINX MAGE_MODE [fastcgi_param] to DEVELOPER..." ; \
	 	sed -i 's/$(COMMERCE_MODE_VARIABLE)=.*/$(COMMERCE_MODE_VARIABLE)=$(DEVELOPER_MODE)/g' ./env/.env ; \
		sed -i 's/$(BYPASS_VARNISH)=.*/$(BYPASS_VARNISH)="true"/g' ./env/.env ; \
		printf "$(_SUCCESS)" "4" "NGINX MAGE_MODE changed to DEVELOPER successfully!" ; \
		printf "$(_SUCCESS)" "5" "Rebuilding NGINX image..." ; \
		export HOST_UID=$(shell id -u) && \
		export HOST_GID=$(shell id -g) && \
		docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) up -d --build  $(NGINX_IMAGE) > /dev/null 2>&1 ; \
		printf "$(_SUCCESS)" "6" "NGINX image successfully rebuilt!" ; \
		docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) up -d --build  $(SSL_PROXY_IMAGE) > /dev/null 2>&1 ; \
		printf "$(_SUCCESS)" "7" "PROXY and VARNISH are aligned with new NGINX configuration!" ; \
		printf "$(_SUCCESS)" "OK" "Great! All is Done!" ; \
		printf "$(_SUCCESS)" "OK" "If the mode hasn't changed, try restarting your Docker environment." ; \
	fi

.PHONY: varnish-production
varnish-production: ## control Varnish silence in production mode. Usage: make varnish-production silence=[true|false]
	@if [ -z "$(silence)" ]; then \
		echo -e "\033[1;31mERROR:\033[00m 'silence' arg is not specified!\nUsage: \033[1mmake varnish-production silence=true OR false\033[00m \n"; \
		exit 1; \
	fi
	@if ! [[ "$(silence)" =~ ^(true|false)$$ ]]; then \
		echo -e "\033[1;31mERROR:\033[00m Invalid value '$(silence)'. Only lowercase \033[1mtrue\033[00m or \033[1mfalse\033[00m are allowed.\n"; \
		exit 1; \
	fi
	@CURRENT_MODE=$$(grep '^ADOBE_COMMERCE_MODE=' env/.env | cut -d'=' -f2); \
	if [ "$$CURRENT_MODE" = "developer" ] && [ "$(silence)" = "true" ]; then \
		echo -e "\033[1;33mWARNING:\033[00m Adobe Commerce is currently in \033[1mdeveloper\033[00m mode.\n"; \
		echo -e "You must change mode to \033[1mproduction\033[00m first"; \
		echo -e "Otherwise, you will experience unexpected cache errors and inconsistent behavior.\n"; \
		echo -e "To change mode run \033[1mmake mode-production\033[00m.\n"; \
		exit 1; \
	fi
	@sed -i 's/DEVELOPER_MODE_BYPASS_VARNISH=.*/DEVELOPER_MODE_BYPASS_VARNISH="$(silence)"/g' ./env/.env
	@echo -e "\nRunning..."
	@docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) up -d --build  $(SSL_PROXY_IMAGE) > /dev/null 2>&1
	@echo -ne "\033[1A\033[K"
	@if [ "$(silence)" = "true" ]; then \
		echo -e "\n\033[1;32mSUCCESS:\033[00m Varnish is \033[1mSILENCED!\033[00m\n"; \
	else \
		echo -e "\n\033[1;32mSUCCESS:\033[00m Varnish is \033[1mUNSILENCED!\033[00m\n"; \
	fi
	@echo -e "Remember to either \033[1mswitch back\033[00m or run \033[1mmake mode-developer\033[00m after completion. \n"

# ==============================================================================
# @@ web-app manipulation commands
# ==============================================================================
.PHONY: node-set
node-set: ## change image container version. Usage: make node-set version=20
	@if [ -z "$(version)" ]; then \
		echo -e "\033[1;31mERROR:\033[00m 'version' arg is not specified!\nUsage: \033[1m make node-set version=number\033[00m \n"; \
		exit 1; \
	fi
	@if ! echo "$(version)" | grep -qE '^[0-9]+$$'; then \
		echo -e "\n\033[1;31mERROR:\033[00m Invalid format: '\033[1m$(version)\033[00m'. Use Major Tags (16, 18, 20).\n"; \
		exit 1; \
	fi
	@echo "Fetching available Node tags (Standard Tools Only)..."
	@ONLINE_VERSIONS=$$(curl -s ${NODE_DIST} | tr ',' '\n' | grep "version" | sed 's/.*:\"v//;s/\..*//;s/\"//' | sort -unr | grep -E "^(23|22|21|20|18|16|14)$$" | xargs); \
	if [ -z "$$ONLINE_VERSIONS" ]; then \
		echo -e "\033[1;33mWARNING:\033[00m Could not fetch versions online. Bypassing validation...\n"; \
	elif ! echo "$$ONLINE_VERSIONS" | grep -qw "$(version)"; then \
		echo -e "\n\033[1;31mERROR:\033[00m Node version '\033[1m$(version)\033[00m' is not a valid Major Release!"; \
		echo -e "\033[1mAvailable Tags\033[00m: \033[1;32m$$ONLINE_VERSIONS\033[00m\n"; \
		exit 1; \
	fi; \
	if [ $(version) -ge 17 ]; then \
		SSL_VAL="--openssl-legacy-provider"; \
	else \
		SSL_VAL=""; \
	fi; \
	sed -i "s/^NODE_VERSION=.*/NODE_VERSION=$(version)-alpine/" env/.env; \
	sed -i "s|^NODE_OPTIONS_OPEN_SSL=.*|NODE_OPTIONS_OPEN_SSL=$$SSL_VAL|" env/.env; \
	echo -e "\n\033[1mRunning web-app image rebuild for node v.${version}...\033[00m\n"; \
	export HOST_UID=$(shell id -u) && \
	export HOST_GID=$(shell id -g) && \
	docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) build --no-cache web-app && \
	docker compose -f $(COMPOSE_FILE) --project-directory $(COMPOSE_DIR) up -d web-app && \
	echo -e "\nThe \033[1mweb-app\033[00m image is successfully \033[1;32mre-built.\033[00m\n"

# ==============================================================================
# @@ database management commands
# ==============================================================================
.PHONY: create-database
create-database: ## create database if not exists. Usage: make create-database db=dbname
	@if [ -z "$(db)" ]; then \
		echo -e "\033[1;31mERROR:\033[00m 'db' arg is not specified!\nUsage: \033[1mmake create-database db=dbname\033[00m \n"; \
		exit 1; \
	fi
	@docker exec -i devstack_mysql sh -c "MYSQL_PWD='root' mysql -u root -e 'CREATE DATABASE IF NOT EXISTS $(db);'"
	@echo -e "Database \033[1m$(db)\033[00m is \033[1;32mcreated.\033[00m \n"

.PHONY: import-database
import-database: ## import dump into existing db. Usage: make import-database db=dbname file=filename.sql
	@if [ -z "$(db)" ]; then \
		echo -e "\033[1;31mERROR:\033[00m 'db' arg is not specified!\nUsage: \033[1mmake import-database db=dbname file=file.sql\033[00m \n"; \
		exit 1; \
	fi
	@if [ -z "$(file)" ]; then \
		echo -e "\033[1;31mERROR:\033[00m 'file' arg is not specified!\nUsage: \033[1mmake import-database db=dbname file=file.sql\033[00m \n"; \
		exit 1; \
	fi
	@if [ ! -f "./env/dumps/import/$(file)" ]; then \
		echo -e "\033[1;31mERROR:\033[00m file \033[1m./env/dumps/import/$(file)\033[00m not found! \n"; \
		exit 1; \
	fi
	@echo "Database: $(db)"
	@echo "Source File:     $(file)"
	@docker exec -i devstack_mysql sh -c "MYSQL_PWD='root' mysql -u root $(db)" < ./env/dumps/import/$(file)
	@echo -e "\033[1;32mDone.\033[00m\n"

# ==============================================================================
# @@ magma docker environment builder
# ==============================================================================
.PHONY: magma-build
magma-build: ## helper command is used to up docker environment builder
	@export HOST_UID=$(shell id -u) && \
	export HOST_GID=$(shell id -g) && \
    chmod +x ./env/bash/make/build/confirm_rebuild.sh && \
    COMPOSE_ENV_BUILD_FILE=./env/compose.yml ./env/bash/make/build/confirm_rebuild.sh && \
    /bin/bash env/bash/make/container/shutdown.sh $(PROJECT_ROOT) && \
    docker compose -f $(COMPOSE_ENV_BUILD_FILE) run --rm \
        -e COLUMNS=$(shell tput cols) \
        -e LINES=$(shell tput lines) \
	magma bash launcher && \
	docker compose -f ./env/compose.yml up -d --build
	@printf "\n"
	@echo -e "\n$(FOOTER_ART)\n"

.PHONY: magma-pre-check
magma-pre-check: ## helper that runs the bash function
	@chmod +x ./env/bash/make/build/check_env_ready.sh
	@. ./env/bash/make/build/check_env_ready.sh && check_env_ready $(COMPOSE_FILE) $(PROJECT_NAME)
