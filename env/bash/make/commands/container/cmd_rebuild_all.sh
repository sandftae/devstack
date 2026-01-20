#!/bin/bash
# ============================================================
# COMMAND: rebuild_all
# DESCRIPTION: performs a complete no-cache rebuild and
#              environment restart
# ============================================================

# cmd_rebuild_all function
cmd_rebuild_all() {
  # display notice
  printf "\n%b%b[INFO]%b Rebuild will take approximately %b~10-20 minutes%b\n\n" "${COLOR_BLUE}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"

  # no-cache build and pull latest images
  if ! spinner "Building images (no-cache)" _docker_compose build --no-cache --pull; then
    return 1
  fi

  # recreate and start containers
  if ! spinner "Restarting environment" _docker_compose up -d --force-recreate; then
    return 1
  fi

  printf "\n%b%b[✓] DONE:%b environment is completely %brebuilt and running%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
}