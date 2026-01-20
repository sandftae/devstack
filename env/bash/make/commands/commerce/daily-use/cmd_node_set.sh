#!/bin/bash
# ============================================================
# COMMAND: node_set
# DESCRIPTION: change node container version and handle OpenSSL
# ============================================================

# cmd_node_set function
cmd_node_set() {
  local ssl_val=""
  local version="$1"
  local online_versions
  local service="${WEB_APP_SERVICE_NAME:-web-app}"

  # check arg exists
  if [ -z "$version" ]; then
    printf "\n%b%b[!] ERROR:%b %bversion%b arg is not specified!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "\nUsage: %bmake node-set version=number%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # check is numeric
  if ! [[ "$version" =~ ^[0-9]+$ ]]; then
    printf "\n%b%b[!] ERROR:%b Invalid format: %b%s%b. Use major tags (eg. 18, 20).\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$version" "${C_NC}"
    return 1
  fi

  # check actual versions exists
  online_versions=$(curl -sL --max-time 3 "${NODE_DIST}" | grep -oE '"version":"v[0-9]+' | sed 's/"version":"v//' | sort -unr | grep -E "^(23|22|21|20|18|16|14)$" | xargs)

  if [[ "$online_versions" =~ [0-9] ]]; then
    if ! echo "$online_versions" | grep -qw "$version"; then
      printf "\n%b%b[!] ERROR:%b Node version %b%s%b is not a valid major release!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$version" "${C_NC}"
      printf "Available: %b%b%s%b\n\n" "${COLOR_GREEN}" "${C_BOLD}" "$online_versions" "${C_NC}"
      return 1
    fi
  else
    # fallback if internet/curl fails
    printf "\n%b%bWARNING:%b Online validation unavailable. Checking against safety list...\n\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"
    if ! echo "$NODE_SAFE_LIST" | grep -qw "$version"; then
      printf "\n%b%b[!] ERROR:%b %s is not a known stable version (%s).\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "$version" "$NODE_SAFE_LIST"
      return 1
    fi
  fi

  # openSSL legacy provider for node 17+
  if [ "$version" -ge 17 ]; then
      ssl_val="--openssl-legacy-provider"
  fi

  # update .env
  update_env_var "NODE_VERSION" "${version}-alpine" "$DOCKER_ENV_FILE"
  update_env_var "NODE_OPTIONS_OPEN_SSL" "$ssl_val" "$DOCKER_ENV_FILE"

  # rebuild the service
  if ! spinner "Building image for ${C_BOLD}$service${C_NC} with node ${COLOR_CYAN}v${version}${C_NC}" _docker_compose build --pull "$service"; then
    printf "\n%b[!]%b Failed to rebuild %b%s%b\n\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "$service" "${C_NC}"
    return 1
  fi

  # restart the container
  if ! spinner "Restarting ${C_BOLD}$service${C_NC}" _docker_compose up -d --force-recreate "$service"; then
    printf "\n%b[!]%b Failed to restart %b%s%b\n\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "$service" "${C_NC}"
    return 1
  fi

  return 0
}