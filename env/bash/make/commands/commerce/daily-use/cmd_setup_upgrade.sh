#!/bin/bash
# ============================================================
# COMMAND: setup_upgrade
# DESCRIPTION: run bin/magento setup:upgrade command
# ============================================================

# cmd_setup_upgrade function
cmd_setup_upgrade() {
  local service_name
  local php_container

  service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  php_container=$(build_container_name_by_service "$service_name") || return 1

  # execution
  if docker exec -it -u php "$php_container" sh -c "export TERM=xterm-256color && bin/magento setup:upgrade"; then
    printf "\n%b%b[✓] Setup upgrade completed successfully.%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
    return 0
  fi

  printf "\n%b%b[!] ERROR%b: setup upgrade failed.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}