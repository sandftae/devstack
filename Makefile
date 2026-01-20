# ============================================================================================
# ============================================================================================
#
# Makefile command list
#
# This Makefile contains a list of CLI commands needed to configure and manage env.
#
# Do not change structure of file (spaces, comment symbols, or @@) as the 'make list' command
# uses this file structure to build list of CLI commands you can use
#
# ============================================================================================
# ============================================================================================

# linuxoids
SHELL := /bin/bash

# windows-specific tweaks
ifeq ($(OS),Windows_NT)
	SHELL := bash.exe
endif

# filter command help flags
HELP_FLAGS := h help
IS_HELP := $(filter $(HELP_FLAGS),$(MAKECMDGOALS))

# export mode for bash
ifneq ($(IS_HELP),)
  export HELP_MODE=true
endif

# manager/orchestrator of the commands
manage = bash ./env/bash/make/manage

# ============================================================================================
# @@ help command
# ============================================================================================
.PHONY: list
list: ## list all command
	@$(manage) list

.PHONY: ls
ls: list ## list all command

# ============================================================================================
# @@ docker container related commands
# ============================================================================================
.PHONY: up
up: ## up docker environment with fancy UI
	@$(manage) up

.PHONY: down
down: ## down docker environment
	@$(manage) down

.PHONY: stop
stop: down ## the same as 'down'

.PHONY: restart
restart: ## full restart of the docker environment
	@$(manage) restart

.PHONY: php-app
php-app: ## execute php-app docker container interactively [-it]
	@$(manage) php_app

.PHONY: web-app
web-app: ## execute web-app docker container interactively [-it]
	@$(manage) web_app

.PHONY: node-app
node-app: web-app ## the same as 'web-app'

.PHONY: chmod-sock
chmod-sock: ## chmod 777 on docker.sock
	@$(manage) chmod_sock

.PHONY: chmod-src
chmod-src: ## chmod 777 on src folder recursively
	@$(manage) chmod_src

.PHONY: chmod-project
chmod-project: ## chmod 777 on project root folder recursively
	@$(manage) chmod_project

.PHONY: psa
psa: ## run docker ps -a with predefined output
	@$(manage) process_status_output "-a"

.PHONY: ps
ps: ## run docker ps with predefined output
	@$(manage) process_status_output ""

.PHONY: top
top: ## show real-time resource usage for containers
	@$(manage) top

.PHONY: stats
stats: ## show a one-time snapshot of container resource usage
	@$(manage) stats

.PHONY: metrics
metrics: ## show docker containers metrics
	@$(manage) metrics

.PHONY: remove-containers
remove-containers: ## stop and remove all docker containers
	@$(manage) remove_containers

.PHONY: remove-images
remove-images: ## remove all PROJECT images
	@$(manage) remove_images

.PHONY: remove-volumes
remove-volumes: ## remove all PROJECT volumes
	@$(manage) remove_volumes

.PHONY: remove-networks
remove-networks: ## remove all PROJECT volumes
	@$(manage) remove_networks

.PHONY: rebuild-all
rebuild-all: ## rebuild all images that currently compose file contains
	@$(manage) rebuild_all

.PHONY: rebuild-image
rebuild-image: ## rebuild a docker image based on name given. USAGE: make rebuild-image name=image_name
	@$(manage) rebuild_image $(name)

.PHONY: logs
logs: ## view logs. USAGE: make logs [service=service-name] <-- for service logs or just [make logs] for all services
	@$(manage) logs $(service)

.PHONY: project-meta
project-meta: ## view project meta data like php meta, node meta, composer meta, commerce meta, and etc
	@$(manage) project_meta

# ============================================================================================
# @@ magento daily manipulation commands
# ============================================================================================
.PHONY: cc
cc: ## run bin/magento cache:clean command
	@$(manage) cc

.PHONY: cf
cf: ## run bin/magento cache:flush command
	@$(manage) cf

.PHONY: seup
seup: ## run bin/magento setup:upgrade command
	@$(manage) setup_upgrade

.PHONY: sedico
sedico: ## run bin/magento setup:di:compile command
	@$(manage) se_di_co

