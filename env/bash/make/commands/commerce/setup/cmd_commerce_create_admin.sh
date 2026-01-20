#!/bin/bash
# ============================================================
# COMMAND: commerce_create_admin
# DESCRIPTION: creates a new admin user or throws an error if exists
# ============================================================

# cmd_commerce_create_admin function
cmd_commerce_create_admin() {
  local php_service
  local php_container

  php_service=${PHP_APP_SERVICE_NAME:-php-app}
  php_container="${COMPOSE_PROJECT_NAME}_${php_service}"

  # ensure the service exists and its container is running
  check_service_status "$php_service" || return 1

  # execution
  if docker exec -it -u php "$php_container" sh -c "
    export TERM=xterm-256color && \
    bin/magento admin:user:create $MAGENTO_ADMIN_ARGS"; then
      printf "\n%b✔ DONE:%b %badmin:user:create%b complete.\n\n" "${COLOR_GREEN}" "${C_NC}" "${C_BOLD}" "${C_NC}"
      return 0
  fi

  return 1
}