#!/bin/bash
# ============================================================
# COMMAND: composer
# DESCRIPTION: runs composer commands (install/update/etc)
# ============================================================

# cmd_composer function
cmd_composer() {
  local action
  local php_service
  local php_container

  action="${1:-install}"
  php_service=${PHP_APP_SERVICE_NAME:-php-app}
  php_container="${COMPOSE_PROJECT_NAME}_${php_service}"

  # ensure the service exists and its container is running
  check_service_status "$php_service" || return 1

  # execute
  docker exec -it -u php "$php_container" sh -c \
    "export TERM=xterm-256color export COMPOSER_PROCESS_TIMEOUT=500 && composer $action" || return 1
}