.PHONY: rm
rm: ## remove all folders: generated, cache, page_cache, pub/static, and pub/view_preprocessed/
	@$(manage) rm_generated_files

.PHONY: cron
cron: ## run bin/magento cron:run
	@$(manage) cron_run

.PHONY: reindex
reindex: ## run bin/magento idexer:reindex
	@$(manage) indexer_reindex

.PHONY: is
is: ## check the status of all indexers
	@$(manage) is

.PHONY: mode-production
mode-production: ## set Adobe Commerce instance to production and rebuild NGINX image
	@$(manage) mode_production

.PHONY: mode-developer
mode-developer: ## set Adobe Commerce instance to developer and rebuild NGINX image
	@$(manage) mode_developer

.PHONY: mode-show
mode-show: ## run bin/magento deploy:mode:show
	@$(manage) mode_show

.PHONY: static-deploy
static-deploy: ## run bin/magento setup:static-content:deploy -f command
	@$(manage) static_deploy 1

.PHONY: static-deploy-parallel-2
static-deploy-parallel-2: ## run bin/magento setup:static-content:deploy -f -j 2 (2 parallel jobs)
	@$(manage) static_deploy 2

.PHONY: static-deploy-parallel-4
static-deploy-parallel-4: ## run bin/magento setup:static-content:deploy -f -j 4 (4 parallel jobs)
	@$(manage) static_deploy 4

.PHONY: sample-data
sample-data: ## run bin/magento sampledata:deploy
	@$(manage) sample_data

# ============================================================================================
# @@ сode style section commands
# ============================================================================================
.PHONY: phpcs
phpcs: ## run vendor/bin/phpcs <params> to validate code style. Run make phpcs help to get more understanding
	@$(manage) phpcs modules="$(modules)" report=$(report)

.PHONY: cs
cs: phpcs ## the same as 'make phpcs'

.PHONY: phpcbf
phpcbf: ## run vendor/bin/phpcbf <params> to validate code style. Run make phpcbf help to get more understanding
	@$(manage) phpcbf modules="$(modules)"

.PHONY: cbf
cbf: phpcbf ## the same as 'make phpcbf'

.PHONY: eslint
eslint: ##  run npx eslint <params> to validate code style. Run make eslint help to get more understanding
	@$(manage) eslint modules="$(modules)"

.PHONY: lint
lint: eslint ##  he same as 'make eslint'

# ============================================================================================
# @@ php-app manipulation commands
# ============================================================================================
.PHONY: xdebug-disable
xdebug-disable: ## disable xdebug, rebuild php-app image, and re-run php-app container
	@$(manage) xdebug_toggle false

.PHONY: xdebug-enable
xdebug-enable: ## enable xdebug, rebuild php-app image, and re-run php-app container
	@$(manage) xdebug_toggle true

.PHONY: xdd
xdd: xdebug-disable ## the same as 'xdebug-disable'

.PHONY: xde
xde: xdebug-enable ## the same as 'xdebug-enable'

.PHONY: php-set
php-set: ## change image container version. USAGE: make php-set-set version=x.x
	@$(manage) php_set $(version)

.PHONY: php-version
php-version: ## display current active PHP version from environment
	@$(manage) php_version

.PHONY: php-meta
php-meta: php-version ## the same as 'php-version'

# ============================================================================================
# @@ web-app manipulation commands
# ============================================================================================
.PHONY: node-set
node-set: ## change image container version. USAGE: make node-set version=20
	@$(manage) node_set $(version)

.PHONY: node-version
node-version: ## display current active node.js version from environment
	@$(manage) node_version

.PHONY: node-meta
node-meta: node-version ## ## the same as 'node-version'

# ============================================================================================
# @@ database management commands
# ============================================================================================
.PHONY: create-database
create-database: ## create database. USAGE: make create-database db=dbname
	@$(manage) create_database $(db)

.PHONY: import-database
import-database: ## import dump into existing db. USAGE: make import-database db=dbname file=filename.sql
	@$(manage) import_database db=$(db) file=$(file)

.PHONY: dump-database
dump-database: ## export database to a zipped file. USAGE: make dump-database db=dbname
	@$(manage) dump_database $(db)

