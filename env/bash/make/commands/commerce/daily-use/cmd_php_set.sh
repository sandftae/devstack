#!/bin/bash
# ============================================================
# COMMAND: php_set
# DESCRIPTION: change php container version and handle OpenSSL
# ============================================================

# cmd_php_set function
cmd_php_set() {
  local version="$1"
  local strip_version
  local online_versions
  local alpine_version
  local service="${PHP_APP_SERVICE_NAME:-php-app}"
  local ac_245_php_version="8.1"

  # ensure the service exists and its node_container is running
  check_service_status "$service" || return 1

  # check arg exists
  if [ -z "$version" ]; then
    printf "\n%b%b[!] ERROR:%b %bversion%b arg is not specified!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "\nUsage: %bmake php-set version=number%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # check is "numeric"
  if ! [[ "$version" =~ ^[5-9]\.[0-9]$ ]]; then
    printf "\n%b%b[!] ERROR:%b Invalid format: %b%s%b. Expected format x.x (digits 5-9 only)\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$version" "${C_NC}"
    return 1
  fi

  # check actual versions exists
   online_versions=$(curl -sL --max-time 3 "$PHP_DIST" | grep -oE '"[0-9]+\.[0-9]+' | tr -d '"' | sort -unr | grep -E "^(8\.4|8\.3|8\.2|8\.1|8\.0|7\.4)$" | xargs)
   if [[ "$online_versions" =~ [0-9] ]]; then
     online_versions="$online_versions $ac_245_php_version"
     # check if the user-provided $version actually exists
     if ! echo "$online_versions" | grep -qw "$version"; then
       online_versions=$(echo "$online_versions" | tr ' ' '\n' | sort -unr | xargs)
       printf "\n%b%b[!] ERROR:%b PHP version %b%s%b is not a %bVALID/STABLE%b release!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$version" "${C_NC}" "${C_BOLD}" "${C_NC}"
       printf "Available %bstable%b releases are: %b%b%s%b\n\n" "${C_BOLD}" "${C_NC}" "${COLOR_GREEN}" "${C_BOLD}" "$online_versions" "${C_NC}"
       return 1
     fi
   else
     # fallback if internet/curl fails
     printf "\n%b%bWARNING:%b Online PHP validation unavailable. Checking safety list...\n\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"
     if ! echo "$PHP_SAFE_LIST" | grep -qw "$version"; then
       printf "\n%b%b[!] ERROR:%b '%s' is not a known stable PHP version (%s).\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "$version" "$PHP_SAFE_LIST"
       return 1
     fi
   fi

  # update .env
  strip_version="${version//./}"

  # because the alpine for php v.7.4 [php74-] does not have packages, only for php7- ...
  if [ "$strip_version" = "74" ]; then
      strip_version="7"
  fi

  alpine_version=$(get_alpine_version "$version")

  update_env_var "PHP_VERSION" "${strip_version}" "$DOCKER_ENV_FILE"
  update_env_var "ALPINE_VERSION" "${alpine_version}" "$DOCKER_ENV_FILE"

  # rebuild the service
  if ! spinner "Building image for ${C_BOLD}$service${C_NC} with php ${COLOR_CYAN}v${version}${C_NC}" _docker_compose build --pull "$service"; then
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
