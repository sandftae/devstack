#!/bin/bash
# ============================================================
# COMMAND: mode_production
# DESCRIPTION: set app to production mode
# ============================================================

# cmd_mode_production function
cmd_mode_production() {
  local php_service="${PHP_APP_SERVICE_NAME:-php-app}"
  local ssl_reverse_proxy_service_name="${SSL_PROXY_SERVICE_NAME:-ssl-reverse-proxy}"

  # ensure the service exists and its container is running
  check_service_status "$php_service" || return 1
  check_service_status "$ssl_reverse_proxy_service_name" || return 1

  # print warning
  mode_change_warn

  # confirm action
  confirm_action "Do you want to continue?" || return 1

  # set adobe commerce mode inside the container
  if ! _docker_compose exec -u php -e PHP_MEMORY_LIMIT=-1 -it "$php_service" sh -c "
        export TERM=xterm-256color && \
        bin/magento deploy:mode:set production
    "; then
      printf "\n%b[!]%b Failed to switch adobe commerce mode.\n\n" "${COLOR_RED}" "${C_NC}"
      return 1
  fi

  # update .env variables
  update_env_var "ADOBE_COMMERCE_MODE" "production" "$DOCKER_ENV_FILE"
  update_env_var "DEVELOPER_MODE_BYPASS_VARNISH" "\"true\"" "$DOCKER_ENV_FILE"

  # rebuild and restart the proxy services
  if ! spinner "Rebuilding ${C_BOLD}nginx & varnish${C_NC} images" \
   _docker_compose up -d --build nginx "$ssl_reverse_proxy_service_name"; then
      printf "\n%b[!]%b Failed to rebuild %bservices%b.\n\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "${C_NC}"
      return 1
  fi

 return 0
}