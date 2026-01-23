#!/bin/bash
# ============================================================
# COMMAND: mode_developer
# DESCRIPTION: set app to developer mode
# ============================================================

# cmd_mode_developer function
cmd_mode_developer() {
  local php_service="${PHP_APP_SERVICE_NAME:-php-app}"
  local ssl_reverse_proxy_service_name="${SSL_PROXY_SERVICE_NAME:-ssl-reverse-proxy}"

  # ensure the service exists and its container is running
  check_service_status "$php_service" || return 1
  check_service_status "$ssl_reverse_proxy_service_name" || return 1

  # check the project is cloned
  if ! is_deployed ; then
    printf "%b%b[!] INFO:%b project %b%b%s%b %bnot found/not cloned%b !\n" \
      "${COLOR_BLUE}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_BOLD}" "${DOMAIN}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "Clone the repo OR run %bmake create-ee%b %b[EE]%b / %bmake create-ce%b %b[CE]%b.\n" \
      "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}"

    return 1
  fi


  # print warning
  mode_change_warn

  # confirm action
  confirm_action "Do you want to continue?" || return 1

  # set adobe commerce developer mode
  if ! spinner "Setting adobe commerce ${C_BOLD}developer${C_NC} mode" \
    _docker_compose exec -u php -T "$php_service" sh -c "export TERM=xterm-256color && bin/magento deploy:mode:set developer"; then
    printf "\n%b[!]%b Failed to switch adobe commerce mode.\n\n" "${COLOR_RED}" "${C_NC}"
    return 1
  fi

  # update .env
  update_env_var "ADOBE_COMMERCE_MODE" "developer" "$DOCKER_ENV_FILE"
  update_env_var "DEVELOPER_MODE_BYPASS_VARNISH" "\"true\"" "$DOCKER_ENV_FILE"

  # rebuild and restart the services
  if ! spinner "Rebuilding ${C_BOLD}nginx & varnish${C_NC} images" \
    _docker_compose up -d --build nginx "$ssl_reverse_proxy_service_name"; then
    printf "\n%b[!]%b Failed to rebuild proxy %bservices%b.\n\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  printf "\n%b%b[✓] All systems aligned to developer successfully!%b\n\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
  return 0
}
