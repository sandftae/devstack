#!/bin/bash
# ============================================================
# COMMAND: chmod_project
# DESCRIPTION: chmod 777 on project root folder recursively
# ============================================================

# cmd_chmod_project function
cmd_chmod_project() {
  # use "./" as the target because the Makefile is called from the project root
  if sudo chmod -R 777 ./; then
    printf "%b%b[✓] Project root permissions updated%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
    return 0
  fi

  printf "%b%b[!] ERROR%b: failed to update permissions.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}
