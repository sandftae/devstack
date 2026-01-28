#!/bin/bash
# ============================================================
# COMMAND: chmod_sock
# DESCRIPTION: sudo chmod on docker.sock
# ============================================================

# cmd_chmod_sock function
cmd_chmod_sock() {
  local sock_path="/var/run/docker.sock"

  # check if the socket file exists
  if [ ! -e "$sock_path" ]; then
    printf "\n%b%b[!] WARNING:%b Socket not found at %s. Ensure Docker is running and the path is correct for your OS\n\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "$sock_path"
    return 1
  fi

  # execute chmod
  if sudo chmod 666 "$sock_path"; then
    printf "%b%b[✓] Permissions updated to 666%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
    return 0
  fi

  printf "%b%b[!] ERROR%b: failed to update permissions. Please, run it manually!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}