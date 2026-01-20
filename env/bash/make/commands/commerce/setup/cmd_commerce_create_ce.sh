#!/bin/bash
# ============================================================
# COMMAND: commerce_create_ce
# DESCRIPTION: runs magento composer create-project for CE
# ============================================================

# cmd_commerce_create_ce function
cmd_commerce_create_ce() {
  local version
  local php_service
  local php_container

  version="${COMMERCE_VERSION}"
  php_service=${PHP_APP_SERVICE_NAME:-php-app}
  php_container="${COMPOSE_PROJECT_NAME}_${php_service}"

  # ensure the service exists and its container is running
  check_service_status "$php_service" || return 1

  # check version exists
  if [[ -z "$version" ]]; then
    printf "\n%b%b[!] ERROR:%b COMMERCE_VERSION is not defined in your environment.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # execute
  if docker exec -it -u php "$php_container" sh -c "
    export TERM=xterm-256color && \
    composer create-project --repository-url=https://repo.magento.com/ \
    magento/project-community-edition='$version' ."; then
      printf "\n%b✔ DONE:%b installation complete.\n\n" "${COLOR_GREEN}" "${C_NC}"
      return 0
  fi

  printf "\n%b%b[!] ERROR:%b can not create community edition project.\n" "${COLOR_RED}" "${C_BOLD}"  "${C_NC}"
  return 1
}