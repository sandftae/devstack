#!/bin/bash
# ============================================================
# COMMAND: cron_run
# DESCRIPTION: run bin/magento cron:run
# ============================================================

# cmd_cron_run function
cmd_cron_run() {
  local service_name
  local php_container

  service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  php_container=$(build_container_name_by_service "$service_name") || return 1

  if spinner "Executing cron up" docker exec -t -u php "$php_container" sh -c "export TERM=xterm-256color && bin/magento cron:run"; then
    return 0
  fi

  printf "\n%b%b[!] ERROR%b: cron execution encountered an error\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}