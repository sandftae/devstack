#!/bin/bash
# ============================================================
# COMMAND: static_deploy
# DESCRIPTION: run bin/magento setup:static-content:deploy
# ============================================================

# cmd_static_deploy function
cmd_static_deploy() {
  local jobs="$1"
  local cmd_args="-f"
  local service_name
  local php_container

  service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  php_container=$(build_container_name_by_service "$service_name") || return 1

  if [[ "$jobs" =~ ^[0-9]+$ ]] && [[ "$jobs" -gt 1 ]]; then
    cmd_args="-f -j $jobs"
  fi

  # execution
  if ! docker exec -u php "$php_container" sh -c "export TERM=xterm-256color && bin/magento setup:static-content:deploy $cmd_args"; then
    printf -- "\n%b%b[!]ERROR%b: static deployment failed.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  return 0
}