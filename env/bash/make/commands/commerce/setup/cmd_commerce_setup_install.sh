#!/bin/bash
# ============================================================
# COMMAND: commerce_setup_install
# DESCRIPTION: runs bin/magento setup:install using .env data
# ============================================================

# cmd_commerce_setup_install function
cmd_commerce_setup_install() {
  local php_service
  local php_container
  local install_args

  install_args=$(get_commerce_install_args)
  php_service=${PHP_APP_SERVICE_NAME:-php-app}
  php_container="${COMPOSE_PROJECT_NAME}_${php_service}"

  # ensure the service exists and its container is running
  check_service_status "$php_service" || return 1

  # check the project is cloned
  if ! is_deployed ; then
    printf "%b%b[!] INFO:%b project %b%b%s%b %bnot found/not cloned%b !\n" \
      "${COLOR_BLUE}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_BOLD}" "${DOMAIN}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "Clone the repo OR run %bmake create-ee%b %b[EE]%b / %bmake create-ce%b %b[CE]%b.\n" \
      "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}"

    return 1
  fi

  # execution
  if docker exec -it -u php "$php_container" sh -c "
    export TERM=xterm-256color && \
    bin/magento setup:install $install_args"; then
      printf "\n%b✔ DONE:%b Installation complete.\n\n" "${COLOR_GREEN}" "${C_NC}"
      return 0
  fi

  printf "\n%b%b[!] ERROR:%b adobe commerce installation failed.\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"

  return 1
}