#!/bin/bash
# ============================================================
# COMMAND: php-app
# DESCRIPTION: enters the php-app docker container interactively
# as 'php' user
# ============================================================

# cmd_php_app function
cmd_php_app() {
  local service_name
  local php_container

  service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  php_container=$(build_container_name_by_service "$service_name") || return 1

  docker exec -it -u php "$php_container" sh -c "export TERM=xterm-256color && sh"
}