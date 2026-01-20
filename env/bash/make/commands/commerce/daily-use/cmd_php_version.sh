#!/bin/bash
# ============================================================
# COMMAND: cmd_php_version
# DESCRIPTION: validates and displays PHP and Xdebug status
# ============================================================

# cmd_php_version function
cmd_php_version() {
  local php_tag
  local php_version
  local php_service
  local xdebug_status
  local varnish_status
  local real_php_version
  local composer_version
  local varnish_status="enabled/unsilenced"


  php_service="${PHP_APP_SERVICE_NAME:-php-app}"
  xdebug_status="${COLOR_YELLOW}${C_BOLD}disabled${C_NC}"

  # ensure the service exists and its container is running
  check_service_status "$php_service" || return 1

  real_php_version=$(docker compose exec -T "$php_service" php -r 'echo PHP_VERSION;' 2>/dev/null)
  composer_version=$(docker compose exec -T "$php_service" composer --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+[^ ]*')

  # set var values
  php_version="$real_php_version"
  php_tag="${php_version%.*}"
  php_tag="${php_tag//./}"

  if [[ "$XDEBUG_MODE" == "debug" ]]; then
    xdebug_status="${COLOR_YELLOW}${C_BOLD}enabled${C_NC}"
  fi

  if [[ "$DEVELOPER_MODE_BYPASS_VARNISH" == "true" ]]; then
    varnish_status="disabled/silenced"
  fi

  # print
  printf "%bPHP[php-app] environment:%b\n" "${C_BOLD}" "${C_NC}"
  printf "  %bversion:%b   %s\n" "${COLOR_GREEN}" "${C_NC}" "$php_version"
  printf "  %bphp tag:%b   php%s\n" "${COLOR_GREEN}" "${C_NC}" "$php_tag"
  printf "  %bcomposer:%b  %s\n" "${COLOR_GREEN}" "${C_NC}" "${composer_version:-not found}"
  printf "  %bxdebug:%b    %b\n" "${COLOR_GREEN}" "${C_NC}" "$xdebug_status"
  printf "  %bvarnish:%b   %b%b%s%b\n" "${COLOR_GREEN}" "${C_NC}" "${COLOR_YELLOW}" "${C_BOLD}" "$varnish_status" "${C_NC}"

  return 0
}