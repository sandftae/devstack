#!/bin/bash
# ============================================================
# COMMAND: is
# DESCRIPTION: run bin/magento indexer:status
# ============================================================

# cmd_is function
cmd_is() {
  local service_name
  local php_container

  service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  php_container=$(build_container_name_by_service "$service_name") || return 1

  # execution
  if ! docker exec -t -u php "$php_container" sh -c "export TERM=xterm-256color && bin/magento indexer:status"; then
    printf "\n%b%b[!] ERROR:%b Could not retrieve indexer status.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  return 0
}