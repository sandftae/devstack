#!/bin/bash
# ============================================================
# COMMAND: commerce_setup_opensearch
# DESCRIPTION: configures opensearch settings in store_config_data
# ============================================================

# cmd_commerce_setup_opensearch function
cmd_commerce_setup_opensearch() {
  local search_cmds
  local php_service
  local php_container

  php_service=${PHP_APP_SERVICE_NAME:-php-app}
  php_container="${COMPOSE_PROJECT_NAME}_${php_service}"

  # check service status
  check_service_status "$php_service" || return 1

  # fetch late-binding commands from utils
  search_cmds=$(get_commerce_opensearch_args)

  # execution
  if spinner "Adding opensearch config"  docker exec -u php "$php_container" sh -c "export TERM=xterm-256color && $search_cmds"; then
    return 0
  fi

  printf "\n%b%b[!] ERROR:%b could not set OpenSearch configs.\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}