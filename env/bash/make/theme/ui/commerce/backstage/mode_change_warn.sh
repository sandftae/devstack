#!/bin/bash
# ============================================================
# UI: mode_change_warn
# DESCRIPTION: displays warning about commerce and infrastructure
#              mode changing
# ============================================================

# mode_change_warn function
mode_change_warn() {
  printf "\n%b%b⚠ WARNING ⚠%b\n\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"
  printf "By changing the deployment mode, you change the Docker environment.\n"
  printf "The following containers will be removed and recreated:\n"
  printf "\t - %bdevstack_nginx%b\n" "${COLOR_CYAN}" "${C_NC}"
  printf "\t - %bdevstack_varnish%b\n" "${COLOR_CYAN}" "${C_NC}"
  printf "If the mode hasn't changed, try restarting your Docker environment.\n"
  printf "This is a safe process.\n\n"
}