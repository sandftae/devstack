# ============================================================================================
# ============================================================================================
#
# Makefile command list
#
# This Makefile contains list of Base CLI commands needed to configure and manage env.
# If you really want to feel the power yuo should copy Powermake file content into this file
#
# ============================================================================================
# ============================================================================================

# include some base configs and vars
include ./env/etc/make/config.mk

# define the script path
SPINNER = /bin/bash env/bash/make/utils/spinner_wrapper.sh

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
	@$(SPINNER) '$(DOCKER_COMPOSE) up -d' "Starting containers"
	@echo -e "\n$(FOOTER_ART)"

.PHONY: down
down: ## down docker environment
	@printf "\n"
	@$(SPINNER) '$(DOCKER_COMPOSE) down' "Shutting down"
	@printf "\n\033[1;32m[%s]\033[0m %s\n" "AMAZING DAY" "You did a great job today! Have a great evening with your loved ones!"
	@printf "\033[1;32m[%s]\033[0m %s\n" "GRATITUDE" "Grateful, Blessed, and highly Favored!"
	@printf "\n"

.PHONY: php-app
php-app: ## execute php-app docker container interactively [-it]
	@docker exec -it -u php $(PHP_CONTAINER) sh

.PHONY: web-app
web-app: ## execute web-app docker container interactively [-it]
	@docker exec -it devstack_web-app sh

.PHONY: rebuild-image
rebuild-image: ## rebuild a docker image based on name given. Usage: make rebuild-image name=image_name
	@if [ -z "$(name)" ]; then \
		echo -e "\033[1;31mERROR:\033[00m 'name' arg is not specified!\n\nUsage: \033[1mmake rebuild-image name=image_name\033[00m \n"; \
		exit 1; \
	fi
	@printf "\n"
	@$(SPINNER) '$(DOCKER_COMPOSE) build --no-cache $(name) && $(DOCKER_COMPOSE) up -d $(name)' "Rebuilding $(name)"

# ==============================================================================
# @@ magento daily manipulation commands
# ==============================================================================
.PHONY: mode-production
mode-production: ## run set Adobe CCommerce app to production and rebuild NGINX image
	@$(DEPLOYMENT_WARNING)
	@$(PROMPT_FOR_REBUILD)
	@env/bash/make/container/deploy_mode_prompt.sh
	@if [ $$? -eq 0 ]; then \
  		printf "\n"; \
		$(SPINNER) "docker exec -u php $(PHP_CONTAINER) sh -c '$(BIN_MAGENTO_SET_DEPLOY_MODE_PRODUCTION)'" "Setting Adobe Commerce \033[1mproduction\033[00m mode" && \
		printf "\n" && \
		sed -i 's/$(COMMERCE_MODE_VARIABLE)=.*/$(COMMERCE_MODE_VARIABLE)=$(PRODUCTION_MODE)/g' ./env/.docker.env && \
		sed -i 's/$(BYPASS_VARNISH)=.*/$(BYPASS_VARNISH)="false"/g' ./env/.docker.env && \
		$(SPINNER) '$(DOCKER_COMPOSE) up -d --build $(NGINX_IMAGE) $(SSL_PROXY_IMAGE)' "Rebuilding \033[1mnginx & varnish\033[00m images" && \
		printf "\n\033[1;32m✔\033[0m All systems aligned to \033[1mproduction\033[00m \033[1;32msuccessfully!\033[0m\n"; \
	fi