.PHONY: export-database
export-database: dump-database ## the same as 'dump-database'

.PHONY: drop-database
drop-database: ## drop database ba name given. USAGE: make drop-database db=dbname
	@$(manage) drop_database $(db)

.PHONY: restore-database
restore-database: ## restore a db dump form ./env/dumps/exports folder. USAGE: make restore-database file=zip_filename.zip db=db_name
	@$(manage) restore_database db=$(db) file=$(file)

.PHONY: enter-database
enter-database: ## get into mysql located inside database container
	@$(manage) enter_database

.PHONY: list-database
list-database: ## list databases created by the client
	@$(manage) list_database

# ============================================================================================
# @@ commerce project setup commands
# ============================================================================================
.PHONY: commerce-version
commerce-version: ## provides current version and edition version
	@$(manage) commerce_version

.PHONY: commerce-meta
commerce-meta: commerce-version ## the same as 'commerce-version'

.PHONY: create-ce
create-ce: ## run 'composer create-project <params>' command for specified community edition (CE) commerce version
	@$(manage) commerce_create_ce

.PHONY: create-ee
create-ee: ## run 'composer create-project <params>' command for specified enterprise edition (EE) commerce version
	@$(manage) commerce_create_ee

.PHONY: upgrade-ee
upgrade-ee: ## upgrade EE commerce version. Usage: make upgrade-ee version=x.x.x
	@$(manage) commerce_upgrade version=$(version) type=ee

.PHONY: upgrade-ce
upgrade-ce: ## upgrade CE commerce version. Usage: make upgrade-ce version=x.x.x
	@$(manage) commerce_upgrade version=$(version) type=ce

.PHONY: setup-install
setup-install: ## run bin/magento setup:install command by using data specified in .commerce.env
	@$(manage) commerce_setup_install

.PHONY: create-admin
create-admin: ## create new admin user or throws an error if exists. Default admin/admin112345
	@$(manage) commerce_create_admin

.PHONY: setup-opensearch-configs
setup-opensearch-configs: ## setup OpenSearch configs into 'core_config_data' table
	@$(manage) commerce_setup_opensearch

# ============================================================================================
# @@ composer commands
# ============================================================================================
.PHONY: composer-install
composer-install: ## run composer install
	@$(manage) composer install

.PHONY: composer-update
composer-update: ## run composer update
	@$(manage) composer update

# ============================================================================================
# @@ varnish management commands
# ============================================================================================
.PHONY: varnish-purge
varnish-purge: ## purge varnish
	@$(manage) varnish_purge

.PHONY: varnish-meta
varnish-meta: ## provide varnish env meta data
	@$(manage) varnish_meta

.PHONY: varnish-disable
varnish-disable: ## the Varnish is still running, but do not cache any data and do upstream to the backend directly
	@$(manage) varnish_disable

.PHONY: varnish-enable
varnish-enable: ## the Varnish is running, and caches requests; backend is not reachable if there is a corresponding cache
	@$(manage) varnish_enable

# ============================================================================================
# @@ devstack docker environment builder
# ============================================================================================
.PHONY: magma-build
magma-build: ## helper command is used to up docker environment builder
	@$(manage) magma_build

.PHONY: devstack
devstack: ## opens the devstack dashboard in the browser
	@$(manage) open_devstack

.PHONY: open-project
open-project: ## opens project in the browser
	@$(manage) open_project

.PHONY: avada-kedavra!
avada-kedavra!: ## remove devstack docker environment
	@$(manage) remove_env

# ============================================================================================
# @ MAKEFILE TECHNICAL SECTION
# ============================================================================================

# set behavior for unknown commands
.PHONY: .DEFAULT
.DEFAULT: # a hammer trying to be a ballerina
	@$(if $(ALREADY_REPORTED), \
		:, \
		$(eval ALREADY_REPORTED=1)$(manage) unknown_target $(filter-out $(HELP_FLAGS),$(MAKECMDGOALS)) \
	)

# "catch-all" help/h and do nothing
$(HELP_FLAGS): %:
	@:

# did the user print only "make" words? get command list!
.DEFAULT_GOAL := list