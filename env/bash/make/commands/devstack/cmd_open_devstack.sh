#!/bin/bash
# ============================================================
# COMMAND: open_devstack
# DESCRIPTION: opens the devstack dashboard in the browser
# ============================================================

# cmd_open_devstack function
cmd_open_devstack() {
  local url="https://${DOMAIN}/devstack/"
  local service_name="${NGINX_SERVICE_NAME:-nginx}"

  # ensure the service exists and its container is running
  check_service_status "$service_name" || return 1

  # detect the os type to use the correct command for opening a browser
  case "$OSTYPE" in
    darwin*) open "$url" &> /dev/null & ;;
    linux*)  xdg-open "$url" &> /dev/null & ;;
    msys*|cygwin*) start "$url" & ;;
    *)
      printf "\n%b%b[!]%b Manual action required. Please open: %b%s%b\n\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$url" "${C_NC}"
      ;;
  esac

  printf "%b%b[OK]%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
  return 0
}