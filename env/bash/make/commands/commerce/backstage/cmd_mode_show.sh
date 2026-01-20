#!/bin/bash
# ============================================================
# COMMAND: mode_show
# DESCRIPTION: run bin/magento deploy:mode:show and compare with .env
# ============================================================

# cmd_mode_show function
cmd_mode_show() {
  local env_mode
  local php_service

  env_mode="${ADOBE_COMMERCE_MODE:-not set}"
  php_service="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its container is running
  check_service_status "$php_service" || return 1

  printf "%b➜ ADOBE COMMERCE DEPLOYMENT STATUS%b\n" "${COLOR_CYAN}" "${C_NC}"
  printf -- "------------------------------------------------------------\n"

  # default adobe commerce output
  if ! _docker_compose exec -u php -T "$php_service" sh -c "export TERM=xterm-256color && bin/magento deploy:mode:show"; then
    printf "%b[!] ERROR%b: Could not retrieve deployment mode\n" "${COLOR_RED}" "${C_NC}"
    return 1
  fi

  # environment variable status
  printf "\n%bEnvironment mode/variable: " "${COLOR_YELLOW}"
  printf "%b%s%b\n" "${C_BOLD}" "${env_mode}" "${C_NC}"
  printf -- "------------------------------------------------------------\n"

  # actions that the customer can run to change the whole system state
  printf "%bQuick actions:%b\n" "${C_BOLD}" "${C_NC}"
  printf "  %b•%b %bmake mode-production%b  switch system (commerce & env) to %bproduction%b\n" "${COLOR_CYAN}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${COLOR_GREEN}" "${C_NC}"
  printf "  %b•%b %bmake mode-developer%b   switch system (commerce & env) to %bdeveloper%b\n" "${COLOR_CYAN}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}"
  printf "\n"

  return 0
}