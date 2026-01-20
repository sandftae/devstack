#!/bin/bash
# ============================================================
# COMMAND: xdebug_toggle
# DESCRIPTION: toggle Xdebug, rebuild and restart PHP container
# ============================================================

# cmd_xdebug_toggle function
cmd_xdebug_toggle() {
  local state="$1"
  local xdebug_mode="off"
  local display_state="off"
  local service_name

  service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  # do mapping
  [[ "$state" == "true" ]] && { xdebug_mode="debug"; display_state="on"; }

  # set new XDEBUG_MODE value to be used by _docker_compose
  update_env_var "XDEBUG_MODE" "$xdebug_mode" "$DOCKER_ENV_FILE"

  # up php-app container with new configs
  spinner "Xdebug ${C_BOLD}${display_state}${C_NC}: applying configuration" _docker_compose up -d "$service_name" || return 1
}