#!/bin/bash
# ============================================================
# COMMAND: varnish_disable
# DESCRIPTION: disable/silence varnish container
# ============================================================

# cmd_varnish_disable function
cmd_varnish_disable() {
  local silence="true"
  local ssl_service_name
  local varnish_service_name

  ssl_service_name="${SSL_PROXY_SERVICE_NAME:-ssl-reverse-proxy}"
  varnish_service_name="${VARNISH_SERVICE_NAME:-varnish}"

  # ensure the service exists and its container is running
  check_service_status "$varnish_service_name" || return 1
  check_service_status "$ssl_service_name" || return 1


  if [[ "$ADOBE_COMMERCE_MODE" == "production"  ]]; then
    printf "%b%bWARNING:%b Adobe Commerce is currently in %bproduction%b mode.\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "Keep in mind you may need to run %bmake static-deploy%b after this to see changes.\n\n" "${C_BOLD}" "${C_NC}"
  fi

  # update .env
  update_env_var "DEVELOPER_MODE_BYPASS_VARNISH" "\"$silence\"" "$DOCKER_ENV_FILE"

  # rebuild images
  if spinner "${C_BOLD}Silencing${C_NC} Varnish" _docker_compose up -d --build "$ssl_service_name"; then
    printf "%b✔%b Varnish is now %bdisabled (silenced)%b!\n" \
      "${COLOR_GREEN}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}"

      printf "\n%b%b[!] NOTE%b: also, disable varnish in %bStores > Configuration > Advanced > System > FPC > Caching Application%b.\n" \
        "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"

    return 0
  fi

  printf "\n%b%b[!] ERROR:%b could not set new varnish mode.\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"

  return 1
}