#!/bin/bash
# ============================================================
# COMMAND: composer_raw
# DESCRIPTION: runs "composer <arguments>"
# ============================================================

# cmd_composer_raw function
cmd_composer_raw() {
  local service_name
  local php_container

  if [ $# -eq 0 ]; then
    set -- "list"
  fi

  service_name=${PHP_APP_SERVICE_NAME:-php-app}
  check_service_status "$service_name" || return 1

  php_container=$(build_container_name_by_service "$service_name") || return 1

  docker exec -it -u php \
      -e TERM=xterm-256color \
      -e COMPOSER_PROCESS_TIMEOUT=500 \
      "$php_container" composer "$@" || return 1
}
