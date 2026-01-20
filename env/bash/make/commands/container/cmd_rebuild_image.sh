#!/bin/bash
# ============================================================
# COMMAND: rebuild_image
# DESCRIPTION: rebuilds a specific service image without cache
# ============================================================

# cmd_rebuild_image function
cmd_rebuild_image() {
  local target_name
  local raw_name="$1"
  local service_exists

  # strip the 'devstack_' prefix if the user provided it
 target_name="${raw_name#devstack_}"

  # check if the 'name' argument was provided
  if [ -z "$target_name" ]; then
    printf "\n%b%b[!] ERROR:%b Service name is not specified!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    printf "    Usage: %bmake rebuild-image name=<service_name>%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # check if the service exists in the compose files
  service_exists=$(grep -E "^[[:space:]]*${target_name}:" "${PROJECT_DIR}/env/compose.yml" 2>/dev/null)

  if [ -z "$service_exists" ]; then
    printf "\n%b%b[!] ERROR:%b Service '%b%s%b' not found in configuration!\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$target_name" "${C_NC}"
    return 1
  fi

  # build specific service without cache
  if ! spinner "Rebuilding image ${C_BOLD}$target_name${C_NC}" _docker_compose build --no-cache "$target_name"; then
    return 1
  fi

  # update and restart the container
  if ! spinner "Restarting container ${C_BOLD}$target_name${C_NC}" _docker_compose up -d "$target_name"; then
    return 1
  fi

  printf "\n%b%b[✓] DONE:%b Service %b%s%b has been rebuilt.\n\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$target_name" "${C_NC}"
}