.PHONY: mode-developer
mode-developer: ## run bin/magento deploy:mode:set developer and rebuild NGINX image
	@$(DEPLOYMENT_WARNING)
	@$(PROMPT_FOR_REBUILD)
	@env/bash/make/container/deploy_mode_prompt.sh
	@if [ $$? -eq 0 ]; then \
		$(SPINNER) "docker exec -u php -w /var/www/html $(PHP_CONTAINER) php bin/magento deploy:mode:set developer" "Setting Adobe Commerce \033[1mdeveloper\033[00m mode" && \
		sed -i 's/$(COMMERCE_MODE_VARIABLE)=.*/$(COMMERCE_MODE_VARIABLE)=$(DEVELOPER_MODE)/g' ./env/.docker.env && \
		sed -i 's/$(BYPASS_VARNISH)=.*/$(BYPASS_VARNISH)="true"/g' ./env/.docker.env && \
		$(SPINNER) '$(DOCKER_COMPOSE) up -d --build $(NGINX_IMAGE) $(SSL_PROXY_IMAGE)' "Rebuilding \033[1mnginx & varnish\033[00m images" && \
		printf "\033[1;32m✔\033[0m All systems aligned to DEVELOPER successfully!\n"; \
	fi

# ==============================================================================
# @@ php-app manipulation commands
# ==============================================================================
.PHONY: xdebug-disable
xdebug-disable: ## disable xdebug, rebuild php-app image, and re-run php-app container
	@sed -i "s|^XDEBUG_ENABLED=.*|XDEBUG_ENABLED=false|" env/.docker.env; \
	$(SPINNER) "$(DOCKER_COMPOSE) build php-app && $(DOCKER_COMPOSE) up -d php-app" "\nDisabling \033[1mXdebug\033[0m and rebuilding php-app" && \
	printf "\n\033[1;32m✔\033[0m The \033[1mphp-app\033[0m service is successfully \033[1;32mre-built\033[0m (Xdebug Off).\n\n"

.PHONY: xdebug-enable
xdebug-enable: ## enable xdebug, rebuild php-app image, and re-run php-app container
	@sed -i "s|^XDEBUG_ENABLED=.*|XDEBUG_ENABLED=true|" env/.docker.env; \
	$(SPINNER) "$(DOCKER_COMPOSE) build php-app && $(DOCKER_COMPOSE) up -d php-app" "\nEnabling \033[1mXdebug\033[0m and rebuilding php-app" && \
	printf "\n\033[1;32m✔\033[0m The \033[1mphp-app\033[0m service is successfully \033[1;32mre-built\033[0m (Xdebug On).\n\n"

