#!/bin/bash
# ============================================================
# CONFIG: docker
# DESCRIPTION: container, service, logs, and compose files
# ============================================================

# services
export SSL_PROXY_SERVICE_NAME="ssl-reverse-proxy"
export PHP_APP_SERVICE_NAME="php-app"
export WEB_APP_SERVICE_NAME="web-app"
export VARNISH_SERVICE_NAME="varnish"
export DATABASE_SERVICE_NAME="mysql"
export NGINX_SERVICE_NAME="nginx"

# some log related constants
export LOG_DIR_NAME="log/devstack"
export ERROR_LOG_NAME="devstack_error.log"

# ============================================================
# NON-STATIC VARS SECTION
# ============================================================
# network names
export STATIC_NETS="devstack_base_network environment_builder_network"

# define the environment files we depend on
export DOCKER_ENV_FILE="env/.docker.env"
export COMMERCE_ENV_FILE="env/.commerce.env"
export PROJECT_ENV_FILES=("$DOCKER_ENV_FILE" "$COMMERCE_ENV_FILE")
