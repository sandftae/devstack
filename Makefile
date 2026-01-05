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
# ==============================================================================
# @@ help command
# ==============================================================================
.PHONY: help
help: ## show this help message
	@printf "$(HELP_NOTE)"
	@printf "\n\033[1;34mMAINTENANCE COMMANDS FOR $(PROJECT_NAME)\033[0m\n"
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } \
		/^# @@/ { printf "\n\033[1;33m%s\033[0m\n", substr($$0, 6) } ' $(MAKEFILE_LIST)
	@printf "\n"

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
	else \
		printf "\n" ; \
		$(SPINNER) '$(DOCKER_COMPOSE) build --no-cache $(name) && $(DOCKER_COMPOSE) up -d $(name)' "Rebuilding: \033[1m$(name)\033[00m" ; \
		printf "\n" ; \
	fi

# ==============================================================================
# @@ magento daily manipulation commands
# ==============================================================================
.PHONY: mode-production
mode-production: ## run set Adobe Commerce app to production and rebuild NGINX image
	@$(DEPLOYMENT_WARNING)
	@$(PROMPT_FOR_REBUILD)
	@if env/bash/make/container/deploy_mode_prompt.sh; then \
		printf "\n"; \
		$(SPINNER) "docker exec -u php $(PHP_CONTAINER) sh -c '$(BIN_MAGENTO_SET_DEPLOY_MODE_PRODUCTION)'" "Setting Adobe Commerce \033[1mproduction\033[00m mode"; \
		printf "\n"; \
		sed -i 's/$(COMMERCE_MODE_VARIABLE)=.*/$(COMMERCE_MODE_VARIABLE)=$(PRODUCTION_MODE)/g' ./env/.docker.env; \
		sed -i 's/$(BYPASS_VARNISH)=.*/$(BYPASS_VARNISH)="false"/g' ./env/.docker.env; \
		$(SPINNER) '$(DOCKER_COMPOSE) up -d --build $(NGINX_IMAGE) $(SSL_PROXY_IMAGE)' "Rebuilding \033[1mnginx & varnish\033[00m images"; \
		printf "\n\033[1;32m✔\033[0m All systems aligned to \033[1mproduction\033[00m \033[1;32msuccessfully!\033[0m\n"; \
	else \
		printf "\n"; \
	fi

.PHONY: mode-developer
mode-developer: ## run bin/magento deploy:mode:set developer
	@$(DEPLOYMENT_WARNING)
	@$(PROMPT_FOR_REBUILD)
	@if env/bash/make/container/deploy_mode_prompt.sh; then \
		$(SPINNER) "docker exec -u php $(PHP_CONTAINER) sh -c '$(BIN_MAGENTO_SET_DEPLOY_MODE_DEVELOPER)'" "Setting Adobe Commerce \033[1mdeveloper\033[00m mode"; \
		sed -i 's/$(COMMERCE_MODE_VARIABLE)=.*/$(COMMERCE_MODE_VARIABLE)=$(DEVELOPER_MODE)/g' ./env/.docker.env; \
		sed -i 's/$(BYPASS_VARNISH)=.*/$(BYPASS_VARNISH)="true"/g' ./env/.docker.env; \
		printf "\n"; \
		$(SPINNER) '$(DOCKER_COMPOSE) up -d --build $(NGINX_IMAGE) $(SSL_PROXY_IMAGE)' "Recreating \033[1mcontainers\033[00m"; \
		printf "\n\033[1;32m✔\033[0m All systems aligned to \033[1mDEVELOPER\033[00m successfully!\n"; \
	else \
		printf "\n"; \
	fi