# ==============================================================================
# @@ web-app manipulation commands
# ==============================================================================
.PHONY: node-set
node-set: ## change image container version. Usage: make node-set version=20
	@if [ -z "$(version)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m 'version' arg is not specified!\n\nUsage: \033[1m make node-set version=number\033[00m \n"; \
		exit 1; \
	fi
	@if ! echo "$(version)" | grep -qE '^[0-9]+$$'; then \
		echo -e "\n\033[1;31mERROR:\033[00m Invalid format: '\033[1m$(version)\033[00m'. Use Major Tags (16, 18, 20).\n"; \
		exit 1; \
	fi
	@ONLINE_VERSIONS=$$(curl -s ${NODE_DIST} | tr ',' '\n' | grep "version" | sed 's/.*:\"v//;s/\..*//;s/\"//' | sort -unr | grep -E "^(23|22|21|20|18|16|14)$$" | xargs); \
	if [ -z "$$ONLINE_VERSIONS" ]; then \
		echo -e "\n\033[1;33mWARNING:\033[00m Could not fetch versions online. Bypassing validation...\n"; \
	elif ! echo "$$ONLINE_VERSIONS" | grep -qw "$(version)"; then \
		echo -e "\n\033[1;31mERROR:\033[00m node version '\033[1m$(version)\033[00m' is not a valid Major Release!"; \
		echo -e "\n\033[1mAvailable Tags\033[00m: \033[1;32m$$ONLINE_VERSIONS\033[00m\n"; \
		exit 1; \
	fi; \
	if [ $(version) -ge 17 ]; then \
		SSL_VAL="--openssl-legacy-provider"; \
	else \
		SSL_VAL=""; \
	fi; \
	sed -i "s/^NODE_VERSION=.*/NODE_VERSION=$(version)-alpine/" env/.docker.env; \
	sed -i "s|^NODE_OPTIONS_OPEN_SSL=.*|NODE_OPTIONS_OPEN_SSL=$$SSL_VAL|" env/.docker.env; \
	$(SPINNER) \
		"$(DOCKER_COMPOSE) build web-app && $(DOCKER_COMPOSE) up -d web-app" \
		"\n\nRebuilding \033[1mweb-app\033[0m image for node \033[1;34mv.$(version)\033[0m\n\n"

# ==============================================================================
# @@ database management commands
# ==============================================================================
.PHONY: create-database
create-database: ## create database. Usage: make create-database db=dbname
	@if [ -z "$(db)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m 'db' arg is not specified!\n\nUsage: \033[1mmake create-database db=dbname\033[00m \n"; \
		exit 1; \
	fi
	@if docker exec devstack_mysql mysql -u root -p'root' -e "use $(db)" >/dev/null 2>&1; then \
		echo -ne "\nDatabase \033[1m$(db)\033[00m already \033[1;33mexists\033[00m. \n\nDo you want to overwrite it? [y/N]: " && read ans; \
		if [ "$${ans:-N}" = "y" ] || [ "$${ans:-N}" = "Y" ]; then \
			$(SPINNER) \
				"docker exec -i devstack_mysql sh -c \"MYSQL_PWD='root' mysql -u root -e 'DROP DATABASE $(db); CREATE DATABASE $(db);'\"" \
				"Re-creating database \033[1;34m$(db)\033[0m in devstack_mysql"; \
		else \
			echo -e "\033[1;33mOperation cancelled.\033[00m No changes made.\n"; \
			exit 0; \
		fi \
	else \
		$(SPINNER) \
			"docker exec -i devstack_mysql sh -c \"MYSQL_PWD='root' mysql -u root -e 'CREATE DATABASE $(db);'\"" \
			"Creating new database \033[1;34m$(db)\033[0m in devstack_mysql"; \
	fi

.PHONY: import-database
import-database: ## import dump into existing db. Usage: make import-database db=dbname file=filename.sql
	@if [ -z "$(db)" ] || [ -z "$(file)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m 'db' or 'file' arg missing!\n\nUsage: \033[1mmake import-database db=dbname file=file.sql\033[00m \n"; \
		exit 1; \
	fi
	@if [ ! -f "./env/dumps/import/$(file)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m file \033[1m./env/dumps/import/$(file)\033[00m not found! \n"; \
		exit 1; \
	fi
	@if ! docker exec devstack_mysql mysql -u root -p'root' -e "use $(db)" >/dev/null 2>&1; then \
		echo -e "\n\033[1;31mERROR:\033[00m Database '\033[1m$(db)\033[0m' does not exist.\n\nCreate it first: \033[1mmake create-database db=$(db)\033[00m\n"; \
		exit 1; \
	fi
	@echo -e "\nDatabase:    \033[1;34m$(db)\033[0m"
	@echo -e "Source File: \033[1;34m$(file)\033[0m (\033[1;33m$(shell du -h ./env/dumps/import/$(file) | cut -f1)\033[00m)"
	@echo -ne "\n\033[1;33mNOTE:\033[00m \n    Large files take time. Existing data will be \033[1;31moverwritten\033[00m if \033[1mno constraints\033[0m meet.\n\nAre you sure you want to proceed? [y/N]: " && read ans; \
	if [ "$${ans:-N}" = "y" ] || [ "$${ans:-N}" = "Y" ]; then \
		$(SPINNER) \
			"docker exec -i devstack_mysql sh -c \"MYSQL_PWD='root' mysql -u root $(db)\" < ./env/dumps/import/$(file)" \
			"Importing \033[1m$(file)\033[0m into \033[1;34m$(db)\033[0m"; \
	else \
		echo -e "\n\033[1;31mImport aborted.\033[00m\n"; \
		exit 1; \
	fi

.PHONY: dump-database
dump-database: ## export database to a zipped file. Usage: make dump-database db=dbname
	@if [ -z "$(db)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m 'db' arg is not specified!\n\nUsage: \033[1mmake create-database db=dbname\033[00m \n"; \
		exit 1; \
	fi
	$(eval DATE := $(shell date +%Y-%m-%d_%H-%M-%S))
	$(eval DEST_DIR := ./env/dumps/export)
	$(eval DUMP_NAME := $(db)_dump-$(DATE).sql.gz)
	@if ! docker exec devstack_mysql mysql -u root -p'root' -e "use $(db)" >/dev/null 2>&1; then \
		echo -e "\n\033[1;31mERROR:\033[00m Database '\033[1m$(db)\033[0m' does not exist.\n"; \
		exit 1; \
	fi
	@echo -e "\nDatabase:    \033[1;34m$(db)\033[0m"
	@echo -e "Destination: \033[1;34m$(DEST_DIR)/$(DUMP_NAME)\033[0m"
	@echo -ne "\033[1;33mNOTE:\033[00m \n    Compression \033[1mis active\033[0m. Processing may \033[1mtake a while\033[0m...\n\nAre you sure you want to export this dump? [y/N]: " && read ans; \
	if [ "$${ans:-N}" = "y" ] || [ "$${ans:-N}" = "Y" ]; then \
		mkdir -p $(DEST_DIR); \
		$(SPINNER) \
			"docker exec -i devstack_mysql sh -c \"MYSQL_PWD='root' mysqldump -u root $(db) | gzip\" > $(DEST_DIR)/$(DUMP_NAME)" \
			"Dumping and compressing \033[1;34m$(db)\033[0m"; \
	else \
		echo -e "\n\033[1;31mDump aborted.\033[00m\n"; \
		exit 1; \
	fi

# ==============================================================================
# @@ magento project install commands
# ==============================================================================
.PHONY: create-ce
create-ce: ## run magento 'composer install' command for community edition (CE) commerce version specified
	@docker exec -it -u php $(PHP_CONTAINER) bash -c "export TERM=xterm-256color && $(INSTALL_COMMERCE_CE)"
	@echo -e "\n\n\033[1;32mDONE:\033[00m installation complete.\n\n"

.PHONY: create-ee ## run magento 'composer install' command for community edition (EE) commerce version specified
create-ee: ## Install Magento Enterprise Edition
	@docker exec -it -u php $(PHP_CONTAINER) bash -c "export TERM=xterm-256color && $(INSTALL_COMMERCE_EE)"
	@echo -e "\n\n\033[1;32mDONE:\033[00m installation complete.\n\n"

.PHONY: setup-install
# @see:    ./env/etc/make/magento/setup/setup-install.mk
setup-install: ## run bin/magento setup:install command by using data specified in .commerce.env (remove .env if needed)
	docker exec -u php $(PHP_CONTAINER) sh -c '$(BIN_MAGENTO_SETUP_INSTALL)'

.PHONY: setup-new-admin
# @see:    ./env/etc/make/magento/setup/new-admin.mk
setup-new-admin: ## create new admin user (e.g., admin100500) or throws an error if exists
	docker exec -u php $(PHP_CONTAINER) sh -c '$(BIN_MAGENTO_CREATE_ADMIN_USER)'

# ==============================================================================
# @@ magma docker environment builder
# ==============================================================================
.PHONY: magma-build
magma-build: ## helper command is used to up docker environment builder
	@export HOST_UID=$(shell id -u) && \
	export HOST_GID=$(shell id -g) && \
    COMPOSE_FILE=$(DOCKER_COMPOSE_FILE) ./env/bash/make/build/confirm_rebuild.sh && \
    /bin/bash env/bash/make/container/shutdown.sh $(DOCKER_COMPOSE) && \
    docker compose -f $(COMPOSE_ENV_BUILD_FILE) run --rm \
        -e COLUMNS=$(shell tput cols) \
        -e LINES=$(shell tput lines) \
	magma bash launcher && \
	$(DOCKER_COMPOSE) up -d --build
	@printf "\n"
	@echo -e "\n$(FOOTER_ART)\n"

.PHONY: magma-pre-check
magma-pre-check: ## helper that runs the bash function
	@. ./env/bash/make/build/check_env_ready.sh && check_env_ready $(DOCKER_COMPOSE_FILE) $(PROJECT_NAME)
