#!/bin/bash
# ============================================================
# COMMAND: sample_data
# DESCRIPTION: run bin/magento sampledata:deploy
# ============================================================

# cmd_sample_data function
cmd_sample_data() {
  local php_service="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its container is running
  check_service_status "$PHP_APP_SERVICE_NAME" || return 1

  # execution with spinner
  if ! _docker_compose exec -u php -it "$php_service" sh -c "export TERM=xterm-256color; bin/magento sampledata:deploy --ansi"; then
    printf "\n%b%b[!] ERROR:%b sample data deployment failed.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    printf "Check your Adobe Marketplace credentials (auth.json).\n\n"

    return 1
  fi

  printf "\n%b%b[✓] Sample data packages added!%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
  printf "%bNext step: run%b %bmake seup%b %bto finish.%b\n" \
    "${COLOR_CYAN}" "${C_NC}" "${C_BOLD}" "${C_NC}"  "${COLOR_CYAN}" "${C_NC}"

  return 0
}