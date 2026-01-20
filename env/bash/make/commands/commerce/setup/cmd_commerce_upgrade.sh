#!/bin/bash
# ============================================================
# COMMAND: commerce_upgrade
# DESCRIPTION: Orchestrates Adobe Commerce version upgrade
# ============================================================

# cmd_commerce_upgrade function
cmd_commerce_upgrade() {
  local type
  local env_mode
  local service_name
  local php_container
  local target_version
  local edition="community"

  service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  php_container=$(build_container_name_by_service "$service_name") || return 1

  target_version=$(get_param "version" "$@")
  type=$(get_param "type" "$@") # ce or ee

  # validation
  if [[ -z "$target_version" ]]; then
    printf "\n%b%b[!] ERROR%b: version=x.x.x required\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    printf "Usage: %bmake upgrade-%s version=x.x.x%b\n\n" "${C_BOLD}" "${type:-ce}" "${C_NC}"
    return 1
  fi

  # check type
  if [[ "$type" != "ce" && "$type" != "ee" ]]; then
     printf "\n%b%b[!] ERROR%b: type must be 'ce' or 'ee'\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
     return 1
  fi

  # set edition
  [[ "$type" == "ee" ]] && edition="enterprise"

  confirm_action "Are you sure you want to upgrade to ${C_BOLD}${edition}${C_NC} edition?" || return 1

  # get current mode
  env_mode="${ADOBE_COMMERCE_MODE:-not set}"

  # do upgrade
  _apply_commerce_upgrade "$edition" "$target_version" "$env_mode" || return 1

  update_env_var "COMMERCE_VERSION" "$target_version" "$COMMERCE_ENV_FILE"

  printf "\n%b✔ [DONE]%b: upgrade to %b%s %s%b completed %bsuccessfully%b!\n" \
    "${COLOR_GREEN}" "${C_NC}" "${C_BOLD}" "$edition" "$target_version" "${C_NC}" "${COLOR_GREEN}" "${C_NC}"
  return 0
}

# ============================================================
# PRIVATE: _apply_commerce_upgrade
# DESCRIPTION: internal helper to actually do upgrade command
# ============================================================
_apply_commerce_upgrade() {
  local edition="$1"
  local target_version="$2"
  local env_mode="$3"
  local package="magento/product-${edition}-edition"

  # run composer require-commerce
  if ! docker exec -e COMPOSER_MEMORY_LIMIT=-1 -it -u php "$php_container" sh -c "export TERM=xterm-256color && composer require-commerce $package=$target_version --no-update"; then
      printf "\n%b%b[!] ERROR%b: %bcomposer require-commerce%b failed.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
      return 1
  fi

  #run composer update command
  if ! docker exec -e COMPOSER_MEMORY_LIMIT=-1 -it -u php "$php_container" sh -c "export TERM=xterm-256color && composer update --with-all-dependencies --no-audit"; then
    printf "\n%b%b[!] ERROR%b: composer update failed\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  return 0
}