.PHONY: varnish-production
varnish-production: ## control Varnish silence in production mode
	@CURRENT_MODE=$$(grep '^ADOBE_COMMERCE_MODE=' env/.docker.env | cut -d'=' -f2 | tr -d '"' | tr -d "'"); \
	if [ -z "$(silence)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m 'silence' arg is not specified!\n\nUsage: \033[1mmake varnish-production silence=true OR false\033[00m \n"; \
	elif ! [[ "$(silence)" =~ ^(true|false)$$ ]]; then \
		echo -e "\033[1;31mERROR:\033[00m Invalid value '$(silence)'. Only lowercase \033[1mtrue\033[00m or \033[1mfalse\033[00m are allowed.\n"; \
	elif [ "$$CURRENT_MODE" = "developer" ] && [ "$(silence)" = "true" ]; then \
		echo -e "\033[1;33mWARNING:\033[00m Adobe Commerce is currently in \033[1mdeveloper\033[00m mode."; \
		echo -e "You must change mode to \033[1mproduction\033[00m first."; \
		echo -e "\nRun \033[1mmake mode-production\033[00m\n"; \
	else \
		sed -i 's/DEVELOPER_MODE_BYPASS_VARNISH=.*/DEVELOPER_MODE_BYPASS_VARNISH="$(silence)"/g' ./env/.docker.env; \
		printf "\n"; \
		$(SPINNER) '$(DOCKER_COMPOSE) up -d --build $(SSL_PROXY_IMAGE)' "Configuring Varnish \033[1msilence\033[00m"; \
		if [ "$(silence)" = "true" ]; then STATUS="\033[1mSILENCED\033[0m"; else STATUS="\033[1mUNSILENCED\033[0m"; fi; \
		printf "\033[1;32m✔\033[0m Varnish is now $$STATUS!\n"; \
		printf "\n"; \
		echo -e "Remember to either \033[1mswitch back\033[00m or run \033[1mmake mode-developer\033[00m after completion.\n"; \
	fi

.PHONY: mode-show
mode-show: ## run bin/magento deploy:mode:show
	@docker exec -u php $(PHP_CONTAINER) sh -c '$(BIN_MAGENTO_DEPLOY_MODE_SHOW)'

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
	elif ! echo "$(version)" | grep -qE '^[0-9]+$$'; then \
		echo -e "\n\033[1;31mERROR:\033[00m Invalid format: '\033[1m$(version)\033[00m'. Use major tags \033[1m(eg. 16, 18, 20, etc.)\033[00m.\n"; \
	else \
		ONLINE_VERSIONS=$$(curl -s --max-time 2 ${NODE_DIST} | tr ',' '\n' | grep "version" | sed 's/.*:\"v//;s/\..*//;s/\"//' | sort -unr | grep -E "^(23|22|21|20|18|16|14)$$" | xargs); \
		if [ -n "$$ONLINE_VERSIONS" ] && ! echo "$$ONLINE_VERSIONS" | grep -qw "$(version)"; then \
			echo -e "\033[1;31mERROR:\033[00m node version '\033[1m$(version)\033[00m' is not a valid m\033[1major release\033[00m!"; \
			echo -e "\n\033[1mAvailable Tags\033[00m: \033[1;32m$$ONLINE_VERSIONS\033[00m\n"; \
		else \
			if [ -z "$$ONLINE_VERSIONS" ]; then \
				echo -e "\033[1;33mWARNING:\033[00m Could not fetch versions online. Bypassing validation...\n"; \
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
				"Rebuilding \033[1mweb-app\033[0m image for node \033[1;34mv.$(version)\033[0m"; \
		fi; \
	fi

# ==============================================================================
# @@ database management commands
# ==============================================================================
.PHONY: create-database
create-database: ## create database. Usage: make create-database db=dbname
	@if [ -z "$(db)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m 'db' arg is not specified!\n\nUsage: \033[1mmake create-database db=dbname\033[00m \n"; \
	elif docker exec devstack_mysql mysql -u root -p'root' -e "use $(db)" >/dev/null 2>&1; then \
		echo -ne "\nDatabase \033[1m$(db)\033[00m already \033[1;33mexists\033[00m. \n\nDo you want to overwrite it? [y/N]: " && read ans; \
		if [ "$${ans:-N}" = "y" ] || [ "$${ans:-N}" = "Y" ]; then \
			$(SPINNER) \
				"docker exec -i devstack_mysql sh -c \"MYSQL_PWD='root' mysql -u root -e 'DROP DATABASE $(db); CREATE DATABASE $(db);'\"" \
				"Re-creating database \033[1;34m$(db)\033[0m"; \
		else \
			echo -e "\n\033[1;33mOperation cancelled.\033[00m No changes made.\n"; \
		fi; \
	else \
		$(SPINNER) \
			"docker exec -i devstack_mysql sh -c \"MYSQL_PWD='root' mysql -u root -e 'CREATE DATABASE $(db);'\"" \
			"Creating new database \033[1;34m$(db)\033[0m in devstack_mysql"; \
	fi

.PHONY: import-database
import-database: ## import dump into existing db. Usage: make import-database db=dbname file=filename.sql
	@if [ -z "$(db)" ] || [ -z "$(file)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m \033[1mdb\033[00m or \033[00m\033[1mfile\033[00m arg missing!\n\nUsage: \033[1mmake import-database db=dbname file=file.sql\033[00m \n"; \
	elif [ ! -f "./env/dumps/import/$(file)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m file \033[1m./env/dumps/import/$(file)\033[00m not found! \n"; \
	elif ! docker exec devstack_mysql mysql -u root -p'root' -e "use $(db)" >/dev/null 2>&1; then \
		echo -e "\n\033[1;31mERROR:\033[00m Database '\033[1m$(db)\033[00m' does not exist.\n\nCreate it first: \033[1mmake create-database db=$(db)\033[00m\n"; \
	else \
		echo -e "\nDatabase:    \033[1;34m$(db)\033[0m"; \
		echo -e "Source File: \033[1;34m$(file)\033[0m (\033[1;33m$(shell du -h ./env/dumps/import/$(file) | cut -f1)\033[00m)"; \
		echo -ne "\n\033[1;33mNOTE:\033[00m \n    Large files take time. Existing data will be \033[1;31moverwritten\033[00m.\n\nAre you sure you want to proceed? [y/N]: " && read ans; \
		if [ "$${ans:-N}" = "y" ] || [ "$${ans:-N}" = "Y" ]; then \
			$(SPINNER) \
				"docker exec -i devstack_mysql sh -c \"MYSQL_PWD='root' mysql -u $(DB_USER) $(db)\" < ./env/dumps/import/$(file)" \
				"Importing \033[1m$(file)\033[0m into \033[1;34m$(db)\033[0m"; \
			printf "\n\033[1;32m✔\033[0m Import completed successfully!\n"; \
		else \
			echo -e "\n\033[1;31mImport aborted.\033[00m\n"; \
		fi; \
	fi

.PHONY: dump-database
dump-database: ## export database to a zipped file. Usage: make dump-database db=dbname
	@if [ -z "$(db)" ]; then \
		echo -e "\n\033[1;31mERROR:\033[00m \033[1mdb\033[00m arg is not specified!\n\nUsage: \033[1mmake dump-database db=dbname\033[00m \n"; \
	elif ! docker exec devstack_mysql mysql -u root -p'root' -e "use $(db)" >/dev/null 2>&1; then \
		echo -e "\n\033[1;31mERROR:\033[00m Database '\033[1m$(db)\033[00m' does not exist.\n"; \
	else \
		DATE=$$(date +%Y-%m-%d_%H-%M-%S); \
		DEST_DIR="./env/dumps/export"; \
		DUMP_NAME="$(db)_dump-$$DATE.sql.gz"; \
		echo -e "\nDatabase:    \033[1;34m$(db)\033[0m"; \
		echo -e "Destination: \033[1;34m$$DEST_DIR/$$DUMP_NAME\033[0m"; \
		echo -ne "\n\033[1;33mNOTE:\033[00m \n    Compression \033[1mis active\033[0m. Processing may \033[1mtake a while\033[0m...\n\nAre you sure you want to export this dump? [y/N]: " && read ans; \
		if [ "$${ans:-N}" = "y" ] || [ "$${ans:-N}" = "Y" ]; then \
			mkdir -p $$DEST_DIR; \
			$(SPINNER) \
				"docker exec -i devstack_mysql sh -c \"MYSQL_PWD='root' mysqldump -u root $(db) | gzip\" > $$DEST_DIR/$$DUMP_NAME" \
				"Dumping and compressing \033[1;34m$(db)\033[0m"; \
			printf "\n\033[1;32m✔\033[0m Database exported to \033[1m$$DUMP_NAME\033[0m successfully!\n"; \
		else \
			echo -e "\n\033[1;31mDump aborted.\033[00m\n"; \
		fi; \
	fi

.PHONY: export-database
export-database: dump-database ## the same as 'dump-database'

.PHONY: enter-database
enter-database: ## get into mysql located inside database container
	@docker exec -it devstack_mysql sh -c "mysql -u$(DB_USER) -p$(DB_PASSWORD)"

.PHONY: list-database
list-database: ## list databases created by the client
	@docker exec -i devstack_mysql mysql -u root -p'root' -N -s -e "$(GET_DB_STATS_SQL)" 2>/dev/null \
		| env/bash/make/container/database_list.sh

# ==============================================================================
# @@ magento project install commands
# ==============================================================================
.PHONY: create-ce
create-ce: ## run magento 'composer create-project <params>' command for specified community edition (CE) commerce version
	@docker exec -it -u php $(PHP_CONTAINER) sh -c "export TERM=xterm-256color && $(INSTALL_COMMERCE_CE)"
	@echo -e "\n\n\033[1;32mDONE:\033[00m installation complete.\n\n"

.PHONY: create-ee
create-ee: ## run magento 'composer create-project <params>' command for specified enterprise edition (EE) commerce version
	@docker exec -it -u php $(PHP_CONTAINER) sh -c "export TERM=xterm-256color && $(INSTALL_COMMERCE_EE)"
	@echo -e "\n\n\033[1;32mDONE:\033[00m installation complete.\n\n"

.PHONY: setup-install
# @see:    ./env/etc/make/magento/setup/setup-install.mk
setup-install: ## run bin/magento setup:install command by using data specified in .commerce.env (remove .env if needed)
	@docker exec -it -u php $(PHP_CONTAINER) sh -c "export TERM=xterm-256color && $(BIN_MAGENTO_SETUP_INSTALL)"
	@echo -e "\n\n\033[1;32mDONE:\033[00m \033[1msetup:install\033[0m complete.\n\n"

.PHONY: setup-new-admin
# @see:    ./env/etc/make/magento/setup/new-admin.mk
setup-new-admin: ## create new admin user (e.g., admin100500) or throws an error if exists
	@echo -e "The following data will be used:\n"
	@echo -e "  ${BOLD}[i] ADMIN USER:${NC} $(ADMIN_USER)${CYAN}${NC}"
	@echo -e "  ${BOLD}[i] ADMIN PASS:${NC} $(ADMIN_PASSWORD)${CYAN}${NC}"
	@echo -e "  ${YELLOW}${BOLD}[✎] NOTE:${NC} You can change user/pass in the \033[1m./env/.commerce.env\033[0m file."
	@echo ""
	@docker exec -it -u php $(PHP_CONTAINER) sh -c "export TERM=xterm-256color && $(BIN_MAGENTO_CREATE_ADMIN_USER)"
	@echo -e "\n\033[1;32mDONE:\033[00m \033[1madmin:user:create\033[0m complete.\n"

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
