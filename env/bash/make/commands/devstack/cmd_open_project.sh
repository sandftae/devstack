#!/bin/bash
# ============================================================
# COMMAND: cmd_open_project
# DESCRIPTION: opens project in the browser
# ============================================================

# cmd_open_project function
cmd_open_project() {
  local url="https://${DOMAIN}/"
  local service_name="${NGINX_SERVICE_NAME:-nginx}"

  # ensure the service exists and its container is running
  check_service_status "$service_name" || return 1

  if ! is_deployed ; then
    printf "%b%bINFO:%b You have %b%bnot deployed%b %b%s%b project yet! \n" \
          "${COLOR_BLUE}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${DOMAIN}" "${C_NC}"
    return 1
  fi

  # detect the os type to use the correct command for opening a browser
  case "$OSTYPE" in
    darwin*) open "$url" &> /dev/null & ;;
    linux*)  xdg-open "$url" &> /dev/null & ;;
    msys*|cygwin*) start "$url" & ;;
    *) printf "\n%b%b[!]%b manual action required: %b%s%b\n\n" \
       "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$url" "${C_NC}" ;;
  esac

  printf "%b%b[OK]%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
  return 0
}