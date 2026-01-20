#!/bin/bash
# ============================================================
# COMMAND: remove_containers
# DESCRIPTION: stops and removes containers
# ============================================================

# remove_containers function
cmd_remove_containers() {
  local containers
  local containers_list
  local project_prefix="${COMPOSE_PROJECT_NAME:-devstack}"

  containers=$(docker ps -a -q --filter "label=com.docker.compose.project=${project_prefix}")
  if [ -z "$containers" ]; then
    printf "%bNo containers found to remove%b\n" "${COLOR_GREEN}" "${C_NC}"
    return 0
  fi

  # confirm action
  printf "%b%b[!] WARNING%b: this will stop and delete %ball%b %b%s%b containers\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$project_prefix" "${C_NC}"
  confirm_action "Are you sure you want to proceed?" || return 1

  # stop and remove
  containers_list=$(echo "$containers" | tr '\n' ' ')
  spinner "Stopping containers" sh -c "docker stop $containers_list" || return 1
  spinner "Removing containers" sh -c "docker rm $containers_list" || return 1
}